open Core.Std

(*
type book_id =
  | ISBN of string
  | Other of string
*)

type t = {
  id : int64;
  title: string;
  subtitle: string;
  authors: Author.t list;
  publisher: Publisher.t;
}

let empty = {
  id = 0L;
  title = "";
  subtitle = "";
  authors = [];
  publisher = Publisher.empty;
}

let create ~id ~title ~subtitle ~authors ~publisher =
  { id; title; subtitle; authors; publisher; }

let id t = t.id
let title t = t.title
let subtitle t = t.subtitle

let to_string t =
  let authors = String.concat ~sep:","(List.map ~f:Author.to_string t.authors) in
  Printf.sprintf "%s -%s- by%s %s" t.title t.subtitle authors (Publisher.to_string t.publisher)
