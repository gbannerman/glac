import gleam/int
import gleam/list
import gleam/option
import gleam/regexp

pub fn pt_1(input: List(Operation)) {
  use total, operation <- list.fold(over: input, from: 0)

  case operation {
    Multiply(a, b) -> total + a * b
    _ -> total
  }
}

pub fn pt_2(input: List(Operation)) {
  let #(total, _) = {
    use #(total, enabled), operation <- list.fold(over: input, from: #(0, True))

    case operation {
      Multiply(a, b) if enabled -> #(total + a * b, enabled)
      Multiply(_, _) -> #(total, enabled)
      Do -> #(total, True)
      Dont -> #(total, False)
    }
  }

  total
}

pub fn parse(input: String) {
  let assert Ok(re) =
    regexp.from_string("mul\\((\\d{1,3}),(\\d{1,3})\\)|do\\(\\)|don't\\(\\)")
  let matches = regexp.scan(with: re, content: input)

  matches |> list.map(map_regex_match_to_operation)
}

pub type Operation {
  Multiply(a: Int, b: Int)
  Do
  Dont
}

fn map_regex_match_to_operation(match: regexp.Match) {
  let regexp.Match(content:, submatches:) = match

  case content {
    match if match == "do()" -> Do
    match if match == "don't()" -> Dont
    _ ->
      case submatches {
        [a, b] -> {
          case a, b {
            option.Some(a), option.Some(b) -> {
              case int.parse(a), int.parse(b) {
                Ok(a), Ok(b) -> Multiply(a, b)
                _, _ -> panic as "a or b is not a number"
              }
            }
            _, _ -> panic as "a or b is missing"
          }
        }
        _ -> panic as "Found mul without two numbers"
      }
  }
}
