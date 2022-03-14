import gleam/map
import gleam/list
import gleam/int
import gleam/result
import gleam/string
import gleam/dynamic
import floki.{HTMLNode}
import models.{Card, Notes}
import gleam/httpc
import gleam/http.{Get}

const master_of_malt_url = "www.masterofmalt.com"

pub fn endpoint() -> String {
  string.append("https://", master_of_malt_url)
}

pub fn scrape_single(path: String) -> Result(Card, String) {
  try resp =
    http.default_req()
    |> http.set_method(Get)
    |> http.set_host(master_of_malt_url)
    |> http.set_path(path)
    |> httpc.send()
    |> result.replace_error(string.concat([
      "failed to hit url: ",
      master_of_malt_url,
      path,
    ]))

  case resp.status {
    200 ->
      resp.body
      |> floki.parse_document()
      |> result.then(new_card)
    status ->
      Error(string.concat(["unexpected status: HTTP ", int.to_string(status)]))
  }
}

fn text(tree: List(HTMLNode)) -> String {
  floki.text_with_opts(tree, [floki.Deep(False)])
}

fn find_text(html: List(HTMLNode), query: String) -> Result(String, String) {
  let text =
    html
    |> floki.find(query)
    |> text()
    |> string.trim()

  case text {
    "" -> Error(string.concat(["No text found for query: ", query]))
    s -> Ok(s)
  }
}

fn attribute_from_meta(
  html: List(HTMLNode),
  property: String,
) -> Result(String, String) {
  ["[property=\"", property, "\"]"]
  |> string.concat()
  |> floki.find(html, _)
  |> floki.attribute("content")
  |> list.first()
  |> result.replace_error(string.append(
    "No data found for meta property: ",
    property,
  ))
}

const nose_selector = "#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_noseTastingNote"

const palate_selector = "#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_palateTastingNote"

const finish_selector = "#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_finishTastingNote"

const overall_selector = "#ContentPlaceHolder1_ctl00_ctl02_TastingNoteBox_ctl00_overallTastingNote"

pub fn new_notes(html: List(HTMLNode)) -> Result(Notes, String) {
  try nose = find_text(html, nose_selector)
  try palate = find_text(html, palate_selector)
  try finish = find_text(html, finish_selector)
  let overall =
    html
    |> find_text(overall_selector)
    |> result.unwrap("")

  Ok(Notes(nose: nose, palate: palate, finish: finish, overall: overall))
}

const name_meta = "og:title"

const brand_meta = "og:brand"

const img_meta = "og:image"

const desc_meta = "og:description"

pub fn new_card(html: List(HTMLNode)) -> Result(Card, String) {
  try name = attribute_from_meta(html, name_meta)
  try brand = attribute_from_meta(html, brand_meta)
  try img = attribute_from_meta(html, img_meta)
  try desc = attribute_from_meta(html, desc_meta)
  try notes = new_notes(html)
  Ok(Card(name: name, brand: brand, img: img, desc: desc, notes: notes))
}
