defmodule TastingsWeb.PageLive do
  @moduledoc """
  The main application page for tastings.
  Contains form for URL submission and wraps the resulting card gallery.
  """

  use TastingsWeb, :live_view
  alias TastingsWeb.GalleryLive
  import Phoenix.HTML.Form

  @sources Application.compile_env!(:tastings, :sources)
           |> Stream.map(&{&1.endpoint(), &1})
           |> Enum.into(%{})

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

  def handle_event("submit", session, socket) do
    with {:ok, urls} <- fetch_urls_from_session(session, socket),
         {:ok, scrapers} <- get_scrapers(urls),
         {:ok, cards} <- scrape_cards(scrapers) do
      {:noreply, assign(socket, :cards, cards)}
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
        if source_available?(url),
          do: acc,
          else: Justify.add_error(acc, key, "no supported source available")
    end
  end

  @spec source_available?(String.t()) :: boolean()
  defp source_available?(url) do
    Enum.any?(@sources, fn {endpoint, _source} -> String.starts_with?(url, endpoint) end)
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

  @type source_pair :: {String.t(), Tastings.Sources}
  @type card :: Tastings.Sources.card()
  @type scraper :: (() -> Tastings.Sources.scrape_result())

  @spec get_source(String.t()) :: nil | source_pair
  defp get_source(url) do
    Enum.find(@sources, nil, fn {endpoint, _source} -> String.starts_with?(url, endpoint) end)
  end

  @spec accumulate_sources(binary, [source_pair]) :: {:halt, String.t()} | {:cont, [scraper]}
  defp accumulate_sources(url, acc) do
    case get_source(url) do
      {endpoint, source} ->
        {:cont, [fn -> url |> String.trim_leading(endpoint) |> source.scrape_single() end | acc]}

      _ ->
        {:halt, {:error, "no supported source for #{url}"}}
    end
  end

  @spec get_scrapers([String.t()]) :: {:error, String.t()} | {:ok, [scraper()]}
  defp get_scrapers(urls) do
    urls
    |> Stream.map(&String.trim/1)
    |> Enum.reduce_while([], &accumulate_sources/2)
    |> case do
      {:error, _reason} = err -> err
      scrapers -> {:ok, scrapers}
    end
  end

  @spec scrape_cards([scraper()]) :: {:error, [String.t()]} | {:ok, [Tastings.Sources.card()]}
  defp scrape_cards(scrapers) do
    scrapers
    |> Task.async_stream(fn getter -> getter.() end)
    |> Stream.map(fn {:ok, res} -> res end)
    |> Enum.reduce({[], []}, &collect_scraped_cards/2)
    |> case do
      {cards, []} -> {:ok, cards}
      {_cards, errs} -> {:error, errs}
    end
  end

  @type cards_and_errs :: {[card()], [String.t()]}

  @spec collect_scraped_cards({:ok, [card()]} | {:error, String.t()}, cards_and_errs) ::
          cards_and_errs
  defp collect_scraped_cards({:ok, card}, {cards, errs}), do: {[card | cards], errs}
  defp collect_scraped_cards({:error, err}, {cards, errs}), do: {cards, [err | errs]}
end
