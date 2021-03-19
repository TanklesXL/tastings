defmodule Mix.Tasks.Malt do
  @moduledoc """
  A Mix Task for easily scraping Master Of Malt.
  """

  use Mix.Task

  def run(urls) do
    {:ok, _started} = Application.ensure_all_started(:httpoison)

    urls
    |> Task.async_stream(&MasterOfMalt.scrape_single/1)
    |> Stream.map(fn {:ok, result} -> result end)
    |> Stream.map(fn
      {:ok, card} -> "\nSUCCESS:\n#{card}"
      {:error, reason} -> "\nFAILURE: #{reason}"
    end)
    |> Enum.each(&IO.puts/1)
  end
end
