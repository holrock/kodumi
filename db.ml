open Core.Std

type t = {
  db : Sqlite3.db;
}

module Data = Sqlite3.Data

let connect connection_string =
  { db = Sqlite3.db_open connection_string }

let disconnect t =
  print_endline "disconnect";
  Sqlite3.db_close t.db

let rc_to_error rc = Or_error.error_string (Sqlite3.Rc.to_string rc)

(*
let exec ~stmt t =
  match Sqlite3.exec t.db stmt with
  | Sqlite3.Rc.OK -> Ok (Sqlite3.changes t.db)
  | _ as rc -> rc_to_error rc
 *)

let bind_params ~stmt ~params =
  let open Sqlite3 in
  let rec bp stmt pos = function
    | [] -> Rc.OK
    | p::ps ->
        let open Sqlite3 in
        match bind stmt pos p with
        | Rc.OK -> bp stmt (pos + 1) ps
        | rc -> rc
  in
  match params with
  | []   -> Rc.OK
  | p -> bp stmt 1 p

type row_iter =
  | Row of Data.t array
  | Done
  | Db_error of Sqlite3.Rc.t

let fetch_row ~stmt =
  let open Sqlite3 in
  match step stmt with
  | Rc.ROW -> Row (row_data stmt)
  | Rc.DONE -> Done
  | rc -> Db_error rc

let map_row ~query ?(params=[]) ~f t =
  let db = t.db in
  let stmt = Sqlite3.prepare db query in
  let rec fetch stmt f acc =
    match fetch_row ~stmt with
    | Row row ->
        fetch stmt f ((f row)::acc)
    | Done ->
        ignore (Sqlite3.finalize stmt);
        Ok (List.rev acc)
    | Db_error e ->
        ignore (Sqlite3.finalize stmt);
        rc_to_error e
  in
  match bind_params ~params:params ~stmt:stmt with
  | Sqlite3.Rc.OK ->
     begin try
	 fetch stmt f []
       with e -> ignore (Sqlite3.finalize stmt);
		 raise e
     end
  | rc -> rc_to_error rc

let insert ~sql ~params t =
  let stmt = Sqlite3.prepare t.db sql in
  match bind_params ~params:params ~stmt:stmt with
  | Sqlite3.Rc.OK ->
     (match Sqlite3.step stmt with
      | Sqlite3.Rc.OK | Sqlite3.Rc.DONE ->
	  ignore (Sqlite3.finalize stmt);
	  Ok (Sqlite3.changes t.db)
      | rc -> ignore (Sqlite3.finalize stmt);
	      rc_to_error rc
     )
  | rc -> rc_to_error rc

let update ~sql ~params t =
  let stmt = Sqlite3.prepare t.db sql in
  match bind_params ~params:params ~stmt:stmt with
  | Sqlite3.Rc.OK ->
     (match Sqlite3.step stmt with
      | Sqlite3.Rc.OK | Sqlite3.Rc.DONE ->
	  ignore (Sqlite3.finalize stmt);
	  Ok (Sqlite3.changes t.db)
      | rc -> ignore (Sqlite3.finalize stmt);
	      rc_to_error rc
     )
  | rc -> rc_to_error rc
