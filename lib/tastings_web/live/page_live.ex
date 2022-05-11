defmodule TastingsWeb.PageLive do
  @moduledoc """
  The main application page for tastings.
  Contains form for URL submission and wraps the resulting card gallery.
  """

  use TastingsWeb, :live_view
  alias TastingsWeb.GalleryLive
  import Phoenix.HTML.Form
  alias Tastings.Sources

  @sources Application.compile_env!(:tastings, :sources)

  @starting_input_count 1

  @initial_state [
    cards: [],
    num_inputs: @starting_input_count,
    urls: Phoenix.HTML.FormData.to_form(:urls, []),
    disable_scrape: true
  ]

  @impl true
  def mount(_args, _session, socket) do
    {:ok, assign(socket, @initial_state)}
  end

  @impl true
  def handle_event("add_row", _session, socket) do
    {
      :noreply,
      socket
      |> update(:num_inputs, &(&1 + 1))
      |> assign(:disable_scrape, true)
    }
  end

  @impl true
  def handle_event("remove_row", _session, socket) do
    {
      :noreply,
      update(socket, :num_inputs, &(&1 - 1))
    }
  end

  def handle_event("submit", session, socket) do
    with {:ok, urls} <- fetch_urls_from_session(session, socket),
         {:ok, scrapers} <- get_scrapers(urls),
         {:ok, cards} <- scrape_cards(scrapers) do
      {:noreply, socket |> clear_flash() |> assign(:cards, cards)}
    else
      {:error, err} when is_list(err) ->
        {:noreply, put_flash(socket, :error, Enum.join(err, ", "))}

      {:error, err} ->
        {:noreply, put_flash(socket, :error, err)}
    end
  end

  def handle_event("clear", _session, socket), do: {:noreply, assign(socket, @initial_state)}

  def handle_event("input", session, socket) do
    url_map_with_atom_keys =
      session["urls"]
      |> Stream.map(fn {key, val} -> {String.to_atom(key), val} end)
      |> Enum.into(%{})

    justify =
      url_map_with_atom_keys
      |> Map.keys()
      |> Enum.reduce(Justify.Dataset.new(url_map_with_atom_keys), &validate_url/2)

    socket =
      socket
      |> update(:urls, &(&1 |> Map.put(:data, justify.data)))
      |> update(:urls, &(&1 |> Map.put(:errors, justify.errors)))
      |> assign(:disable_scrape, not Enum.empty?(justify.errors))

    {:noreply, socket}
  end

  @impl true
  def handle_info({:cards, cards}, socket), do: {:noreply, assign(socket, :cards, cards)}

  defp validate_url(key, acc) do
    url = acc.data[key]

    case String.length(url) do
      0 ->
        Justify.add_error(acc, key, "cannot submit empty field")

      _ ->
        if Sources.available?(url, @sources),
          do: acc,
          else: Justify.add_error(acc, key, "no supported source available")
    end
  end

  defp fetch_urls_from_session(session, socket) do
    urls = Map.get(session, "urls", %{})

    @starting_input_count..socket.assigns.num_inputs
    |> Stream.map(&Map.get(urls, "url_#{&1}", ""))
    |> Enum.reject(&(&1 === ""))
    |> case do
      [] -> {:error, "must submit at least one URL"}
      urls -> {:ok, urls}
    end
  end

  @spec accumulate_scrapers(binary, [Sources.scraper()]) ::
          {:halt, {:error, String.t()}} | {:cont, [Sources.scraper()]}
  defp accumulate_scrapers(url, acc) do
    case Sources.get_scraper(url, @sources) do
      nil ->
        {:halt, {:error, "no supported source for #{url}"}}

      scraper ->
        {:cont, [scraper | acc]}
    end
  end

  @spec get_scrapers([String.t()]) :: {:error, String.t()} | {:ok, [Sources.scraper()]}
  defp get_scrapers(urls) do
    urls
    |> Stream.map(&String.trim/1)
    |> Enum.reduce_while([], &accumulate_scrapers/2)
    |> case do
      {:error, _reason} = err -> err
      scrapers -> {:ok, scrapers}
    end
  end

  @type card_in :: :models.card()

  @spec scrape_cards([Sources.scraper()]) :: {:error, [String.t()]} | {:ok, [Tastings.Card.t()]}
  defp scrape_cards(scrapers) do
    scrapers
    |> Task.async_stream(& &1.())
    |> Stream.map(fn {:ok, res} -> res end)
    |> Enum.reduce({[], []}, &collect_scraped_cards/2)
    |> case do
      {cards, []} -> {:ok, cards}
      {_cards, errs} -> {:error, errs}
    end
  end

  @type cards_and_errs :: {[Tastings.Card.t()], [String.t()]}

  @spec collect_scraped_cards({:ok, [card_in()]} | {:error, String.t()}, cards_and_errs) ::
          cards_and_errs
  defp collect_scraped_cards({:ok, card}, {cards, errs}) do
    {[Tastings.Card.from_tuple(card) | cards], errs}
  end

  defp collect_scraped_cards({:error, err}, {cards, errs}), do: {cards, [err | errs]}

  @impl true
  def render(assigns) do
    ~H"""
    <%= if Enum.empty?(@cards) do %>
    <b>
      <i>Note:</i>
      Tastings currently supports URLs for product pages from <a href="masterofmalt.com">Master of Malt</a>,
      <br/>
      for example:
    </b>
    <a href="https://www.masterofmalt.com/whiskies/arran/arran-10-year-old-whisky">
      https://www.masterofmalt.com/whiskies/arran/arran-10-year-old-whisky
    </a>

    <section class="phx-hero tastings">
        <div>
            <h2>Enter URLs to scrape</h2>
            <%= if @num_inputs > 1 do %>
              <button style="float:left" type="button" phx-click="remove_row" class="add-row-button">Remove row</button>
            <% end %>

            <button style="float:right" type="button" phx-click="add_row" class="add-row-button">Add row</button>

            <form phx-submit="submit" phx-change="input">
                <%= for i <- 1..@num_inputs do %>
                <%= text_input @urls, :"url_#{i}", [placeholder: "URL"] %>
                <div class="url-error-msg">
                    <%= error_tag @urls, :"url_#{i}" %>
                </div>
                <% end %>
                <%= submit  "Scrape", [phx_disable_with: "Scraping...", class: "url-submit-button", disabled: @disable_scrape] %>
            </form>
        </div>
        </section>

        <% else %>
          <section class="phx-hero tastings">
            <%= live_render @socket, GalleryLive, id: "gallery", session: %{"cards" => @cards} %>
            <button phx-click="clear" class="clear-btn">Clear</button>
          </section>
        <% end %>
    """
  end
end
