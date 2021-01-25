defmodule TastingsWeb.GalleryLive do
  use TastingsWeb, :live_view
  alias TastingsWeb.CardLive

  def mount(_, session, socket) do
    {:ok,
     socket
     |> assign(:view, 0)
     |> assign(:cards, session["cards"])}
  end

  def handle_event("prev", _args, socket) do
    {:noreply, update(socket, :view, &rem(&1 - 1, length(socket.assigns.cards)))}
  end

  def handle_event("next", _args, socket) do
    {:noreply, update(socket, :view, &rem(&1 + 1, length(socket.assigns.cards)))}
  end

  def render(assigns) do
    ~L"""
    <section class="phx-hero">
    <%= if length(@cards) > 1 do %>
      <button phx-click="prev" >Prev</button>
      <button phx-click="next" >Next</button>
    <% end %>
      <%= live_component @socket, CardLive, card: Enum.at(@cards, @view) %>
    </section>
    """
  end
end
