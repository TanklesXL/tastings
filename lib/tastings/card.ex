defmodule Tastings.Card do
  @moduledoc """
  The card details to be scraped from sites.
  """

  @type t :: %__MODULE__{
          name: String.t(),
          brand: String.t(),
          img: String.t(),
          desc: String.t(),
          notes: Tastings.Notes.t()
        }

  @enforce_keys [:name, :img, :desc, :brand, :notes]
  defstruct [:name, :img, :desc, :notes, :brand]

  def from_tuple({:card, name, brand, img, desc, notes}) do
    %__MODULE__{
      name: name,
      brand: brand,
      img: img,
      desc: desc,
      notes: Tastings.Notes.from_tuple(notes)
    }
  end
end
