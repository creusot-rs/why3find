--------------------------------------------------------------------------
--- Testing Comments
--------------------------------------------------------------------------
  $ why3find doc a.mlw
  Generated $TESTCASE_ROOT/html/index.html
  $ cat html/a.index.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.18.1/dist/katex.min.css" integrity="sha384-1vdNCNel6Tx/NQa8IR1mGOGKsbGreCkOPfbtPPnUURJ5Tu2PRVfQ/7KLZC+Pi1p1" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/katex@0.18.1/dist/katex.min.js" integrity="sha384-ycJ6GAwiS15LoUPipwJOrWTvkUHl/YqELValBwI5I4awP1EeEQJYarj+w85ntcz7" crossorigin="anonymous"></script>
     <title>Library a</title>
  </head>
  <body>
  <header><a href="index.html">index</a> — <code>library a</code></header>
  <pre class="src"><span class="keyword">module</span> <a title="a.Foo" href="a.Foo.html">Foo</a><a href="a.proof.html#Foo" title="Valid (no goals)" class="icon remark icofont-check"></a></pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  $ cat html/a.Foo.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.18.1/dist/katex.min.css" integrity="sha384-1vdNCNel6Tx/NQa8IR1mGOGKsbGreCkOPfbtPPnUURJ5Tu2PRVfQ/7KLZC+Pi1p1" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/katex@0.18.1/dist/katex.min.js" integrity="sha384-ycJ6GAwiS15LoUPipwJOrWTvkUHl/YqELValBwI5I4awP1EeEQJYarj+w85ntcz7" crossorigin="anonymous"></script>
     <title>Module a.Foo</title>
  </head>
  <body>
  <header><a href="index.html">index</a> — <code>library <a href="a.index.html">a</a></code> — <code>module Foo</code></header>
  <pre class="src">
  <span class="keyword">module</span> <span class="scope">Foo</span><a href="a.proof.html#Foo" title="Valid (no goals)" class="icon remark icofont-check"></a>
    <span class="comment">(* Printed
       Huge
       Comment *)</span>
  <span class="keyword">end</span>
  </pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
--------------------------------------------------------------------------
