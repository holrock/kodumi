open Core.Std

let book_of_row row =
  let id = match row.(0) with | Db.Data.INT n -> n | _ -> 0L in
  Book.create
    ~id:id
    ~title:(Db.Data.to_string row.(1))
    ~subtitle:(Db.Data.to_string row.(2))
    ~authors:[]
    ~publisher:Publisher.empty

let find ~db =
  Db.map_row db ~query:"select id,title,subtitle from books"
    ~f:book_of_row

let single ~db ~id =
  match Db.map_row db
	     ~query:"select id,title,subtitle from books where id = ?"
	     ~params:[Db.Data.INT id]
	     ~f:book_of_row
  with
  | Ok books ->
     (match books with
     | [] -> None
     | b::_  -> Some b)
  | Error e -> Error.raise e

let save ~db ~book =
  let sql = "insert into books (title, subtitle) values (?, ?)" in
  let params = [Db.Data.TEXT (Book.title book);
		Db.Data.TEXT (Book.subtitle book)] in
  Db.insert ~sql ~params db
