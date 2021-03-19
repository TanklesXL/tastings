defmodule MasterOfMalt.Notes do
  @moduledoc """
  Notes builder for Master Of Malt.
  """

  alias MasterOfMalt.HTMLHelpers, as: HTML
  alias Tastings.Notes

  @spec new(Floki.html_tree()) :: {:ok, Notes.t()} | {:error, String.t()}
  def new(html) do
    data =
      [
        nose: "#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_noseTastingNote",
        palate: "#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_palateTastingNote",
        finish: "#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_finishTastingNote",
        overall: "#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_overallTastingNote"
      ]
      |> Enum.map(fn {k, v} -> {k, HTML.find_text(html, v)} end)

    Notes
    |> struct(data)
    |> Notes.validate()
  end
end
