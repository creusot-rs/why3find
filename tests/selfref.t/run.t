  $ why3find doc foo.mlw bar.mlw
  Generated $TESTCASE_ROOT/html/index.html
  $ cat html/bar.A.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.18.1/dist/katex.min.css" integrity="sha384-1vdNCNel6Tx/NQa8IR1mGOGKsbGreCkOPfbtPPnUURJ5Tu2PRVfQ/7KLZC+Pi1p1" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/katex@0.18.1/dist/katex.min.js" integrity="sha384-ycJ6GAwiS15LoUPipwJOrWTvkUHl/YqELValBwI5I4awP1EeEQJYarj+w85ntcz7" crossorigin="anonymous"></script>
     <title>Module bar.A</title>
  </head>
  <body>
  <header><a href="index.html">index</a> — <code>library <a href="bar.index.html">bar</a></code> — <code>module A</code></header>
  <pre class="src">
  <span class="keyword">module</span> <span class="scope">A</span><a href="bar.proof.html#A" title="Valid (no goals)" class="icon remark icofont-check"></a>
    <span class="keyword">use</span> foo.<a title="foo.A" href="foo.A.html">A</a>
  <span class="keyword">end</span>
  </pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
