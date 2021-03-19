defmodule NotesTest do
  use ExUnit.Case, async: true
  doctest MasterOfMalt.Notes
  import CoreHelpers
  alias MasterOfMalt.Notes

  describe "Notes.new/1" do
    setup notes do
      result =
        notes
        |> notes_html()
        |> parse_and_build(Notes)

      {:ok, [notes: notes, result: result]}
    end

    @tag nose: nose()
    @tag palate: palate()
    @tag finish: finish()
    test "successfully parses html with empty overall field", %{result: result, notes: expected} do
      assert {:ok, actual} = result
      assert_notes(actual, expected)
    end

    @tag nose: nose()
    @tag palate: palate()
    @tag finish: finish()
    @tag overall: overall()
    test "successfully parses complete html", %{result: result, notes: expected} do
      assert {:ok, actual} = result
      assert_notes(actual, expected)
    end

    test "fails to parse when necessary fields are missing", %{result: result} do
      assert {:error, err} = result
      assert_missing_key_errs(err, [:nose, :palate, :finish], "notes")
    end
  end
end
