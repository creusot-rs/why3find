--------------------------------------------------------------------------
--- Generating Documentation
--------------------------------------------------------------------------
  $ why3find doc clones.mlw
  Generated $TESTCASE_ROOT/html/index.html
--------------------------------------------------------------------------
--- Generated Files
--------------------------------------------------------------------------
  $ cat html/clones.*.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Module clones.AC</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="clones.index.html">clones</a></code> — <code>module AC</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>AC</span><a href="clones.proof.html#AC" title="2 logic parameters, 2 hypotheses, 1 ground instance" class="icon small valid icofont-star"></a><a href="clones.proof.html#AC" title="Valid (no goals)" class="icon remark icofont-check"></a>
    <span class=keyword>clone</span> <span class=keyword>export</span> <a title="clones.Monoid" href="clones.Monoid.html">Monoid</a> <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a name="clone-3" href="clones.Monoid.html">clones.Monoid</a> *)</span>
        <span class=keyword>type</span> <a href="clones.Monoid.html#t" title="clones.AC.t&#013;(cloned from clones.Monoid.t)"><div class=anchor id="t"></div>t</a><span title="Parameter" class="icon small remark icofont-question-circle"></span>
        <span class=keyword>function</span> <a href="clones.Monoid.html#op" title="clones.AC.op&#013;(cloned from clones.Monoid.op)"><div class=anchor id="op"></div>op</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> <a title="clones.AC.t" href="clones.AC.html#t">t</a> <a title="clones.AC.t" href="clones.AC.html#t">t</a> : <a title="clones.AC.t" href="clones.AC.html#t">t</a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="2 logic parameters" class="icon small remark icofont-question-circle"></span> 
    <span class=keyword>clone</span> <span class=keyword>export</span> <a title="clones.Commutative" href="clones.Commutative.html">Commutative</a> <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a name="clone-4" href="clones.Monoid.html">clones.Monoid</a> *)</span>
        <span class=comment>(* cloned <a name="clone-7" href="clones.Commutative.html">clones.Commutative</a> *)</span>
        <span class=keyword>axiom</span> <a href="clones.Commutative.html#commutative" title="clones.AC.commutative&#013;(cloned from clones.Commutative.commutative)"><div class=anchor id="commutative"></div>commutative</a><span title="Hypothesis with ground instance" class="icon small valid icofont-star"></span>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="1 hypothesis" class="icon small warning icofont-warning-alt"></span> <span class=keyword>with</span> <span class=keyword>type</span> M.<a title="clones.Commutative.M.t" href="clones.Commutative.html#M.t">t</a> = <a title="clones.AC.t" href="#t">t</a>, <span class=keyword>function</span> M.<a title="clones.Commutative.M.op" href="clones.Commutative.html#M.op">op</a> = <a title="clones.AC.op" href="#op">op</a>, <span class=keyword>axiom</span> .
    <span class=keyword>clone</span> <span class=keyword>export</span> <a title="clones.Associative" href="clones.Associative.html">Associative</a> <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a name="clone-8" href="clones.Monoid.html">clones.Monoid</a> *)</span>
        <span class=comment>(* cloned <a name="clone-11" href="clones.Associative.html">clones.Associative</a> *)</span>
        <span class=keyword>axiom</span> <a href="clones.Associative.html#associative" title="clones.AC.associative&#013;(cloned from clones.Associative.associative)"><div class=anchor id="associative"></div>associative</a><span title="Hypothesis with ground instance" class="icon small valid icofont-star"></span>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="1 hypothesis" class="icon small warning icofont-warning-alt"></span> <span class=keyword>with</span> <span class=keyword>type</span> <a title="clones.Associative.t" href="clones.Associative.html#t">t</a><a href="#t" title="clones.AC.t" class="icon small remark icofont-question-circle"></a>, <span class=keyword>function</span> <a title="clones.Associative.op" href="clones.Associative.html#op">op</a><a href="#op" title="clones.AC.op" class="icon small remark icofont-question-circle"></a>, <span class=keyword>axiom</span> .
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
  <title>Module clones.Associative</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="clones.index.html">clones</a></code> — <code>module Associative</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>Associative</span><a href="clones.proof.html#Associative" title="2 logic parameters, 1 hypothesis, 3 ground instances" class="icon small valid icofont-star"></a><a href="clones.proof.html#Associative" title="Valid (no goals)" class="icon remark icofont-check"></a>
    <span class=keyword>clone</span> <span class=keyword>export</span> <a title="clones.Monoid" href="clones.Monoid.html">Monoid</a> <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a name="clone-3" href="clones.Monoid.html">clones.Monoid</a> *)</span>
        <span class=keyword>type</span> <a href="clones.Monoid.html#t" title="clones.Associative.t&#013;(cloned from clones.Monoid.t)"><div class=anchor id="t"></div>t</a><span title="Parameter" class="icon small remark icofont-question-circle"></span>
        <span class=keyword>function</span> <a href="clones.Monoid.html#op" title="clones.Associative.op&#013;(cloned from clones.Monoid.op)"><div class=anchor id="op"></div>op</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> <a title="clones.Associative.t" href="clones.Associative.html#t">t</a> <a title="clones.Associative.t" href="clones.Associative.html#t">t</a> : <a title="clones.Associative.t" href="clones.Associative.html#t">t</a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="2 logic parameters" class="icon small remark icofont-question-circle"></span> 
    <span class=keyword>axiom</span> <a><div class=anchor id="associative"></div>associative</a><span title="Hypothesis with ground instance" class="icon small valid icofont-star"></span>: <span class=keyword>forall</span> x y z. <a title="clones.Associative.op" href="#op">op</a> x (<a title="clones.Associative.op" href="#op">op</a> y z) = <a title="clones.Associative.op" href="#op">op</a> (<a title="clones.Associative.op" href="#op">op</a> x y) z
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
  <title>Module clones.Commutative</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="clones.index.html">clones</a></code> — <code>module Commutative</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>Commutative</span><a href="clones.proof.html#Commutative" title="2 logic parameters, 1 hypothesis, 4 ground instances" class="icon small valid icofont-star"></a><a href="clones.proof.html#Commutative" title="Valid (no goals)" class="icon remark icofont-check"></a>
    <span class=keyword>clone</span> <a title="clones.Monoid" href="clones.Monoid.html">Monoid</a> <span class=keyword>as</span> M <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a name="clone-3" href="clones.Monoid.html">clones.Monoid</a> *)</span>
        <span class=keyword>type</span> <a href="clones.Monoid.html#t" title="clones.Commutative.M.t&#013;(cloned from clones.Monoid.t)"><div class=anchor id="M.t"></div>M.t</a><span title="Parameter" class="icon small remark icofont-question-circle"></span>
        <span class=keyword>function</span> <a href="clones.Monoid.html#op" title="clones.Commutative.M.op&#013;(cloned from clones.Monoid.op)"><div class=anchor id="M.op"></div>M.op</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> <a title="clones.Commutative.M.t" href="clones.Commutative.html#M.t">t</a> <a title="clones.Commutative.M.t" href="clones.Commutative.html#M.t">t</a> : <a title="clones.Commutative.M.t" href="clones.Commutative.html#M.t">t</a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="2 logic parameters" class="icon small remark icofont-question-circle"></span> 
    <span class=keyword>axiom</span> <a><div class=anchor id="commutative"></div>commutative</a><span title="Hypothesis with ground instance" class="icon small valid icofont-star"></span>: <span class=keyword>forall</span> x y. M.<a title="clones.Commutative.M.op" href="#M.op">op</a> x y = M.<a title="clones.Commutative.M.op" href="#M.op">op</a> y x
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
  <title>Module clones.IntA</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="clones.index.html">clones</a></code> — <code>module IntA</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>IntA</span><a href="clones.proof.html#IntA" title="Failed (no proof)" class="icon failed icofont-error"></a>
    <span class=keyword>use</span> int.<a title="int.Int" href="https://www.why3.org/stdlib/int.html#Int_">Int</a>
    <span class=keyword>clone</span> <a title="clones.Associative" href="clones.Associative.html">Associative</a> <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a name="clone-1" href="clones.Monoid.html">clones.Monoid</a> *)</span>
        <span class=comment>(* cloned <a name="clone-4" href="clones.Associative.html">clones.Associative</a> *)</span>
        <span class=codelense>No proof</span>
        <span class=keyword>lemma</span> <a href="clones.Associative.html#associative" title="clones.IntA.Associative.associative&#013;(cloned from clones.Associative.associative)"><div class=anchor id="Associative.associative"></div>Associative.associative</a><a href="clones.proof.html#IntA.Associative.associative" title="Failed (no proof)" class="icon failed icofont-error"></a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="Failed (no proof)" class="icon failed icofont-error"></span> <span class=keyword>with</span> <span class=keyword>type</span> <a title="clones.Associative.t" href="clones.Associative.html#t">t</a> = int, <span class=keyword>function</span> <a title="clones.Associative.op" href="clones.Associative.html#op">op</a> = (<a title="int.Int.(+)" href="https://www.why3.org/stdlib/int.html#infix%20+_19">+</a>)
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
  <title>Module clones.IntAC</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="clones.index.html">clones</a></code> — <code>module IntAC</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>IntAC</span><a href="clones.proof.html#IntAC" title="Failed (no proof)" class="icon failed icofont-error"></a>
    <span class=keyword>use</span> int.<a title="int.Int" href="https://www.why3.org/stdlib/int.html#Int_">Int</a>
    <span class=keyword>clone</span> <span class=keyword>export</span> <a title="clones.AC" href="clones.AC.html">AC</a> <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a name="clone-1" href="clones.Monoid.html">clones.Monoid</a> *)</span>
        <span class=comment>(* cloned <a name="clone-2" href="clones.Monoid.html">clones.Monoid</a> *)</span>
        <span class=comment>(* cloned <a name="clone-5" href="clones.Commutative.html">clones.Commutative</a> *)</span>
        <span class=comment>(* cloned <a name="clone-6" href="clones.Monoid.html">clones.Monoid</a> *)</span>
        <span class=comment>(* cloned <a name="clone-9" href="clones.Associative.html">clones.Associative</a> *)</span>
        <span class=comment>(* cloned <a name="clone-10" href="clones.AC.html">clones.AC</a> *)</span>
        <span class=codelense>No proof</span>
        <span class=keyword>lemma</span> <a href="clones.AC.html#commutative" title="clones.IntAC.commutative&#013;(cloned from clones.AC.commutative)"><div class=anchor id="commutative"></div>commutative</a><a href="clones.proof.html#IntAC.commutative" title="Failed (no proof)" class="icon failed icofont-error"></a>
        <span class=codelense>No proof</span>
        <span class=keyword>lemma</span> <a href="clones.AC.html#associative" title="clones.IntAC.associative&#013;(cloned from clones.AC.associative)"><div class=anchor id="associative"></div>associative</a><a href="clones.proof.html#IntAC.associative" title="Failed (no proof)" class="icon failed icofont-error"></a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="Failed (no proof)" class="icon failed icofont-error"></span> <span class=keyword>with</span> <span class=keyword>type</span> <a title="clones.AC.t" href="clones.AC.html#t">t</a> = int, <span class=keyword>function</span> <a title="clones.AC.op" href="clones.AC.html#op">op</a> = (<a title="int.Int.(+)" href="https://www.why3.org/stdlib/int.html#infix%20+_19">+</a>)
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
  <title>Module clones.IntC</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="clones.index.html">clones</a></code> — <code>module IntC</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>IntC</span><a href="clones.proof.html#IntC" title="Failed (no proof)" class="icon failed icofont-error"></a>
    <span class=keyword>use</span> int.<a title="int.Int" href="https://www.why3.org/stdlib/int.html#Int_">Int</a>
    <span class=keyword>clone</span> <a title="clones.Commutative" href="clones.Commutative.html">Commutative</a> <span class=keyword>as</span> S <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a name="clone-1" href="clones.Monoid.html">clones.Monoid</a> *)</span>
        <span class=comment>(* cloned <a name="clone-4" href="clones.Commutative.html">clones.Commutative</a> *)</span>
        <span class=codelense>No proof</span>
        <span class=keyword>lemma</span> <a href="clones.Commutative.html#commutative" title="clones.IntC.S.commutative&#013;(cloned from clones.Commutative.commutative)"><div class=anchor id="S.commutative"></div>S.commutative</a><a href="clones.proof.html#IntC.S.commutative" title="Failed (no proof)" class="icon failed icofont-error"></a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="Failed (no proof)" class="icon failed icofont-error"></span> <span class=keyword>with</span> <span class=keyword>type</span> M.<a title="clones.Commutative.M.t" href="clones.Commutative.html#M.t">t</a> = int, <span class=keyword>function</span> M.<a title="clones.Commutative.M.op" href="clones.Commutative.html#M.op">op</a> = (+)
    <span class=keyword>clone</span> <a title="clones.Commutative" href="clones.Commutative.html">Commutative</a> <span class=keyword>as</span> P <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a name="clone-5" href="clones.Monoid.html">clones.Monoid</a> *)</span>
        <span class=comment>(* cloned <a name="clone-8" href="clones.Commutative.html">clones.Commutative</a> *)</span>
        <span class=codelense>No proof</span>
        <span class=keyword>lemma</span> <a href="clones.Commutative.html#commutative" title="clones.IntC.P.commutative&#013;(cloned from clones.Commutative.commutative)"><div class=anchor id="P.commutative"></div>P.commutative</a><a href="clones.proof.html#IntC.P.commutative" title="Failed (no proof)" class="icon failed icofont-error"></a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="Failed (no proof)" class="icon failed icofont-error"></span> <span class=keyword>with</span> <span class=keyword>type</span> M.<a title="clones.Commutative.M.t" href="clones.Commutative.html#M.t">t</a> = int, <span class=keyword>function</span> M.<a title="clones.Commutative.M.op" href="clones.Commutative.html#M.op">op</a> = (*)
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
  <title>Module clones.Monoid</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="clones.index.html">clones</a></code> — <code>module Monoid</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>Monoid</span><a href="clones.proof.html#Monoid" title="2 logic parameters" class="icon small remark icofont-question-circle"></a><a href="clones.proof.html#Monoid" title="Valid (no goals)" class="icon remark icofont-check"></a>
    <span class=keyword>type</span> <a><div class=anchor id="t"></div>t</a><span title="Parameter" class="icon small remark icofont-question-circle"></span>
    <span class=keyword>function</span> <a><div class=anchor id="op"></div>op</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> <a title="clones.Monoid.t" href="#t">t</a> <a title="clones.Monoid.t" href="#t">t</a> : <a title="clones.Monoid.t" href="#t">t</a>
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
  <title>Module clones.Neutral</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="clones.index.html">clones</a></code> — <code>module Neutral</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>Neutral</span><a href="clones.proof.html#Neutral" title="3 logic parameters, 1 hypothesis, no instance found" class="icon small warning icofont-warning-alt"></a><a href="clones.proof.html#Neutral" title="Valid (no goals)" class="icon remark icofont-check"></a>
    <span class=keyword>clone</span> <span class=keyword>export</span> <a title="clones.Monoid" href="clones.Monoid.html">Monoid</a> <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a name="clone-3" href="clones.Monoid.html">clones.Monoid</a> *)</span>
        <span class=keyword>type</span> <a href="clones.Monoid.html#t" title="clones.Neutral.t&#013;(cloned from clones.Monoid.t)"><div class=anchor id="t"></div>t</a><span title="Parameter" class="icon small remark icofont-question-circle"></span>
        <span class=keyword>function</span> <a href="clones.Monoid.html#op" title="clones.Neutral.op&#013;(cloned from clones.Monoid.op)"><div class=anchor id="op"></div>op</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> <a title="clones.Neutral.t" href="clones.Neutral.html#t">t</a> <a title="clones.Neutral.t" href="clones.Neutral.html#t">t</a> : <a title="clones.Neutral.t" href="clones.Neutral.html#t">t</a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="2 logic parameters" class="icon small remark icofont-question-circle"></span> <span class="comment">(* A *)</span>
    <span class=keyword>constant</span> <a><div class=anchor id="e"></div>e</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> : <a title="clones.Neutral.t" href="#t">t</a>
    <span class=keyword>axiom</span> <a><div class=anchor id="neutral"></div>neutral</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>: <span class=keyword>forall</span> x. <a title="clones.Neutral.op" href="#op">op</a> x <a title="clones.Neutral.e" href="#e">e</a> = <a title="clones.Neutral.op" href="#op">op</a> x <a title="clones.Neutral.e" href="#e">e</a> = x
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
  <title>Library clones</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library clones</code></header>
  <pre class=src><span class=keyword>module</span> <a title="clones.Monoid" href="clones.Monoid.html">Monoid</a><a href="clones.proof.html#Monoid" title="2 logic parameters" class="icon small remark icofont-question-circle"></a><a href="clones.proof.html#Monoid" title="Valid (no goals)" class="icon remark icofont-check"></a></pre>
  <pre class=src><span class=keyword>module</span> <a title="clones.Neutral" href="clones.Neutral.html">Neutral</a><a href="clones.proof.html#Neutral" title="3 logic parameters, 1 hypothesis, no instance found" class="icon small warning icofont-warning-alt"></a><a href="clones.proof.html#Neutral" title="Valid (no goals)" class="icon remark icofont-check"></a></pre>
  <pre class=src><span class=keyword>module</span> <a title="clones.Commutative" href="clones.Commutative.html">Commutative</a><a href="clones.proof.html#Commutative" title="2 logic parameters, 1 hypothesis, 4 ground instances" class="icon small valid icofont-star"></a><a href="clones.proof.html#Commutative" title="Valid (no goals)" class="icon remark icofont-check"></a></pre>
  <pre class=src><span class=keyword>module</span> <a title="clones.Associative" href="clones.Associative.html">Associative</a><a href="clones.proof.html#Associative" title="2 logic parameters, 1 hypothesis, 3 ground instances" class="icon small valid icofont-star"></a><a href="clones.proof.html#Associative" title="Valid (no goals)" class="icon remark icofont-check"></a></pre>
  <pre class=src><span class=keyword>module</span> <a title="clones.AC" href="clones.AC.html">AC</a><a href="clones.proof.html#AC" title="2 logic parameters, 2 hypotheses, 1 ground instance" class="icon small valid icofont-star"></a><a href="clones.proof.html#AC" title="Valid (no goals)" class="icon remark icofont-check"></a></pre>
  <pre class=src><span class=keyword>module</span> <a title="clones.IntC" href="clones.IntC.html">IntC</a><a href="clones.proof.html#IntC" title="Failed (no proof)" class="icon failed icofont-error"></a></pre>
  <pre class=src><span class=keyword>module</span> <a title="clones.IntA" href="clones.IntA.html">IntA</a><a href="clones.proof.html#IntA" title="Failed (no proof)" class="icon failed icofont-error"></a></pre>
  <pre class=src><span class=keyword>module</span> <a title="clones.IntAC" href="clones.IntAC.html">IntAC</a><a href="clones.proof.html#IntAC" title="Failed (no proof)" class="icon failed icofont-error"></a></pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Library clones</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="clones.index.html">clones</a></code> — <code>proofs</code></header>
  <h1>Proofs</h1>
  <div class=dashboard>
  <div class=tab>
  <pre class="src crc"><span class=keyword>module</span> <a href="clones.Monoid.html"><div class=anchor id="Monoid"></div>clones.Monoid</a><span title="2 logic parameters" class="icon small remark icofont-question-circle"></span><span title="Valid (no goals)" class="icon remark icofont-check"></span></pre>
  <pre class="src crc"><span class=keyword>module</span> <a href="clones.Neutral.html"><div class=anchor id="Neutral"></div>clones.Neutral</a><span title="3 logic parameters, 1 hypothesis, no instance found" class="icon small warning icofont-warning-alt"></span><span title="Valid (no goals)" class="icon remark icofont-check"></span></pre>
  <pre class="src crc">
    <span class=keyword>axiom</span> <a href="clones.Neutral.html#neutral"><div class=anchor id="Neutral.neutral"></div>neutral</a><span title="uncloned hypothesis" class="icon small warning icofont-warning-alt"></span>
  </pre>
  <pre class="src crc"><span class=keyword>module</span> <a href="clones.Commutative.html"><div class=anchor id="Commutative"></div>clones.Commutative</a><span title="2 logic parameters, 1 hypothesis, 4 ground instances" class="icon small valid icofont-star"></span><span title="Valid (no goals)" class="icon remark icofont-check"></span></pre>
  <pre class="src crc">
    <span class=keyword>axiom</span> <a href="clones.Commutative.html#commutative"><div class=anchor id="Commutative.commutative"></div>commutative</a><span title="witnessed hypothesis" class="icon small valid icofont-star"></span>
    <span class=keyword>instance</span> <a href="clones.IntAC.html#clone-5">clones.IntAC</a><span title="sound instance" class="icon small valid icofont-star"></span>
    <span class=keyword>instance</span> <a href="clones.AC.html#clone-7">clones.AC</a><span title="sound instance" class="icon small valid icofont-star"></span>
    <span class=keyword>instance</span> <a href="clones.IntC.html#clone-8">clones.IntC</a><span title="sound instance" class="icon small valid icofont-star"></span>
    <span class=keyword>instance</span> <a href="clones.IntC.html#clone-4">clones.IntC</a><span title="sound instance" class="icon small valid icofont-star"></span>
  </pre>
  <pre class="src crc"><span class=keyword>module</span> <a href="clones.Associative.html"><div class=anchor id="Associative"></div>clones.Associative</a><span title="2 logic parameters, 1 hypothesis, 3 ground instances" class="icon small valid icofont-star"></span><span title="Valid (no goals)" class="icon remark icofont-check"></span></pre>
  <pre class="src crc">
    <span class=keyword>axiom</span> <a href="clones.Associative.html#associative"><div class=anchor id="Associative.associative"></div>associative</a><span title="witnessed hypothesis" class="icon small valid icofont-star"></span>
    <span class=keyword>instance</span> <a href="clones.IntAC.html#clone-9">clones.IntAC</a><span title="sound instance" class="icon small valid icofont-star"></span>
    <span class=keyword>instance</span> <a href="clones.AC.html#clone-11">clones.AC</a><span title="sound instance" class="icon small valid icofont-star"></span>
    <span class=keyword>instance</span> <a href="clones.IntA.html#clone-4">clones.IntA</a><span title="sound instance" class="icon small valid icofont-star"></span>
  </pre>
  <pre class="src crc"><span class=keyword>module</span> <a href="clones.AC.html"><div class=anchor id="AC"></div>clones.AC</a><span title="2 logic parameters, 2 hypotheses, 1 ground instance" class="icon small valid icofont-star"></span><span title="Valid (no goals)" class="icon remark icofont-check"></span></pre>
  <pre class="src crc">
    <span class=keyword>axiom</span> <a href="clones.AC.html#commutative"><div class=anchor id="AC.commutative"></div>commutative</a><span title="witnessed hypothesis" class="icon small valid icofont-star"></span>
    <span class=keyword>axiom</span> <a href="clones.AC.html#associative"><div class=anchor id="AC.associative"></div>associative</a><span title="witnessed hypothesis" class="icon small valid icofont-star"></span>
    <span class=keyword>instance</span> <a href="clones.IntAC.html#clone-10">clones.IntAC</a><span title="sound instance" class="icon small valid icofont-star"></span>
  </pre>
  <pre class="src crc"><span class=keyword>module</span> <a href="clones.IntC.html"><div class=anchor id="IntC"></div>clones.IntC</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre>
  <pre class="src crc">
    <span class=keyword>goal</span> <a href="clones.IntC.html#S.commutative"><div class=anchor id="IntC.S.commutative"></div>S.commutative</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre><pre class="src crc">
    <span class=keyword>goal</span> <a href="clones.IntC.html#P.commutative"><div class=anchor id="IntC.P.commutative"></div>P.commutative</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre><pre class="src crc"><span class=keyword>module</span> <a href="clones.IntA.html"><div class=anchor id="IntA"></div>clones.IntA</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre>
  <pre class="src crc">
    <span class=keyword>goal</span> <a href="clones.IntA.html#Associative.associative"><div class=anchor id="IntA.Associative.associative"></div>Associative.associative</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre><pre class="src crc"><span class=keyword>module</span> <a href="clones.IntAC.html"><div class=anchor id="IntAC"></div>clones.IntAC</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre>
  <pre class="src crc">
    <span class=keyword>goal</span> <a href="clones.IntAC.html#commutative"><div class=anchor id="IntAC.commutative"></div>commutative</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre><pre class="src crc">
    <span class=keyword>goal</span> <a href="clones.IntAC.html#associative"><div class=anchor id="IntAC.associative"></div>associative</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre></div>
  </div>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
--------------------------------------------------------------------------
