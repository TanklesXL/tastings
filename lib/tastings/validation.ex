defmodule Tastings.Validation do
  @moduledoc """
  Validation helpers for struct data.
  """

  @spec validate_string_keys(%{} | struct(), [any()], String.t()) ::
          {:ok, %{}} | {:error, String.t()}
  def validate_string_keys(data, keys, name) do
    keys
    |> Enum.filter(fn key -> Map.get(data, key) === "" end)
    |> case do
      [] ->
        {:ok, data}

      keys ->
        {:error,
         "error building #{name}: " <>
           (keys
            |> Stream.map(&"key #{&1} has no data")
            |> Enum.join(", "))}
    end
  end
end
