defmodule TastingsWeb.CardLive do
  use TastingsWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <h1><%= @card.name %></h1>
      <h2 class="description-title">Description</h2>
      <p><%= @card.desc %></p>
      <div>
        <img src="<%= @card.img %>" class="whisky-thumbnail"/>
        <div>
          <h3 class="notes-title">Nose:</h3>
          <p class="notes-text"><%= @card.notes.nose %></p>
          <h3 class="notes-title">Palate:</h3>
          <p class="notes-text"><%= @card.notes.palate %></p>
          <h3 class="notes-title">Finish:</h3>
          <p class="notes-text"><%= @card.notes.finish %></p>
          <%= if @card.notes.overall !== ""  do %>
          <h3 class="notes-title">Overall:</h3>
          <p class="notes-text"><%= @card.notes.overall %></p>
          <% end %>
        </div>
        <p style="float:right;">Brand: <%= @card.brand %></p>
      </div>
    </div>
    """
  end
end
