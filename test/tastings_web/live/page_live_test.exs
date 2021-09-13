defmodule TastingsWeb.PageLiveTest do
  use TastingsWeb.ConnCase

  import Phoenix.LiveViewTest

  defp input_field(id) do
    "<input id=\"urls_url_#{id}\" name=\"urls[url_#{id}]\" placeholder=\"URL\" type=\"text\"/>"
  end

  defp scrape_btn(disabled \\ false) do
    disabled = if disabled, do: " disabled=\"disabled\"", else: ""

    "<button class=\"url-submit-button\" phx-disable-with=\"Scraping...\" type=\"submit\"#{
      disabled
    }>Scrape</button>"
  end

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "<h2>Select URLs to scrape</h2>"

    connected_html = render(page_live)
    assert connected_html =~ "<h2>Select URLs to scrape</h2>"
    assert connected_html =~ input_field(1)
    assert connected_html =~ scrape_btn(true)
  end

  test "clicking scrape with empty input fields shows an error", %{conn: conn} do
    {:ok, page_live, _disconnected_html} = live(conn, "/")
    assert render_submit(page_live, :submit) =~ "must submit at least one URL"
  end

  test "clicking add row button adds a new input field", %{conn: conn} do
    {:ok, page_live, _disconnected_html} = live(conn, "/")
    html = render_click(page_live, :add_row)
    assert html =~ input_field(1)
    assert html =~ input_field(2)
    refute html =~ input_field(3)
    assert html =~ scrape_btn(true)
  end

  test "inputing a valid url enables the scrape button", %{conn: conn} do
    {:ok, page_live, _disconnected_html} = live(conn, "/")

    html =
      page_live
      |> form("form", %{"urls[url_1]": ""})
      |> render_change(%{
        "urls[url_1]": "https://www.masterofmalt.com/whiskies/ardbeg/ardbeg-10-year-old-whisky/"
      })

    assert html =~ scrape_btn()
  end

  defp assert_rendered_card(html, card) do
    assert html =~ "<h1>#{card.name}</h1>"
    assert html =~ "<img src=\"#{card.img}\" class=\"whisky-thumbnail\"/>"
    assert html =~ "<h2 class=\"description-title\">Description</h2><p>#{card.desc}</p>"
    assert html =~ "<p style=\"float:right;\">Brand: #{card.brand}</p>"

    notes_text = &"<h3 class=\"notes-title\">#{&1}:</h3><p class=\"notes-text\">#{&2}</p>"
    assert html =~ notes_text.("Nose", card.notes.nose)
    assert html =~ notes_text.("Palate", card.notes.palate)
    assert html =~ notes_text.("Finish", card.notes.finish)
    card.notes.overall && assert html =~ notes_text.("Overall", card.notes.overall)
  end

  @ardbeg_card %Tastings.Card{
    name: "Ardbeg 10 Year Old",
    img: "https://ardbeg-img.png",
    desc: "Very good peaty whisky!",
    brand: "Ardbeg",
    notes: %Tastings.Notes{
      nose:
        "A ridge of vanilla leads to mountain of peat capped with citrus fruits and circled by clouds of sea spray.",
      palate:
        "Sweet vanilla counterbalanced with lemon and lime followed by that surging Ardbeg smoke that we all know and love.",
      finish: "Long and glorious; sea salted caramel and beach bonfire smoke.",
      overall:
        "Precise balance, big smoke and non-chill filtered. This is why this is such a famous dram"
    }
  }

  @glendronach_card %Tastings.Card{
    name: "The GlenDronach 15 Year Old Revival ",
    img: "https://glendro-img.png",
    desc: "Very good sherried whisky!",
    brand: "GlenDronach",
    notes: %Tastings.Notes{
      nose: "Coffee beans, sponge cake drenched in sherry, mint leaf, slightly buttery, sultana.",
      palate:
        "Oily walnut, new leather, blackberry and apple crumble, toasted brown sugar and a touch of liquorice root.",
      finish: "Fresh ginger, waxy orange, caramelised dried fruit and a hint of cigar box."
    }
  }
  defp clear_btn, do: "<button phx-click=\"clear\" class=\"clear-btn\">Clear</button>"

  test "when a card is added the card info is shown", %{conn: conn} do
    {:ok, page_live, _disconnected_html} = live(conn, "/")
    card = @ardbeg_card
    send(page_live.pid, {:cards, [card]})

    html = render(page_live)
    html =~ clear_btn()
    assert_rendered_card(html, card)
  end

  def next_btn(:enabled), do: "<button phx-click=\"next\" class=\"nav-button\">Next »</button>"

  def next_btn(:disabled),
    do: "<button phx-click=\"next\" disabled=\"disabled\" class=\"nav-button\">Next »</button>"

  def prev_btn(:enabled), do: "<button phx-click=\"prev\" class=\"nav-button\">« Prev</button>"

  def prev_btn(:disabled),
    do: "<button phx-click=\"prev\" disabled=\"disabled\" class=\"nav-button\">« Prev</button>"

  test("when cards are added the card info and the gallery nav options are shown", %{conn: conn}) do
    {:ok, page_live, _disconnected_html} = live(conn, "/")

    card1 = @ardbeg_card
    card2 = @glendronach_card
    send(page_live.pid, {:cards, [card1, card2]})

    assert render(page_live) =~ clear_btn()
    assert(gallery_live = find_live_child(page_live, "gallery"))

    assert html = render(gallery_live)
    assert_rendered_card(html, card1)

    assert html =~ next_btn(:enabled)
    assert html =~ prev_btn(:disabled)

    gallery_live
    |> render_click(:prev)
    |> assert_rendered_card(card1)

    assert html = render_click(gallery_live, :next)
    assert_rendered_card(html, card2)

    assert html =~ next_btn(:disabled)
    assert html =~ prev_btn(:enabled)

    html = render_click(gallery_live, :prev)

    assert_rendered_card(html, card1)
    assert html =~ next_btn(:enabled)
    assert html =~ prev_btn(:disabled)
  end

  test "clearing cards resets the page", %{conn: conn} do
    {:ok, page_live, _disconnected_html} = live(conn, "/")

    html = render(page_live)
    assert html =~ "<h2>Select URLs to scrape</h2>"
    assert html =~ input_field(1)
    assert html =~ scrape_btn(true)

    send(page_live.pid, {:cards, [@ardbeg_card]})
    html = render(page_live)
    refute html =~ "<h2>Select URLs to scrape</h2>"
    refute html =~ input_field(1)
    refute html =~ scrape_btn(true)

    html = render_click(page_live, :clear)
    assert html =~ "<h2>Select URLs to scrape</h2>"
    assert html =~ input_field(1)
    assert html =~ scrape_btn(true)
  end
end
