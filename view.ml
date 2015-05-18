open Core.Std
open Cow

let head title = <:html<
<head>
  <meta charset="utf-8" />
  <title>$str:title$</title>
</head>
>>

let page_header () = <:html<
<header>
  <a href="/">Kodumi</a>
</header>
>>

let render body = <:html<
<html lang="ja">
  $head "Kozumi"$
 <body>
   $page_header ()$
   $body ()$
 </body>
</html>
>>
