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
  | Some book ->
     begin match Mreview.find ~db:db ~book_id:(Book.id book) with
     | Ok reviews -> Some (Vbook.show book reviews)
     | Error e -> Error.raise e
     end
  | None -> None

let empty () =
  Vbook.edit_book ~book:Book.empty ~action:"/books"

let get_req_body body =
  let open Option.Monad_infix in
  let open List.Assoc in
  find body "title" >>= (fun t ->
  find body "subtitle" >>= (fun s ->
  Option.return (List.hd_exn t, List.hd_exn s)))

let create ~db ~body =
  match get_req_body body with
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

let edit ~db ~req =
  let idstr = param req "id" in
  let id = Int64.of_string idstr in
  match Mbook.single ~db ~id with
  | Some book ->
     Some (Vbook.edit_book ~book ~action:("/books/" ^ idstr))
  | None -> None

let update ~db ~req ~body =
  let id = Int64.of_string (param req "id") in
  match get_req_body body with
  | Some (title, subtitle) ->
     Mbook.update ~db ~id ~title ~subtitle
  | None -> Or_error.error_string "invalid arguments"
