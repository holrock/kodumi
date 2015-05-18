open Core.Std
open Opium.Std

val list : db:Db.t -> Cow.Html.t
val book : db:Db.t -> req:Request.t -> Cow.Html.t option
val empty : unit -> Cow.Html.t
val create : db:Db.t -> body:(string * string list) list -> int Or_error.t
