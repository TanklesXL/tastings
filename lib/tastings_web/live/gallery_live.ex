defmodule TastingsWeb.GalleryLive do
  @moduledoc """
  The live view to render a gallery of tastings cards.
  """
  use TastingsWeb, :live_view
  alias TastingsWeb.CardLive

  @impl true
  def mount(_args, %{"cards" => [current | next] = cards}, socket) do
    assigns = [
      count: length(cards),
      prev: [],
      current: current,
      next: next
    ]

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("prev", _args, socket) do
    {:noreply,
     case socket.assigns.prev do
       [] ->
         socket

       [h | t] ->
         socket
         |> assign(:next, [socket.assigns.current | socket.assigns.next])
         |> assign(:prev, t)
         |> assign(:current, h)
     end}
  end

  def handle_event("next", _args, socket) do
    {:noreply,
     case socket.assigns.next do
       [] ->
         socket

       [h | t] ->
         socket
         |> assign(:prev, [socket.assigns.current | socket.assigns.prev])
         |> assign(:next, t)
         |> assign(:current, h)
     end}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <%= if @count > 1 do %>
      <%= if length(@prev) === 0 do %>
        <button disabled phx-click="prev" class="nav-button">&laquo; Prev</button>
      <%else%>
        <button phx-click="prev" class="nav-button">&laquo; Prev</button>
      <% end %>


      <%= if length(@next) === 0 do %>
       <button disabled phx-click="next" class="nav-button">Next &raquo;</button>
      <%else%>
        <button phx-click="next" class="nav-button" >Next &raquo;</button>
      <% end %>

    <% end %>

      <%= live_component @socket, CardLive, card: @current %>
    </div>
    """
  end
end
