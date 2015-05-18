open Core.Std
open Opium.Std
open Cow

let html_of_book book =
 <:html<
<section>
  <hgroup>
    <h4 class="book-title">
      <a href=$str:"/books/" ^ Int64.to_string (Book.id book)$>
        $str:Book.title book$
      </a>
    </h4>
    <h5 class="book-subtitle">$str:Book.subtitle book$</h5>
  </hgroup>
</section>
>>

let html_of_book_list books = <:html<
<article class="book-list">
  $list:List.map books ~f:html_of_book$
</article>
<a href="/books/new">new book</a>
>>

let book_form book = <:html<
  <form action="/books" method="post">
    <label>Title:<input type="text" name="title">$str:Book.title book$</input></label>
    <label>Subtitle:<input type="text" name="subtitle">$str:Book.subtitle book$</input></label>
    <input type="submit" />
  </form>
>>

let list books = View.render (fun () -> html_of_book_list books)

let show book =
  View.render (fun () -> html_of_book book)

let new_book book =
  View.render (fun () -> book_form book)
