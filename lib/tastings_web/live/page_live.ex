defmodule TastingsWeb.PageLive do
  use TastingsWeb, :live_view
  alias MasterOfMalt
  alias MasterOfMalt.Boundary.Site
  alias TastingsWeb.GalleryLive

  @impl true
  def mount(_args, _session, socket), do: {:ok, assign(socket, :cards, [])}

  @impl true
  def handle_event("add", %{"urls" => urls}, socket) do
    {cards, errs} =
      case String.trim(urls) do
        "" ->
          {[], ["must submit at least one url"]}

        urls ->
          urls
          |> String.split(",")
          |> Enum.map(&extract_url_tag/1)
          |> MasterOfMalt.scrape_many(true)
          |> Enum.reduce({[], []}, &extract_card/2)
      end

    {:noreply,
     case Enum.empty?(errs) do
       false -> put_flash(socket, :error, Enum.join(errs, ", "))
       true -> assign(socket, :cards, cards)
     end}
  end

  def handle_event("clear", _session, socket), do: {:noreply, assign(socket, :cards, [])}

  @impl true
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
    <%= live_render @socket, GalleryLive, id: "gallery", session: %{"cards" => @cards} %>
    <button phx-click="clear" style="float:left;" >Clear</button>
    <% end %>
    """
  end

  defp extract_url_tag(url), do: String.replace_prefix(url, Site.endpoint(), "")

  defp extract_card({:ok, card}, {cards, errs}), do: {cards ++ [card], errs}
  defp extract_card({:error, err}, {cards, errs}), do: {cards, errs ++ [err]}
end
