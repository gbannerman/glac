import gleam/int
import gleam/list
import gleam/string

pub fn pt_1(input: #(List(Int), List(Int))) {
  let #(first_list, second_list) = input

  let first_list = first_list |> list.sort(by: int.compare)
  let second_list = second_list |> list.sort(by: int.compare)

  let total = distance_loop(0, first_list, second_list)

  total
}

fn distance_loop(
  total: Int,
  first_list: List(Int),
  second_list: List(Int),
) -> Int {
  case first_list, second_list {
    [first_element, ..rest], [other_first_element, ..other_rest] -> {
      let difference =
        { first_element - other_first_element } |> int.absolute_value
      distance_loop({ total + difference }, rest, other_rest)
    }
    _, _ -> total
  }
}

pub fn pt_2(input: #(List(Int), List(Int))) {
  let #(first_list, second_list) = input

  let total = similarity_loop(0, first_list, second_list)

  total
}

fn similarity_loop(
  total: Int,
  first_list: List(Int),
  second_list: List(Int),
) -> Int {
  case first_list, second_list {
    [first_element, ..rest], other_list -> {
      let similarity = {
        let occurences_in_other_list =
          other_list
          |> list.filter(fn(val) { val == first_element })
          |> list.length
        first_element * occurences_in_other_list
      }
      similarity_loop({ total + similarity }, rest, other_list)
    }
    _, _ -> total
  }
}

pub fn parse(input: String) -> #(List(Int), List(Int)) {
  let lines =
    input
    |> string.split("\n")
    |> list.map(parse_line)

  let first_list =
    lines
    |> list.map(fn(line: #(Int, Int)) { line.0 })

  let second_list =
    lines
    |> list.map(fn(line: #(Int, Int)) { line.1 })

  #(first_list, second_list)
}

fn parse_line(line: String) -> #(Int, Int) {
  let parts =
    line
    |> string.split("   ")

  let assert [a, b] = parts
  let assert Ok(a) = int.parse(a)
  let assert Ok(b) = int.parse(b)

  #(a, b)
}
