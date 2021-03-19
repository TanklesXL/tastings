defmodule Tastings.Notes do
  @moduledoc """
  The notes details to be scraped from sites.
  """

  import Tastings.Validation, only: [validate_string_keys: 3]

  @type t :: %__MODULE__{
          nose: String.t(),
          palate: String.t(),
          finish: String.t(),
          overall: String.t()
        }

  @enforce_keys [:nose, :palate, :finish]
  defstruct [:nose, :palate, :finish, :overall]

  def validate(%__MODULE__{} = notes), do: validate_string_keys(notes, @enforce_keys, "notes")

  defimpl String.Chars, for: __MODULE__ do
    def to_string(notes) do
      base = "Nose:\t#{notes.nose}\nPalate:\t#{notes.palate}\nFinish:\t#{notes.finish}"

      if notes.overall !== "", do: base <> "\nOverall:\t#{notes.overall}\n", else: base
    end
  end
end
