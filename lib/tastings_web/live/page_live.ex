defmodule TastingsWeb.PageLive do
  use TastingsWeb, :live_view
  alias MasterOfMalt
  alias MasterOfMalt.Boundary.Site
  alias TastingsWeb.GalleryLive

  @starting_input_count 1

  @impl true
  def mount(_args, _session, socket) do
    {
      :ok,
      socket
      |> assign(:cards, [])
      |> assign(:num_inputs, @starting_input_count)
    }
  end

  @impl true
  def handle_event("add_row", _session, socket) do
    {:noreply, assign(socket, :num_inputs, socket.assigns.num_inputs + 1)}
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

  def handle_event("clear", _session, socket), do: {:noreply, assign(socket, :cards, [])}

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero tastings">
      <%= if Enum.empty?(@cards) do %>
      <div>
      <h2>Select URLs to scrape</h2>
        <button type="button" phx-click="add_row" class="add-row-button">Add row</button>
        <form phx-submit="submit">
          <%= for i <- 1..@num_inputs do %>
          <input type="text" name="url_<%= i %>" placeholder="URL"/>
          <% end%>
          <button type="submit" phx-disable-with="Scraping..." class="url-submit-button">Scrape</button>
        </form>
      </div>
      <% else %>
      <%= live_render @socket, GalleryLive, id: "gallery", session: %{"cards" => @cards} %>
      <button phx-click="clear" class="clear-btn">Clear</button>
      <% end %>
    </section>
    """
  end

  defp fetch_urls_from_session(session, socket) do
    @starting_input_count..socket.assigns.num_inputs
    |> Stream.map(&Map.get(session, "url_#{&1}", ""))
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
    |> MasterOfMalt.scrape_many(true)
    |> Enum.reduce({[], []}, &collect_scraped_cards/2)
    |> case do
      {cards, []} -> {:ok, cards}
      {_cards, errs} -> {:error, errs}
    end
  end

  defp extract_url_tag(url), do: String.replace_prefix(url, Site.endpoint(), "")

  defp collect_scraped_cards({:ok, card}, {cards, errs}), do: {cards ++ [card], errs}
  defp collect_scraped_cards({:error, err}, {cards, errs}), do: {cards, errs ++ [err]}
end
