--------------------------------------------------------------------------
--- Testing Styles
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
  <div class="doc">
  <p>List &amp; Dashes</p>
  <p>Text with normal&ndash;size dash.</p>
  <p>Text with long&mdash;size dash.</p>
  <ul>
  <li>item (a)</li>
  <ul>
  <li>sub&ndash;item (a.1)</li>
  <li>sub&ndash;item (a.2)</li>
  </ul>
  <li>item (b)</li>
  <ul>
  <li>sub&ndash;item (b.1)</li>
  <li>sub&ndash;item (b.2)</li>
  <ul>
  <li>sub&ndash;sub&ndash;item !</li>
  </ul>
  </ul>
  <li>item (c)</li>
  </ul>
  </div>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
--------------------------------------------------------------------------
