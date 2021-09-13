defmodule Tastings.Sources do
  @moduledoc """
  Behaviour for web scraping sources.
  """

  @type scrape_result :: {:ok, :models.card()} | {:error, String.t()}

  @callback scrape_single(String.t()) :: scrape_result()
  @callback endpoint() :: String.t()

  @spec compatible?(String.t(), __MODULE__) :: boolean()
  def compatible?(url, source), do: String.starts_with?(url, source.endpoint())

  @spec available?(String.t(), [__MODULE__]) :: boolean()
  def available?(url, sources), do: &Enum.any?(sources, compatible?(url, &1))

  @type scraper :: (() -> scrape_result())

  @spec get_scraper(String.t(), [__MODULE__]) :: nil | scraper
  def get_scraper(url, sources) do
    Enum.find_value(
      sources,
      &if compatible?(url, &1) do
        fn -> url |> String.trim_leading(&1.endpoint()) |> &1.scrape_single() end
      end
    )
  end
end
