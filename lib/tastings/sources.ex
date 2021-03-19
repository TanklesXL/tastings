defmodule Tastings.Sources do
  @moduledoc """
  Behaviour for web scraping sources.
  """

  @type scrape_result :: {:ok, Tastings.Card.t()} | {:error, String.t()}

  @callback scrape_single(String.t()) :: scrape_result()
  @callback endpoint() :: String.t()
end

defmodule Tastings.Sources.MasterOfMalt do
  @moduledoc """
  Callback adapters for masterofmalt.com
  """

  @behaviour Tastings.Sources
  defdelegate scrape_single(url), to: MasterOfMalt
  defdelegate endpoint(), to: MasterOfMalt.Site
end
