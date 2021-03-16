defmodule Tastings.Sources.MasterOfMalt do
  @behaviour Tastings.Sources

  defdelegate scrape_single(url), to: MasterOfMalt
  defdelegate endpoint(), to: MasterOfMalt.Boundary.Site
end
