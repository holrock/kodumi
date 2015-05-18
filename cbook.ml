open Core.Std
open Opium.Std
open Cow

let list ~db =
  match Mbook.find ~db with
  | Ok books -> Vbook.list books
  | _  -> assert false

let book ~db ~req =
  let id = Int64.of_string (param req "id") in
  match Mbook.single ~db ~id with
  | Some book -> Some (Vbook.show book)
  | None -> None

let empty () =
  Vbook.new_book Book.empty

let create ~db ~body =
  let open Option.Monad_infix in
  let open List.Assoc in
  match
    find body "title" >>= (fun t ->
    find body "subtitle" >>= (fun s ->
    Some (List.hd_exn t, List.hd_exn s)))
  with
  | Some (t, s) ->
     let book = Book.create
		  ~id:0L
		  ~title:t
		  ~subtitle:s
		  ~authors:[]
		  ~publisher:Publisher.empty
     in
     Mbook.save ~db ~book
  | None -> Or_error.error_string "invalid arguments"
