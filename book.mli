open Core.Std

type t

val empty : t
val create : id:int64 -> title:string -> subtitle:string ->
             authors:Author.t list -> publisher:Publisher.t -> t
val id : t -> int64
val title : t -> string
val subtitle : t -> string
val to_string : t -> string
