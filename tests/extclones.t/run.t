--------------------------------------------------------------------------
--- Generating Documentation
--------------------------------------------------------------------------
  $ why3find doc foo.mlw bar.mlw
  Generated $TESTCASE_ROOT/html/index.html
--------------------------------------------------------------------------
--- Generated Files
--------------------------------------------------------------------------
  $ cat html/foo.*.html html/bar.*.html html/*.proof.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Module foo.A</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="foo.index.html">foo</a></code> — <code>module A</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>A</span><a href="foo.proof.html#A" title="2 logic parameters, 1 hypothesis, 1 ground instance" class="icon small valid icofont-star"></a><a href="foo.proof.html#A" title="Valid (no goals)" class="icon remark icofont-check"></a>
    <span class=keyword>type</span> <a><div class=anchor id="a"></div>a</a><span title="Parameter" class="icon small remark icofont-question-circle"></span>
    <span class=keyword>predicate</span> <a><div class=anchor id="eq"></div>eq</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> (x y: <a title="foo.A.a" href="#a">a</a>)
    <span class=keyword>axiom</span> <a><div class=anchor id="refl"></div>refl</a><span title="Hypothesis with ground instance" class="icon small valid icofont-star"></span>: <span class=keyword>forall</span> x y. <a title="foo.A.eq" href="#eq">eq</a> x y
  <span class=keyword>end</span>
  </pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
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
  <pre class=src><span class=keyword>module</span> <a title="foo.A" href="foo.A.html">A</a><a href="foo.proof.html#A" title="2 logic parameters, 1 hypothesis, 1 ground instance" class="icon small valid icofont-star"></a><a href="foo.proof.html#A" title="Valid (no goals)" class="icon remark icofont-check"></a></pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Library foo</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="foo.index.html">foo</a></code> — <code>proofs</code></header>
  <h1>Proofs</h1>
  <div class=dashboard>
  <div class=tab>
  <pre class="src crc"><span class=keyword>module</span> <a href="foo.A.html"><div class=anchor id="A"></div>foo.A</a><span title="2 logic parameters, 1 hypothesis, 1 ground instance" class="icon small valid icofont-star"></span><span title="Valid (no goals)" class="icon remark icofont-check"></span></pre>
  <pre class="src crc">
    <span class=keyword>axiom</span> <a href="foo.A.html#refl"><div class=anchor id="A.refl"></div>refl</a><span title="witnessed hypothesis" class="icon small valid icofont-star"></span>
    <span class=keyword>instance</span> <a href="bar.B.html#clone-4">bar.B</a><span title="sound instance" class="icon small valid icofont-star"></span>
  </pre>
  </div>
  </div>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Module bar.B</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="bar.index.html">bar</a></code> — <code>module B</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>B</span><a href="bar.proof.html#B" title="1 logic parameter" class="icon small remark icofont-question-circle"></a><a href="bar.proof.html#B" title="Failed (no proof)" class="icon failed icofont-error"></a>
    <span class=keyword>use</span> int.<a title="int.Int" href="https://www.why3.org/stdlib/int.html#Int_">Int</a>
  
    <span class=keyword>clone</span> foo.<a title="foo.A" href="foo.A.html">A</a> <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a name="clone-4" href="foo.A.html">foo.A</a> *)</span>
        <span class=keyword>predicate</span> <a href="foo.A.html#eq" title="bar.B.A.eq&#013;(cloned from foo.A.eq)"><div class=anchor id="A.eq"></div>A.eq</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> int int
        <span class=codelense>No proof</span>
        <span class=keyword>lemma</span> <a href="foo.A.html#refl" title="bar.B.A.refl&#013;(cloned from foo.A.refl)"><div class=anchor id="A.refl"></div>A.refl</a><a href="bar.proof.html#B.A.refl" title="Failed (no proof)" class="icon failed icofont-error"></a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="1 logic parameter" class="icon small remark icofont-question-circle"></span><span title="Failed (no proof)" class="icon failed icofont-error"></span> <span class=keyword>with</span> <span class=keyword>type</span> <a title="foo.A.a" href="foo.A.html#a">a</a> = int
  
  <span class=keyword>end</span>
  </pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Library bar</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library bar</code></header>
  <pre class=src><span class=keyword>module</span> <a title="bar.B" href="bar.B.html">B</a><a href="bar.proof.html#B" title="1 logic parameter" class="icon small remark icofont-question-circle"></a><a href="bar.proof.html#B" title="Failed (no proof)" class="icon failed icofont-error"></a></pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Library bar</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="bar.index.html">bar</a></code> — <code>proofs</code></header>
  <h1>Proofs</h1>
  <div class=dashboard>
  <div class=tab>
  <pre class="src crc"><span class=keyword>module</span> <a href="bar.B.html"><div class=anchor id="B"></div>bar.B</a><span title="1 logic parameter" class="icon small remark icofont-question-circle"></span><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre>
  <pre class="src crc">
    <span class=keyword>goal</span> <a href="bar.B.html#A.refl"><div class=anchor id="B.A.refl"></div>A.refl</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre></div>
  </div>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Library bar</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="bar.index.html">bar</a></code> — <code>proofs</code></header>
  <h1>Proofs</h1>
  <div class=dashboard>
  <div class=tab>
  <pre class="src crc"><span class=keyword>module</span> <a href="bar.B.html"><div class=anchor id="B"></div>bar.B</a><span title="1 logic parameter" class="icon small remark icofont-question-circle"></span><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre>
  <pre class="src crc">
    <span class=keyword>goal</span> <a href="bar.B.html#A.refl"><div class=anchor id="B.A.refl"></div>A.refl</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre></div>
  </div>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Library foo</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="foo.index.html">foo</a></code> — <code>proofs</code></header>
  <h1>Proofs</h1>
  <div class=dashboard>
  <div class=tab>
  <pre class="src crc"><span class=keyword>module</span> <a href="foo.A.html"><div class=anchor id="A"></div>foo.A</a><span title="2 logic parameters, 1 hypothesis, 1 ground instance" class="icon small valid icofont-star"></span><span title="Valid (no goals)" class="icon remark icofont-check"></span></pre>
  <pre class="src crc">
    <span class=keyword>axiom</span> <a href="foo.A.html#refl"><div class=anchor id="A.refl"></div>refl</a><span title="witnessed hypothesis" class="icon small valid icofont-star"></span>
    <span class=keyword>instance</span> <a href="bar.B.html#clone-4">bar.B</a><span title="sound instance" class="icon small valid icofont-star"></span>
  </pre>
  </div>
  </div>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
