defmodule Tastings.Notes do
  @moduledoc """
  The notes details to be scraped from sites.
  """

  @type t :: %__MODULE__{
          nose: String.t(),
          palate: String.t(),
          finish: String.t(),
          overall: String.t()
        }

  @enforce_keys [:nose, :palate, :finish]
  defstruct [:nose, :palate, :finish, :overall]

  def from_tuple({:notes, nose, palate, finish, overall}) do
    %__MODULE__{
      nose: nose,
      palate: palate,
      finish: finish,
      overall: overall
    }
  end
end
