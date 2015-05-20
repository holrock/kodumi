open Core.Std

let col_to_int64 = function
    | Db.Data.INT n -> Some n
    | _ -> None

let col_to_int = function
    | Db.Data.INT n -> Int64.to_int n
    | _ -> None

let col_to_str = function
    | Db.Data.TEXT s -> Some s
    | _ -> None

let review_of_row row =
  let open Option.Monad_infix in
  match
  col_to_int64 row.(0) >>= (fun id ->
  col_to_int64 row.(1) >>= (fun book_id ->
  col_to_int64 row.(2) >>= (fun user_id ->
  col_to_int   row.(3) >>= (fun score ->
  col_to_str   row.(4) >>= (fun body ->
  col_to_str   row.(5) >>= (fun update_at ->
  Option.return (id, book_id, user_id, score, body, update_at)))))))
  with
  | Some (id, book_id, user_id, score, body, update_at) ->
     Ok (Review.create
       ~id:id
       ~book_id:book_id
       ~user_id:user_id
       ~score:score
       ~body:body
       ~update_at:(Time.of_localized_string Time.Zone.local update_at))
  | None -> Or_error.error_string "mapping error"

let find ~db ~book_id =
  Printf.eprintf "id%s\n" (Int64.to_string book_id);
  let reviews = Db.map_row db
     ~query:"select r.id,r.book_id,r.user_id,r.score,r.body,r.update_at,u.name from reviews r join user u on r.user_id = u.id where r.book_id = ?"
     ~params:[Db.Data.INT book_id]
     ~f:review_of_row
  in
  reviews
