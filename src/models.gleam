pub type Card {
  Card(name: String, brand: String, img: String, desc: String, notes: Notes)
}

pub type Notes {
  Notes(nose: String, palate: String, finish: String, overall: String)
}
