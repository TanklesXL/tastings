defmodule TastingsWeb.CardLive do
  use TastingsWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <h1><%= @card.name %></h1>
      <div>
        <h2 style="text-decoration:underline;">Description</h2>
        <p><%= @card.desc %></p>
        <img src="<%= @card.img %>" style="width:15em;float:right;margin-left:0.75em;"/>
        <div>
          <style>
          h3 {
            text-align: left;
            text-decoration: underline;
          }
          p {
            text-align: left;
          }
          </style>
          <h3>Nose:</h3>
          <p><%= @card.notes.nose %></p>
          <h3>Palate:</h3>
          <p><%= @card.notes.palate %></p>
          <h3>Finish:</h3>
          <p><%= @card.notes.finish %></p>
          <%= if @card.notes.overall !== ""  do %>
          <h3>Overall:</h3>
          <p><%= @card.notes.overall %></p>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
