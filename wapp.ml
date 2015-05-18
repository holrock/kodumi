open Core.Std
open Opium.Std
open Cow

let db = Db.connect "db/db"
let not_found = respond' (`String "Not found")
let root = get "/" (fun _ -> redirect' (Uri.of_string "/books"))

let book_list =
  get "/books" (fun _ ->
		respond'
		  (`Html ((Cbook.list ~db) |> Html.to_string)))

let book_info =
  get "/books/:id" (fun req ->
		    match Cbook.book ~db ~req with
		    | Some body -> respond' (`Html (Html.to_string body))
		    | None      -> not_found)

let book_new =
  get "/books/new" (fun _ -> respond' (`Html
					(Html.to_string (Cbook.empty ()))))

let book_create =
  post "/books" (fun req ->
		 App.urlencoded_pairs_of_body req >>| (fun body ->
		    match Cbook.create ~db ~body with
		    | Ok _ -> redirect (Uri.of_string "/books")
		    | Error e -> respond (`String (Error.to_string_hum e))))

let _ =
  let _ = Lwt_main.at_exit (fun () ->
			    let _ = Db.disconnect db in Lwt.return ())
  in
  let _ = Lwt_unix.on_signal 2 (fun _ -> exit 0) in
  App.empty
  |> book_info
  |> book_list
  |> book_new
  |> book_create
  |> root
  |> middleware (Middleware.static ~local_path:"./static" ~uri_prefix:"/static")
  |> App.run_command
