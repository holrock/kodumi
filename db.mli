open Core.Std

type t

module Data = Sqlite3.Data

val connect : string -> t
val disconnect : t -> bool

val map_row : query:string -> ?params:Data.t list ->
	      f:(Data.t array -> 'a) -> t -> 'a list Or_error.t

val insert : sql:string -> params:Data.t list -> t -> int Or_error.t
