defmodule MasterOfMalt.Card do
  @moduledoc """
  Card builder for Master Of Malt.
  """

  alias MasterOfMalt.HTMLHelpers, as: HTML
  alias MasterOfMalt.Notes
  alias Tastings.Card

  @spec new(Floki.html_tree()) :: {:ok, Card.t()} | {:error, String.t()}
  def new(html) do
    case Notes.new(html) do
      {:ok, notes} ->
        %Card{
          name: name(html),
          brand: brand(html),
          img: image_ref(html),
          desc: description(html),
          notes: notes
        }
        |> Card.validate()

      err ->
        err
    end
  end

  defp name(html), do: HTML.attribute_from_meta(html, "og:title")

  defp brand(html), do: HTML.attribute_from_meta(html, "og:brand")

  defp image_ref(html), do: HTML.attribute_from_meta(html, "og:image")

  defp description(html), do: HTML.attribute_from_meta(html, "og:description")
end
