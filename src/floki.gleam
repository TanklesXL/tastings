pub external type HTMLNode

pub external fn parse_document(raw: String) -> Result(List(HTMLNode), String) =
  "Elixir.Floki" "parse_document"

pub external fn find(tree: List(HTMLNode), query: String) -> List(HTMLNode) =
  "Elixir.Floki" "find"

pub external fn attribute(tree: List(HTMLNode), name: String) -> List(String) =
  "Elixir.Floki" "attribute"

pub type FlokiTextOption {
  Deep(Bool)
  Js(Bool)
  Style(Bool)
  Sep(String)
}

// shadow floki.text with this so we can pass #(:deep, false)
pub external fn text_with_opts(
  tree: List(HTMLNode),
  List(FlokiTextOption),
) -> String =
  "Elixir.Floki" "text"
