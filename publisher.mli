open Core.Std

type t

val empty : t
val create : name:string -> url:string -> t
val name : t -> string
val url : t -> string
val to_string : t -> string
