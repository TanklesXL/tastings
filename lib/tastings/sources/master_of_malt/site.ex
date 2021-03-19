defmodule MasterOfMalt.Site do
  @moduledoc """
  HTTPoison implementation for scraping Master Of Malt.
  """

  use HTTPoison.Base
  @endpoint "https://www.masterofmalt.com"

  @impl true
  def process_url(url), do: @endpoint <> url

  def endpoint, do: @endpoint
end
