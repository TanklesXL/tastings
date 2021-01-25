defmodule TastingsWeb.CardLive do
  use TastingsWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero" style="display:inline-block;">
      <h1><%= @card.name %></h1>
      <h2>Description</h2>
      <p><%= @card.desc %></p>
      <div>
        <img src="<%= @card.img %>" class="thumbnail" style="height:450px; float:right; padding-left:75px;" />
        <div>
          <h2>Notes</h2>
          <h3 style="text-align:left;">Nose:</h3>
          <p style="font-size:16px; text-align:left;"><%= @card.notes.nose %></p>
          <h3 style=" text-align:left;">Palate:</h3>
          <p style="font-size:16px; text-align:left;"><%= @card.notes.palate %></p>
          <h3 style="text-align:left;">Finish:</h3>
          <p style="font-size:16px; text-align:left;"><%= @card.notes.finish %></p>

          <%= if @card.notes.overall !== ""  do %>
          <h3 style="text-align:left;">Overall:</h3>
          <p style="font-size:16px; text-align:left;"><%= @card.notes.overall %></p>
          <% end %>
        </div>
      </div>
    </section>
    """
  end
end
