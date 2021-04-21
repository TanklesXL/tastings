import core_helpers as helpers
import sources/master_of_malt
import gleam/should
import floki
import gleam/string_builder

pub fn build_card_test() {
  assert Ok(html_nodes) = floki.parse_document(helpers.card_html_no_overall())
  html_nodes
  |> master_of_malt.new_card()
  |> should.equal(Ok(helpers.card_no_overall()))

  assert Ok(html_nodes) = floki.parse_document(helpers.card_html_with_overall())
  html_nodes
  |> master_of_malt.new_card()
  |> should.equal(Ok(helpers.card()))
}

pub fn build_notes_test() {
  assert Ok(html_nodes) = floki.parse_document(helpers.notes_html_no_overall())
  html_nodes
  |> master_of_malt.new_notes()
  |> should.equal(Ok(helpers.notes_no_overall()))

  assert Ok(html_nodes) =
    floki.parse_document(helpers.notes_html_with_overall())
  html_nodes
  |> master_of_malt.new_notes()
  |> should.equal(Ok(helpers.notes_with_overall()))
}
