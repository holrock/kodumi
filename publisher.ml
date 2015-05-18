open Core.Std

type t = {
  name : string;
  url : string;
}

let empty = {name = ""; url = ""}

let create ~name ~url = {name; url}

let name t = t.name
let url t = t.url

let to_string t =
  Printf.sprintf "%s [%s]" t.name t.url
