defmodule TastingsWeb.PageLive do
  use TastingsWeb, :live_view
  alias MasterOfMalt
  alias MasterOfMalt.Boundary.Site
  alias TastingsWeb.GalleryLive

  @impl true
  def mount(_args, _session, socket), do: {:ok, assign(socket, :cards, [])}

  @impl true
  def handle_event("add", %{"urls" => urls}, socket) do
    {:noreply,
     case String.trim(urls) do
       "" ->
         put_flash(socket, :error, "must submit at least one url")

       urls ->
         urls
         |> String.split(",")
         |> Enum.map(&extract_url_tag/1)
         |> MasterOfMalt.scrape_many(true)
         |> Enum.reduce(socket, &assign_card/2)
     end}
  end

  def handle_event("clear", _session, socket), do: {:noreply, assign(socket, :cards, [])}

  def render(assigns) do
    ~L"""
    <%= if Enum.empty?(@cards) do %>
      <section class="phx-hero">
        <h1><%= gettext "Welcome to %{name}!", name: "Tastings" %></h1>
        <form phx-submit="add">
            <textarea name="urls" placeholder="Comma separated list of URLs" style="resize:vertical;"></textarea>
            <button type="submit" phx-disable-with="Scraping...">Scrape</button>
        </form>
      </section>
    <% else %>
      <button phx-click="clear" style="float:right;">Clear</button>
      <%= live_render @socket, GalleryLive, id: "gallery", session: %{"cards" => @cards} %>
    <% end %>
    """
  end

  defp extract_url_tag(url), do: String.replace_prefix(url, Site.endpoint(), "")

  defp assign_card({:ok, card}, socket) do
    socket
    |> assign(:cards, socket.assigns.cards ++ [card])
  end

  defp assign_card({:error, err}, socket) do
    socket
    |> put_flash(:error, err)
  end
end
