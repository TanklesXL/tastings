defmodule Tastings.Source do
  @type notes :: %{
          nose: String.t(),
          palate: String.t(),
          finish: String.t(),
          overall: String.t()
        }

  @type card :: %{
          name: String.t(),
          brand: String.t(),
          img: String.t(),
          desc: String.t(),
          notes: notes
        }

  @callback scrape_single(String.t()) :: {:ok, card} | {:error, String.t()}
  @callback endpoint() :: String.t()
end
