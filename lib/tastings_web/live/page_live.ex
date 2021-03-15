defmodule TastingsWeb.PageLive do
  use TastingsWeb, :live_view
  alias MasterOfMalt
  alias MasterOfMalt.Boundary.Site, as: MoM
  alias TastingsWeb.GalleryLive
  import Phoenix.HTML.Form

  @starting_input_count 1

  @initial_state [
    cards: [],
    num_inputs: @starting_input_count
  ]

  @impl true
  def mount(_args, _session, socket) do
    {:ok, assign(socket, @initial_state)}
  end

  @impl true
  def handle_event("add_row", _session, socket) do
    {:noreply, update(socket, :num_inputs, &(&1 + 1))}
  end

  def handle_event("submit", session, socket) do
    with {:ok, urls} <- fetch_urls_from_session(session, socket),
         {:ok, cards} <- process_urls(urls) do
      {:noreply, assign(socket, :cards, cards)}
    else
      {:error, err} when is_list(err) ->
        {:noreply, put_flash(socket, :error, Enum.join(err, ", "))}

      {:error, err} ->
        {:noreply, put_flash(socket, :error, err)}
    end
  end

  def handle_event("clear", _session, socket), do: {:noreply, assign(socket, @initial_state)}

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero tastings">
      <%= if Enum.empty?(@cards) do %>
      <div>
      <h2>Select URLs to scrape</h2>
        <button type="button" phx-click="add_row" class="add-row-button">Add row</button>
        <%=  form_for :urls, "#", [phx_submit: "submit"], fn f -> %>
          <%= for i <- 1..@num_inputs do %>
          <%= text_input f, :"url_#{i}", [placeholder: "URL"] %>
          <%= error_tag f, :"url_#{i}" %>
          <% end %>
          <%= submit  "Scrape", [phx_disable_with: "Scraping...", class: "url-submit-button"] %>
        <% end %>
      </div>
      <% else %>
      <%= live_render @socket, GalleryLive, id: "gallery", session: %{"cards" => @cards} %>
      <button phx-click="clear" class="clear-btn">Clear</button>
      <% end %>
    </section>
    """
  end

  @impl true
  def handle_info({:cards, cards}, socket), do: {:noreply, assign(socket, :cards, cards)}

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

  defp process_urls(urls) do
    urls
    |> Stream.map(&String.trim/1)
    |> Stream.map(&extract_url_tag/1)
    |> Task.async_stream(&MasterOfMalt.scrape_single/1)
    |> Stream.map(fn {:ok, res} -> res end)
    |> Enum.reduce({[], []}, &collect_scraped_cards/2)
    |> case do
      {cards, []} -> {:ok, cards}
      {_cards, errs} -> {:error, errs}
    end
  end

  defp extract_url_tag(url), do: String.replace_prefix(url, MoM.endpoint(), "")

  defp collect_scraped_cards({:ok, card}, {cards, errs}), do: {cards ++ [card], errs}
  defp collect_scraped_cards({:error, err}, {cards, errs}), do: {cards, errs ++ [err]}
end
