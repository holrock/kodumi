open Core.Std

val find : db:Db.t -> Book.t list Or_error.t
val single : db:Db.t -> id:int64 -> Book.t option
val save : db:Db.t -> book:Book.t -> int Or_error.t
val update : db:Db.t -> id:int64 -> title:string
	     -> subtitle:string -> int Or_error.t
