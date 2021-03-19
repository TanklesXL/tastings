defmodule MasterOfMalt.HTMLHelpers do
  @moduledoc """
  HTML helper functions for parsing pages on Master Of Malt.
  """

  @spec find_text(binary() | Floki.html_tree(), binary()) :: String.t()
  def find_text(html, selector) do
    html
    |> Floki.find(selector)
    |> Floki.text(deep: false)
    |> String.trim()
  end

  @spec attribute_from_meta(binary() | Floki.html_tree(), binary()) :: String.t()
  def attribute_from_meta(html, property) do
    html
    |> Floki.find("[property=\"#{property}\"]")
    |> Floki.attribute("content")
    |> List.first()
  end
end
