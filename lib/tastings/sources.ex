defmodule Tastings.Sources do
  @moduledoc """
  Behaviour for web scraping sources.
  """

  @type scrape_result :: {:ok, :models.card()} | {:error, String.t()}

  @callback scrape_single(String.t()) :: scrape_result()
  @callback endpoint() :: String.t()
end
