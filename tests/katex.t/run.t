  $ why3find doc foo.md foo.mlw
  Generated $TESTCASE_ROOT/html/index.html
  $ cat html/foo.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  
  <link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.18.5/katex.min.css"
      integrity="sha512-eLvr2vghJzBvLDxpgIyx3qrDj1chzZfD4SPOE4otnJPa6GsyJ/lBDGFhZO8OsmyYNnqqjqXOSjHAV1cBax33oA=="
      crossorigin="anonymous" referrerpolicy="no-referrer">
  <script
      src="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.18.5/katex.min.js"
      integrity="sha512-yRrA0fXbfdjHDJXBxj4ABSlaLGZk5HOm5qpvXx6GEjR1t5yCLdenOvN9hzHZhrznHyHVKuIK+QltSR4gc//lQA=="
      crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  <title>Index — foo</title>
  </head>
  <body>
  <nav>
  <a class="toc1" href="#_1">Test for Maths</a>
  </nav>
  <header><a href="index.html" title="Index">Index</a> — Test for Maths
         </header>
  <div class="doc">
  <h1><a id="_1">Test for Maths</a></h1>
  <p>Einstein says <span id="math1">…</span><script>katex.render("e = mc^2", math1,{ throwOnError: false });</script>.</p>
  <p>Equations:</p>
  <p><div class="maths" id="math2">…</div><script>katex.render(" \\int_a^b \\frac{\\partial f}{\\partial x} = f(b) - f(a)", math2,{ throwOnError: false, displayMode: true });</script></p>
  </div>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  $ cat html/foo.index.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Library foo</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library foo</code></header>
  <pre class="src"><span class="keyword">module</span> <a title="foo.Foo" href="foo.Foo.html">Foo</a><a href="foo.proof.html#Foo" title="2 logic parameters" class="icon small remark icofont-question-circle"></a><a href="foo.proof.html#Foo" title="Valid (no goals)" class="icon remark icofont-check"></a></pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  $ cat html/foo.Foo.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  
  <link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.18.5/katex.min.css"
      integrity="sha512-eLvr2vghJzBvLDxpgIyx3qrDj1chzZfD4SPOE4otnJPa6GsyJ/lBDGFhZO8OsmyYNnqqjqXOSjHAV1cBax33oA=="
      crossorigin="anonymous" referrerpolicy="no-referrer">
  <script
      src="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.18.5/katex.min.js"
      integrity="sha512-yRrA0fXbfdjHDJXBxj4ABSlaLGZk5HOm5qpvXx6GEjR1t5yCLdenOvN9hzHZhrznHyHVKuIK+QltSR4gc//lQA=="
      crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  <title>Module foo.Foo</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="foo.index.html">foo</a></code> — <code>module Foo</code></header>
  <pre class="src">
  <span class="keyword">module</span> <span class="scope">Foo</span><a href="foo.proof.html#Foo" title="2 logic parameters" class="icon small remark icofont-question-circle"></a><a href="foo.proof.html#Foo" title="Valid (no goals)" class="icon remark icofont-check"></a>
    <span class="keyword">use</span> real.<a title="real.Real" href="https://www.why3.org/stdlib/real.html#Real_">Real</a>
    <span class="keyword">use</span> real.<a title="real.Square" href="https://www.why3.org/stdlib/real.html#Square_">Square</a>
    <span class="keyword">constant</span> <a id="m">m</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> : real
    <span class="keyword">constant</span> <a id="c">c</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> : real
  </pre>
  <div class="doc">
  <p>Enstein&#39;s famous <span id="math1">…</span><script>katex.render("e = mc^2", math1,{ throwOnError: false });</script>.</p>
  <ul>
  <li><code class="src">m</code> is the mass <span id="math2">…</span><script>katex.render("m\\ge 0", math2,{ throwOnError: false });</script></li>
  <li><code class="src">c</code> is light celerity <span id="math3">…</span><script>katex.render("c>0", math3,{ throwOnError: false });</script></li>
  </ul>
  </div>
  <pre class="src">
    <span class="keyword">function</span> <a id="e">e</a> : real = <a title="foo.Foo.m" href="#m">m</a> <a title="real.Real.(*)" href="https://www.why3.org/stdlib/real.html#infix%20*_20">*</a> <a title="real.Square.sqr" href="https://www.why3.org/stdlib/real.html#sqr_213">sqr</a> <a title="foo.Foo.c" href="#c">c</a>
  
  <span class="keyword">end</span>
  </pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>

