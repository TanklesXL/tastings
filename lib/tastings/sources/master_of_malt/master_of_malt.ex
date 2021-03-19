defmodule MasterOfMalt do
  @moduledoc """
  The business logic for scraping Master Of Malt.
  """

  alias HTTPoison.{Error, Response}
  alias MasterOfMalt.Card
  alias MasterOfMalt.Site

  @type card_result :: {:error, String.t()} | {:ok, Card.t()}

  @spec scrape_single(binary) :: card_result()
  def scrape_single(url) do
    with {:ok, %Response{status_code: code, body: body}} when code < 400 <-
           Site.get(url, [], follow_redirect: true),
         {:ok, html} <- Floki.parse_document(body),
         {:ok, _card} = res <- Card.new(html) do
      res
    else
      {:ok, %Response{status_code: code}} ->
        {:error, error_message(url, "unexpected status: HTTP #{code}")}

      {:error, %Error{reason: reason}} ->
        {:error, error_message(url, reason)}

      {:error, reason} ->
        {:error, error_message(url, reason)}
    end
  end

  defp error_message(url, reason), do: "failed on #{url}: #{reason}"
end
