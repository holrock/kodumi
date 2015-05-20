open Core.Std

type t = {
    id : int64;
    book_id : int64;
    user_id : int64;
    score : int;
    body : string;
    update_at : Time.t
  }

let create ?(id=0L) ~book_id ~user_id ~score ~body ~update_at =
  { id; book_id; user_id; score; body; update_at }

let score t = t.score
let body t = t.body
let update_at t = t.update_at
