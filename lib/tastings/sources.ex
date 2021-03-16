defmodule Tastings.Sources do
  @moduledoc """
  Behaviour for web scraping sources.
  """

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

defmodule Tastings.Sources.MasterOfMalt do
  @moduledoc """
  Callback adapters for masterofmalt.com
  """

  @behaviour Tastings.Sources
  defdelegate scrape_single(url), to: MasterOfMalt
  defdelegate endpoint(), to: MasterOfMalt.Boundary.Site
end
