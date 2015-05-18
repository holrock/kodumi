open Core.Std

type t

val empty : t

val create : name:string -> t

val name : t -> string

val to_string : t -> string
