defmodule TastingsWeb.GalleryLive do
  use TastingsWeb, :live_view
  alias TastingsWeb.CardLive

  @impl true
  def mount(_, session, socket) do
    {:ok,
     socket
     |> assign(:view, 0)
     |> assign(:cards, session["cards"])}
  end

  @impl true
  def handle_event(opt, _args, socket) do
    {:noreply, update(socket, :view, new_index(opt, socket))}
  end

  defp new_index("prev", socket), do: &rem(&1 - 1, length(socket.assigns.cards))
  defp new_index("next", socket), do: &rem(&1 + 1, length(socket.assigns.cards))

  @impl true
  def render(assigns) do
    ~L"""
    <section class=phx-hero>
      <%= if length(@cards) > 1 do %>
      <button phx-click="prev" >Prev</button>
      <button phx-click="next" >Next</button>
      <% end %>
      <%= live_component @socket, CardLive, card: Enum.at(@cards, @view) %>
    </section>
    """
  end
end
