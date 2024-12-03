import gleam/bool
import gleam/int
import gleam/list
import gleam/option
import gleam/string

// 591
pub fn pt_1(input: List(List(Int))) {
  use total, report <- list.fold(over: input, from: 0)

  case report |> is_safe {
    True -> total + 1
    False -> total
  }
}

pub fn pt_2() {
  todo as "part 2 not implemented"
}

fn is_safe(report: List(Int)) {
  case levels_loop(True, report, option.None, Descending) {
    True -> True
    False -> levels_loop(True, report, option.None, Ascending)
  }
}

type Direction {
  Ascending
  Descending
}

fn levels_loop(
  is_valid: Bool,
  remaining_levels: List(Int),
  previous_level: option.Option(Int),
  direction: Direction,
) -> Bool {
  use <- bool.guard(when: is_valid == False, return: False)

  case remaining_levels {
    [first_level, ..rest] -> {
      let next_is_valid =
        is_valid_next_level(previous_level, first_level, direction)
      levels_loop(next_is_valid, rest, option.Some(first_level), direction)
    }
    _ -> is_valid
  }
}

fn is_valid_next_level(
  previous_level: option.Option(Int),
  next_level: Int,
  direction: Direction,
) {
  case previous_level {
    option.Some(level) -> {
      let difference = case direction {
        Ascending -> {
          next_level - level
        }
        Descending -> {
          level - next_level
        }
      }

      case difference {
        1 | 2 | 3 -> True
        _ -> False
      }
    }
    option.None -> True
  }
}

pub fn parse(input: String) -> List(List(Int)) {
  let reports =
    input
    |> string.split("\n")
    |> list.map(fn(line) { line |> string.split(" ") |> list.map(assert_int) })

  reports
}

fn assert_int(input: String) {
  let assert Ok(number) = input |> int.parse
  number
}
