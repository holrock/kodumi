open Core.Std
open Opium.Std
open Cow

let html_of_book book = <:html<
<section>
  <hgroup>
    <h4 class="book-title">
      <a href=$str:"/books/" ^ Int64.to_string (Book.id book)$>
        $str:Book.title book$
      </a>
    </h4>
    <h5 class="book-subtitle">$str:Book.subtitle book$</h5>
    <a href=$str:"/books/" ^ Int64.to_string (Book.id book) ^ "/edit"$>edit</a>
  </hgroup>
</section>
>>

let html_of_book_list books = <:html<
<article class="book-list">
  $list:List.map books ~f:html_of_book$
</article>
<a href="/books/new">new book</a>
>>

let book_form ~book ~action = <:html<
  <form action=$str:action$ method="post">
    <label>Title:<input type="text" name="title" value=$str:Book.title book$></input></label>
    <label>Subtitle:<input type="text" name="subtitle" value=$str:Book.subtitle book$></input></label>
    <input type="submit" />
  </form>
>>

let html_of_review = function
| Ok review ->
   <:html<
    <section class="review">
    <p>score:$int:Review.score review$</p>
    <p>$str:Review.body review$</p>
    <p>$str:Time.to_string_abs ~zone:Time.Zone.local (Review.update_at review)$</p>
    </section>
 >>
| Error e ->
  <:html<
      $str:Error.to_string_hum e$
   >>

let html_of_book_reviews book reviews = <:html<
<section>
  <hgroup>
    <h4 class="book-title">
      <a href=$str:"/books/" ^ Int64.to_string (Book.id book)$>
        $str:Book.title book$
      </a>
    </h4>
    <h5 class="book-subtitle">$str:Book.subtitle book$</h5>
    <a href=$str:"/books/" ^ Int64.to_string (Book.id book) ^ "/edit"$>edit</a>
  </hgroup>
  <section class="reviews">
   <h5>reviews:</h5>
   $list: List.map ~f:html_of_review reviews$
  </section>
</section>
>>

let list books = View.render (fun () -> html_of_book_list books)

let show book reviews =
  View.render (fun () -> html_of_book_reviews book reviews)

let edit_book ~book ~action=
  View.render (fun () -> book_form ~book ~action)
