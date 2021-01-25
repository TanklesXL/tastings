defmodule TastingsWeb.PageLive do
  use TastingsWeb, :live_view
  alias MasterOfMalt
  alias MasterOfMalt.Boundary.Site
  alias TastingsWeb.GalleryLive

  @impl true
  def mount(_args, _session, socket), do: {:ok, assign(socket, :cards, [])}

  @impl true
  def handle_event("add", %{"urls" => ""}, socket), do: {:noreply, socket}

  def handle_event("add", %{"urls" => urls}, socket) do
    {:noreply,
     urls
     |> String.split(",")
     |> Enum.map(&extract_url_tag/1)
     |> MasterOfMalt.scrape_many(true)
     |> Enum.reduce(socket, &assign_card/2)}
  end

  def handle_event("clear", _session, socket), do: {:noreply, assign(socket, :cards, [])}

  defp extract_url_tag(url), do: String.replace_prefix(url, Site.endpoint(), "")

  defp assign_card({:ok, card}, socket) do
    assign(socket, :cards, socket.assigns.cards ++ [card])
  end

  defp assign_card({:error, err}, socket), do: put_flash(socket, :error, err)
end
