defmodule CardTest do
  use ExUnit.Case, async: true
  doctest MasterOfMalt.Card
  alias MasterOfMalt.Card
  import CoreHelpers

  describe "Card.new/1" do
    setup data do
      result =
        data
        |> card_html()
        |> parse_and_build(Card)

      {:ok, [data: data, result: result]}
    end

    @tag name: name()
    @tag img: img()
    @tag desc: desc()
    @tag brand: brand()
    @tag notes: notes_map()
    test "successfully parses html with empty overall field", %{result: result, data: expected} do
      assert {:ok, actual} = result
      assert_card(actual, expected)
    end

    test "fails to parse when notes are missing", %{result: result} do
      assert {:error, err} = result
      assert_missing_key_errs(err, [:nose, :palate, :finish], "notes")
    end

    @tag notes: notes_map()
    test "fails to parse when name, brand, img and desc are missing", %{result: result} do
      assert {:error, err} = result
      assert_missing_key_errs(err, [:name, :img, :desc, :brand], "card")
    end
  end
end
