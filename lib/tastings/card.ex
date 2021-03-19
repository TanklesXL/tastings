defmodule Tastings.Card do
  @moduledoc """
  The card details to be scraped from sites.
  """

  import Tastings.Validation, only: [validate_string_keys: 3]

  @type t :: %__MODULE__{
          name: String.t(),
          brand: String.t(),
          img: String.t(),
          desc: String.t(),
          notes: Tastings.Notes.t()
        }

  @enforce_keys [:name, :img, :desc, :brand, :notes]
  defstruct [:name, :img, :desc, :notes, :brand]

  def validate(%__MODULE__{} = card) do
    validate_string_keys(card, [:name, :img, :desc, :brand], "card")
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(card) do
      "#{card.name}:\n\t#{card.desc}\nBrand: #{card.brand}\nImage:\t#{card.img}\n#{card.notes}"
    end
  end
end
