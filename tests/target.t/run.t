--------------------------------------------------------------------------
--- Generating Documentation
--------------------------------------------------------------------------
  $ why3find doc target.mlw
  Generated $TESTCASE_ROOT/html/index.html
--------------------------------------------------------------------------
--- Generated Files
--------------------------------------------------------------------------
  $ cat html/target.B.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Module target.B</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="target.index.html">target</a></code> — <code>module B</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>B</span><a href="target.proof.html#B" title="7 logic parameters, 9 hypotheses, no instance found" class="icon small warning icofont-warning-alt"></a><a href="target.proof.html#B" title="Failed (no proof)" class="icon failed icofont-error"></a>
    <span class=keyword>use</span> int.<a title="int.Int" href="https://www.why3.org/stdlib/int.html#Int_">Int</a>
    <span class=keyword>use</span> <a title="target.Q" href="target.Q.html">Q</a>
    <span class=keyword>type</span> <a><div class=anchor id="t"></div>t</a> = int
    <span class=keyword>predicate</span> <a><div class=anchor id="p"></div>p</a> (x : int) = x <a title="int.Int.(>)" href="https://www.why3.org/stdlib/int.html#infix%20%3E_24">&gt;</a> 0
    <span class=keyword>clone</span> <a title="target.A" href="target.A.html">A</a> <span class=keyword>as</span> A0 <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a id="clone-8" href="target.A.html">target.A</a> *)</span>
        <span class=keyword>predicate</span> <a href="target.A.html#r" title="target.B.A0.r&#013;(cloned from target.A.r)"><div class=anchor id="A0.r"></div>A0.r</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> int
        <span class=keyword>axiom</span> <a href="target.A.html#pq" title="target.B.A0.pq&#013;(cloned from target.A.pq)"><div class=anchor id="A0.pq"></div>A0.pq</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>
        <span class=keyword>axiom</span> <a href="target.A.html#qr" title="target.B.A0.qr&#013;(cloned from target.A.qr)"><div class=anchor id="A0.qr"></div>A0.qr</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="1 logic parameter, 2 hypotheses" class="icon small warning icofont-warning-alt"></span> <span class=keyword>with</span> <span class=keyword>type</span> <a title="target.A.a" href="target.A.html#a">a</a> = int, <span class=keyword>predicate</span> <a title="target.A.q" href="target.A.html#q">q</a> = Q.<a title="target.Q.q" href="target.Q.html#q">q</a>, <span class=keyword>predicate</span> <a title="target.A.p" href="target.A.html#p">p</a><a href="#p" title="target.B.p" class="icon small remark icofont-question-circle"></a>, <span class=keyword>axiom</span> .
    <span class=keyword>clone</span> <a title="target.A" href="target.A.html">A</a> <span class=keyword>as</span> A1 <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a id="clone-14" href="target.A.html">target.A</a> *)</span>
        <span class=keyword>predicate</span> <a href="target.A.html#r" title="target.B.A1.r&#013;(cloned from target.A.r)"><div class=anchor id="A1.r"></div>A1.r</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> int
        <span class=keyword>axiom</span> <a href="target.A.html#pq" title="target.B.A1.pq&#013;(cloned from target.A.pq)"><div class=anchor id="A1.pq"></div>A1.pq</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>
        <span class=codelense>No proof</span>
        <span class=keyword>lemma</span> <a href="target.A.html#qr" title="target.B.A1.qr&#013;(cloned from target.A.qr)"><div class=anchor id="A1.qr"></div>A1.qr</a><a href="target.proof.html#B.A1.qr" title="Failed (no proof)" class="icon failed icofont-error"></a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="1 logic parameter, 1 hypothesis" class="icon small warning icofont-warning-alt"></span><span title="Failed (no proof)" class="icon failed icofont-error"></span> <span class=keyword>with</span> <span class=keyword>type</span> <a title="target.A.a" href="target.A.html#a">a</a> = int, <span class=keyword>predicate</span> <a title="target.A.q" href="target.A.html#q">q</a> = Q.<a title="target.Q.q" href="target.Q.html#q">q</a>, <span class=keyword>predicate</span> <a title="target.A.p" href="target.A.html#p">p</a><a href="#p" title="target.B.p" class="icon small remark icofont-question-circle"></a>, <span class=keyword>axiom</span> <a title="target.A.pq" href="target.A.html#pq">pq</a>
    <span class=keyword>clone</span> <a title="target.A" href="target.A.html">A</a> <span class=keyword>as</span> A2 <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a id="clone-20" href="target.A.html">target.A</a> *)</span>
        <span class=keyword>predicate</span> <a href="target.A.html#r" title="target.B.A2.r&#013;(cloned from target.A.r)"><div class=anchor id="A2.r"></div>A2.r</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> int
        <span class=keyword>axiom</span> <a href="target.A.html#pq" title="target.B.A2.pq&#013;(cloned from target.A.pq)"><div class=anchor id="A2.pq"></div>A2.pq</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>
        <span class=codelense>No proof</span>
        <span class=keyword>lemma</span> <a href="target.A.html#qr" title="target.B.A2.qr&#013;(cloned from target.A.qr)"><div class=anchor id="A2.qr"></div>A2.qr</a><a href="target.proof.html#B.A2.qr" title="Failed (no proof)" class="icon failed icofont-error"></a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="1 logic parameter, 1 hypothesis" class="icon small warning icofont-warning-alt"></span><span title="Failed (no proof)" class="icon failed icofont-error"></span> <span class=keyword>with</span> <span class=keyword>type</span> <a title="target.A.a" href="target.A.html#a">a</a> = int, <span class=keyword>predicate</span> <a title="target.A.p" href="target.A.html#p">p</a><a href="#p" title="target.B.p" class="icon small remark icofont-question-circle"></a>, <span class=keyword>axiom</span> <a title="target.A.pq" href="target.A.html#pq">pq</a>, <span class=keyword>predicate</span> <a title="target.A.q" href="target.A.html#q">q</a> = Q.<a title="target.Q.q" href="target.Q.html#q">q</a>
    <span class=keyword>clone</span> <a title="target.A" href="target.A.html">A</a> <span class=keyword>as</span> A3 <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a id="clone-26" href="target.A.html">target.A</a> *)</span>
        <span class=keyword>predicate</span> <a href="target.A.html#r" title="target.B.A3.r&#013;(cloned from target.A.r)"><div class=anchor id="A3.r"></div>A3.r</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> int
        <span class=keyword>axiom</span> <a href="target.A.html#pq" title="target.B.A3.pq&#013;(cloned from target.A.pq)"><div class=anchor id="A3.pq"></div>A3.pq</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>
        <span class=codelense>No proof</span>
        <span class=keyword>lemma</span> <a href="target.A.html#qr" title="target.B.A3.qr&#013;(cloned from target.A.qr)"><div class=anchor id="A3.qr"></div>A3.qr</a><a href="target.proof.html#B.A3.qr" title="Failed (no proof)" class="icon failed icofont-error"></a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="1 logic parameter, 1 hypothesis" class="icon small warning icofont-warning-alt"></span><span title="Failed (no proof)" class="icon failed icofont-error"></span> <span class=keyword>with</span> <span class=keyword>type</span> <a title="target.A.a" href="target.A.html#a">a</a> = int, <span class=keyword>axiom</span> <a title="target.A.pq" href="target.A.html#pq">pq</a>, <span class=keyword>predicate</span> <a title="target.A.q" href="target.A.html#q">q</a> = Q.<a title="target.Q.q" href="target.Q.html#q">q</a>, <span class=keyword>predicate</span> <a title="target.A.p" href="target.A.html#p">p</a><a href="#p" title="target.B.p" class="icon small remark icofont-question-circle"></a>
    <span class=keyword>clone</span> <a title="target.A" href="target.A.html">A</a> <span class=keyword>as</span> A4 <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a id="clone-32" href="target.A.html">target.A</a> *)</span>
        <span class=keyword>predicate</span> <a href="target.A.html#r" title="target.B.A4.r&#013;(cloned from target.A.r)"><div class=anchor id="A4.r"></div>A4.r</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> int
        <span class=keyword>axiom</span> <a href="target.A.html#pq" title="target.B.A4.pq&#013;(cloned from target.A.pq)"><div class=anchor id="A4.pq"></div>A4.pq</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>
        <span class=codelense>No proof</span>
        <span class=keyword>lemma</span> <a href="target.A.html#qr" title="target.B.A4.qr&#013;(cloned from target.A.qr)"><div class=anchor id="A4.qr"></div>A4.qr</a><a href="target.proof.html#B.A4.qr" title="Failed (no proof)" class="icon failed icofont-error"></a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="1 logic parameter, 1 hypothesis" class="icon small warning icofont-warning-alt"></span><span title="Failed (no proof)" class="icon failed icofont-error"></span> <span class=keyword>with</span> <span class=keyword>type</span> <a title="target.A.a" href="target.A.html#a">a</a> = int, <span class=keyword>axiom</span> <a title="target.A.pq" href="target.A.html#pq">pq</a>, <span class=keyword>predicate</span> <a title="target.A.q" href="target.A.html#q">q</a> = Q.<a title="target.Q.q" href="target.Q.html#q">q</a>, <span class=keyword>predicate</span> <a title="target.A.p" href="target.A.html#p">p</a><a href="#p" title="target.B.p" class="icon small remark icofont-question-circle"></a> <span class="comment">(* spaced *)</span>
    <span class=keyword>clone</span> <a title="target.A" href="target.A.html">A</a> <span class=keyword>as</span> A5 <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a id="clone-38" href="target.A.html">target.A</a> *)</span>
        <span class=keyword>predicate</span> <a href="target.A.html#r" title="target.B.A5.r&#013;(cloned from target.A.r)"><div class=anchor id="A5.r"></div>A5.r</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> int
        <span class=keyword>axiom</span> <a href="target.A.html#pq" title="target.B.A5.pq&#013;(cloned from target.A.pq)"><div class=anchor id="A5.pq"></div>A5.pq</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>
        <span class=codelense>No proof</span>
        <span class=keyword>lemma</span> <a href="target.A.html#qr" title="target.B.A5.qr&#013;(cloned from target.A.qr)"><div class=anchor id="A5.qr"></div>A5.qr</a><a href="target.proof.html#B.A5.qr" title="Failed (no proof)" class="icon failed icofont-error"></a>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="1 logic parameter, 1 hypothesis" class="icon small warning icofont-warning-alt"></span><span title="Failed (no proof)" class="icon failed icofont-error"></span> <span class=keyword>with</span> <span class=keyword>predicate</span> <a title="target.A.p" href="target.A.html#p">p</a><a href="#p" title="target.B.p" class="icon small remark icofont-question-circle"></a>, <span class=keyword>axiom</span> <a title="target.A.pq" href="target.A.html#pq">pq</a>, <span class=keyword>predicate</span> <a title="target.A.q" href="target.A.html#q">q</a> = Q.<a title="target.Q.q" href="target.Q.html#q">q</a>, <span class=keyword>type</span> <a title="target.A.a" href="target.A.html#a">a</a> = int
    <span class=keyword>clone</span> <a title="target.A" href="target.A.html">A</a> <span class=keyword>as</span> A6 <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a id="clone-44" href="target.A.html">target.A</a> *)</span>
        <span class=keyword>predicate</span> <a href="target.A.html#r" title="target.B.A6.r&#013;(cloned from target.A.r)"><div class=anchor id="A6.r"></div>A6.r</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> int
        <span class=keyword>axiom</span> <a href="target.A.html#pq" title="target.B.A6.pq&#013;(cloned from target.A.pq)"><div class=anchor id="A6.pq"></div>A6.pq</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>
        <span class=keyword>axiom</span> <a href="target.A.html#qr" title="target.B.A6.qr&#013;(cloned from target.A.qr)"><div class=anchor id="A6.qr"></div>A6.qr</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="1 logic parameter, 2 hypotheses" class="icon small warning icofont-warning-alt"></span> <span class=keyword>with</span> <span class=keyword>predicate</span> <a title="target.A.p" href="target.A.html#p">p</a><a href="#p" title="target.B.p" class="icon small remark icofont-question-circle"></a>, <span class=keyword>axiom</span> ., <span class=keyword>predicate</span> <a title="target.A.q" href="target.A.html#q">q</a> = Q.<a title="target.Q.q" href="target.Q.html#q">q</a>, <span class=keyword>type</span> <a title="target.A.a" href="target.A.html#a">a</a> = int
    <span class=keyword>predicate</span> <a><div class=anchor id="r"></div>r</a> (x : int) = x <a title="int.Int.(<)" href="https://www.why3.org/stdlib/int.html#infix%20%3C_21">&lt;</a> 0
    <span class=keyword>lemma</span> <a><div class=anchor id="pr"></div>pr</a><a href="target.proof.html#B.pr" title="Failed (no proof)" class="icon failed icofont-error"></a>: <span class=keyword>forall</span> x. <a title="target.B.p" href="#p">p</a> x &lt;-&gt; <a title="target.B.r" href="#r">r</a> (<a title="int.Int.(-)" href="https://www.why3.org/stdlib/int.html#prefix%20-_18">-</a>x)
  <span class=keyword>end</span>
  </pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
