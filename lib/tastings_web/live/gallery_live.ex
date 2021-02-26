defmodule TastingsWeb.GalleryLive do
  use TastingsWeb, :live_view
  alias TastingsWeb.CardLive

  @impl true
  def mount(_args, %{"cards" => [current | next] = cards}, socket) do
    {
      :ok,
      socket
      |> assign(:count, length(cards))
      |> assign(:prev, [])
      |> assign(:current, current)
      |> assign(:next, next)
    }
  end

  @impl true
  def handle_event("prev", _args, socket) do
    case socket.assigns.prev do
      [] ->
        {:noreply, socket}

      [h | t] ->
        {:noreply,
         socket
         |> assign(:next, [socket.assigns.current | socket.assigns.next])
         |> assign(:prev, t)
         |> assign(:current, h)}
    end
  end

  def handle_event("next", _args, socket) do
    case socket.assigns.next do
      [] ->
        {:noreply, socket}

      [h | t] ->
        {:noreply,
         socket
         |> assign(:prev, [socket.assigns.current | socket.assigns.prev])
         |> assign(:next, t)
         |> assign(:current, h)}
    end
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <%= if @count > 1 do %>
      <button
        phx-click="prev"
        <%= if length(@prev) === 0 do %>disabled<% end %>
        class="nav-button"
      >&laquo; Prev</button>
      <button
        phx-click="next"
        <%= if length(@next) === 0 do %>disabled<% end %>
        class="nav-button"
      >Next &raquo;</button>
      <% end %>
      <%= live_component @socket, CardLive, card: @current %>
    </div>
    """
  end
end
