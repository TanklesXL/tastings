import thingy
import gleam/should

pub fn hello_world_test() {
  thingy.hello_world()
  |> should.equal("Hello, from thingy!")
}
