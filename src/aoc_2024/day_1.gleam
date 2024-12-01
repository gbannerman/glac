import gleam/int
import gleam/list
import gleam/string

pub fn pt_1(input: #(List(Int), List(Int))) {
  let #(first_list, second_list) = input

  let first_list = first_list |> list.sort(by: int.compare)
  let second_list = second_list |> list.sort(by: int.compare)

  use total, #(a, b) <- list.fold(list.zip(first_list, second_list), from: 0)

  let difference = { a - b } |> int.absolute_value

  total + difference
}

pub fn pt_2(input: #(List(Int), List(Int))) {
  let #(first_list, second_list) = input

  use total, value <- list.fold(first_list, from: 0)

  let occurrences = second_list |> list.count(fn(e) { e == value })

  total + { value * occurrences }
}

pub fn parse(input: String) -> #(List(Int), List(Int)) {
  let assert [first_list, second_list] =
    input
    |> string.split("\n")
    |> list.map(fn(line) { line |> string.split("   ") |> list.map(assert_int) })
    |> list.transpose

  #(first_list, second_list)
}

fn assert_int(input: String) {
  let assert Ok(number) = input |> int.parse
  number
}
