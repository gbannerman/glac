import gleam/int
import gleam/list
import gleam/option
import gleam/regexp

pub fn pt_1(input: List(Multiplier)) {
  use total, multiplier <- list.fold(over: input, from: 0)

  total + multiplier.a * multiplier.b
}

pub fn pt_2(input: List(Multiplier)) {
  todo as "part 2 not implemented"
}

pub fn parse(input: String) {
  let assert Ok(re) = regexp.from_string("mul\\((\\d{1,3}),(\\d{1,3})\\)")
  let matches = regexp.scan(with: re, content: input)

  matches |> list.map(map_regex_match_to_multiplier)
}

pub type Multiplier {
  Multiplier(a: Int, b: Int)
}

fn map_regex_match_to_multiplier(match: regexp.Match) {
  let regexp.Match(content: _, submatches:) = match

  case submatches {
    [a, b] -> {
      case a, b {
        option.Some(a), option.Some(b) -> {
          case int.parse(a), int.parse(b) {
            Ok(a), Ok(b) -> Multiplier(a, b)
            _, _ -> panic as "a or b is not a number"
          }
        }
        _, _ -> panic as "a or b is missing"
      }
    }
    _ -> panic as "Found mul without two numbers"
  }
}
