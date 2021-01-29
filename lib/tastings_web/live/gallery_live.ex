defmodule TastingsWeb.GalleryLive do
  use TastingsWeb, :live_component
  alias TastingsWeb.CardLive

  @impl true
  def mount(socket), do: {:ok, assign(socket, :view, 0)}

  @impl true
  def handle_event(opt, _args, socket) do
    {:noreply, update(socket, :view, new_index(opt, socket))}
  end

  defp new_index("prev", socket), do: &rem(&1 - 1, length(socket.assigns.cards))
  defp new_index("next", socket), do: &rem(&1 + 1, length(socket.assigns.cards))

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <%= if length(@cards) > 1 do %>
      <button phx-click="prev" phx-target="<%= @myself %>">&laquo; Prev</button>
      <button phx-click="next" phx-target="<%= @myself %>">Next &raquo;</button>
      <% end %>
      <%= live_component @socket, CardLive, card: Enum.at(@cards, @view) %>
    </div>
    """
  end
end
