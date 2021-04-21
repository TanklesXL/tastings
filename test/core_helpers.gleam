import models.{Card, Notes}
import gleam/should
import gleam/string
import floki
import gleam/string_builder

const brand = tuple("brand", "Ardbeg")

const name = tuple("title", "Ardbeg 10 Year Old")

const desc = tuple(
  "description",
  "A phenomenal whisky packing powerful peaty deliciousness, Ardbeg 10 Year Old is a favourite of many whisky lovers around the world.
Produced on the Kildalton Coast of Islay, this single malt matures for a decade before being bottled without any chill-filtration.
If you're after a whisky with full of coastal air, smoke and more, this is exactly what you want.",
)

const img = tuple(
  "image",
  "https://cdn2.masterofmalt.com/whiskies/p-2813/ardbeg/ardbeg-10-year-old-whisky.jpg?ss=2.0",
)

fn meta(property: String, content: String) -> String {
  string.concat([
    "<meta content=\"",
    content,
    "\" property=\"og:",
    property,
    "\"/>",
  ])
}

fn html_metas() -> String {
  string.concat([
    meta(name.0, name.1),
    meta(brand.0, brand.1),
    meta(desc.0, desc.1),
    meta(img.0, img.1),
  ])
}

const nose = tuple(
  "ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_noseTastingNote",
  "A ridge of vanilla leads to mountain of peat capped with citrus fruits and circled by clouds of sea spray.",
)

const palate = tuple(
  "ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_palateTastingNote",
  "Sweet vanilla counterbalanced with lemon and lime followed by that surging Ardbeg smoke that we all know and love.",
)

const finish = tuple(
  "ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_finishTastingNote",
  "Long and glorious; sea salted caramel and beach bonfire smoke.",
)

const overall = tuple(
  "ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_overallTastingNote",
  "Precise balance, big smoke and non-chill filtered. This is why this is such a famous dram.",
)

fn note_html(id: String, content: String) {
  string.concat(["<p id=\"", id, "\">", "<b>XXX:</b>", content, "</p>"])
}

pub fn notes_html_no_overall() -> String {
  string.concat([
    note_html(nose.0, nose.1),
    note_html(palate.0, palate.1),
    note_html(finish.0, finish.1),
  ])
}

pub fn notes_html_with_overall() -> String {
  string.concat([notes_html_no_overall(), note_html(overall.0, overall.1)])
}

pub fn card_html_no_overall() -> String {
  string.concat([html_metas(), "<div>", notes_html_no_overall(), "</div>"])
}

pub fn card_html_with_overall() -> String {
  string.concat([html_metas(), "<div>", notes_html_with_overall(), "</div>"])
}

pub fn notes_no_overall() -> Notes {
  Notes(nose: nose.1, palate: palate.1, finish: finish.1, overall: "")
}

pub fn notes_with_overall() -> Notes {
  let notes = notes_no_overall()
  Notes(..notes, overall: overall.1)
}

pub fn card_no_overall() -> Card {
  Card(
    name: name.1,
    brand: brand.1,
    img: img.1,
    desc: desc.1,
    notes: notes_no_overall(),
  )
}

pub fn card() -> Card {
  Card(
    name: name.1,
    brand: brand.1,
    img: img.1,
    desc: desc.1,
    notes: notes_with_overall(),
  )
}
