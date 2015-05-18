open Core.Std

type t = {
  name : string;
}

let empty = {name = "unknown"}

let create ~name = {name}

let name t = t.name

let to_string t = t.name
