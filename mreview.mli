open Core.Std

val find   : db:Db.t -> book_id:int64 -> Review.t Or_error.t list Or_error.t
(*
val single : db:Db.t -> id:int64 -> Review.t option
let save   : db:Db.t -> review:Review.t -> int64 Or_error.t
let update : db:Db.t -> id:int64 ->
	     review:Review.t -> int Or_error.t
 *)
