  $ why3find doc clones.mlw certif.mlw
  Generated $TESTCASE_ROOT/html/index.html
  $ cat html/clones.A.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Module clones.A</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="clones.index.html">clones</a></code> — <code>module A</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>A</span><a href="clones.proof.html#A" title="3 logic parameters, 2 hypotheses, 1 incomplete instance" class="icon small warning icofont-warning-alt"></a><a href="clones.proof.html#A" title="Valid (one goal)" class="icon valid icofont-check"></a>
  
    <span class=keyword>type</span> <a><div class=anchor id="t"></div>t</a><span title="Parameter" class="icon small remark icofont-question-circle"></span>
    <span class=keyword>constant</span> <a><div class=anchor id="e"></div>e</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> : <a title="clones.A.t" href="#t">t</a>
    <span class=keyword>function</span> <a><div class=anchor id="op"></div>op</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> <a title="clones.A.t" href="#t">t</a> <a title="clones.A.t" href="#t">t</a> : <a title="clones.A.t" href="#t">t</a>
    <span class=keyword>axiom</span> <a><div class=anchor id="neutral"></div>neutral</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>: <span class=keyword>forall</span> x. <a title="clones.A.op" href="#op">op</a> x <a title="clones.A.e" href="#e">e</a> = x
    <span class=keyword>axiom</span> <a><div class=anchor id="commutative"></div>commutative</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>: <span class=keyword>forall</span> x y. <a title="clones.A.op" href="#op">op</a> x y = <a title="clones.A.op" href="#op">op</a> y x
    <span class=keyword>lemma</span> <a><div class=anchor id="neutral_com"></div>neutral_com</a><a href="clones.proof.html#A.neutral_com" title="Valid (one goal)" class="icon valid icofont-check"></a>: <span class=keyword>forall</span> x. <a title="clones.A.op" href="#op">op</a> <a title="clones.A.e" href="#e">e</a> x = x
  
  <span class=keyword>end</span>
  </pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  $ cat html/clones.B.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Module clones.B</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="clones.index.html">clones</a></code> — <code>module B</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>B</span><a href="clones.proof.html#B" title="1 logic parameter, 1 hypothesis, no instance found" class="icon small warning icofont-warning-alt"></a><a href="clones.proof.html#B" title="Valid (one goal)" class="icon valid icofont-check"></a>
    <span class=keyword>use</span> int.<a title="int.Int" href="https://www.why3.org/stdlib/int.html#Int_">Int</a>
    <span class=keyword>clone</span> <a title="clones.A" href="clones.A.html">A</a> <span class=section>{<span class="section-toggle" title="Cloned symbols">…</span><span class="section-text">
      <span class="comment section-toggle">begin</span>
        <span class=comment>(* cloned <a name="clone-8" href="clones.A.html">clones.A</a> *)</span>
        <span class=keyword>function</span> <a href="clones.A.html#e" title="clones.B.A.e&#013;(cloned from clones.A.e)"><div class=anchor id="A.e"></div>A.e</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> : int
        <span class=keyword>axiom</span> <a href="clones.A.html#neutral" title="clones.B.A.neutral&#013;(cloned from clones.A.neutral)"><div class=anchor id="A.neutral"></div>A.neutral</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>
        <span class=codelense>Valid (alt-ergo)</span>
        <span class=keyword>lemma</span> <a href="clones.A.html#commutative" title="clones.B.A.commutative&#013;(cloned from clones.A.commutative)"><div class=anchor id="A.commutative"></div>A.commutative</a><a href="clones.proof.html#B.A.commutative" title="Valid (one goal)" class="icon valid icofont-check"></a>
        <span class=keyword>lemma</span> <a href="clones.A.html#neutral_com" title="clones.B.A.neutral_com&#013;(cloned from clones.A.neutral_com)"><div class=anchor id="A.neutral_com"></div>A.neutral_com</a><span title="cloned" class="icon remark icofont-check"></span>
      <span class="comment section-toggle">end</span>
    </span>}</span><span title="1 logic parameter, 1 hypothesis" class="icon small warning icofont-warning-alt"></span><span title="Valid (one goal)" class="icon valid icofont-check"></span> <span class=keyword>with</span> <span class=keyword>type</span> <a title="clones.A.t" href="clones.A.html#t">t</a> = int, <span class=keyword>function</span> <a title="clones.A.op" href="clones.A.html#op">op</a> = (<a title="int.Int.(+)" href="https://www.why3.org/stdlib/int.html#infix%20+_19">+</a>), <span class=keyword>axiom</span> <a title="clones.A.neutral" href="clones.A.html#neutral">neutral</a>
  <span class=keyword>end</span>
  </pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  $ cat html/certif.S.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Module certif.S</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="certif.index.html">certif</a></code> — <code>module S</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>S</span><a href="certif.proof.html#S" title="Partial proof (6/10 goals)" class="icon warning icofont-error"></a>
  
    <span class=keyword>use</span> int.<a title="int.Int" href="https://www.why3.org/stdlib/int.html#Int_">Int</a>
    <span class=keyword>use</span> int.<a title="int.MinMax" href="https://www.why3.org/stdlib/int.html#MinMax_">MinMax</a>
    <span class=keyword>use</span> option.<a title="option.Option" href="https://www.why3.org/stdlib/option.html#Option_">Option</a>
    <span class=keyword>use</span> list.<a title="list.ListRich" href="https://www.why3.org/stdlib/list.html#ListRich_">ListRich</a> <span class=keyword>as</span> L
  
    <span class=keyword>type</span> <a><div class=anchor id="seq"></div>seq</a> &#39;a = L.<a title="list.List.list" href="https://www.why3.org/stdlib/list.html#list_8">list</a> &#39;a
  
    <span class=keyword>let</span> <span class=keyword>rec</span> <span class=keyword>function</span> (<a><div class=anchor id="mixfix%20%5B%5D"></div>[]</a>)<a href="certif.proof.html#S.mixfix%20%5B%5D" title="Partial proof (3/5 goals)" class="icon warning icofont-error"></a> (u : <a title="certif.S.seq" href="#seq">seq</a> &#39;a) (k : int) : &#39;a
      <span class=keyword>requires</span> { 0 <a title="int.Int.(<=)" href="https://www.why3.org/stdlib/int.html#infix%20%3C=_25">&lt;=</a> k <a title="int.Int.(<)" href="https://www.why3.org/stdlib/int.html#infix%20%3C_21">&lt;</a> L.<a title="list.Length.length" href="https://www.why3.org/stdlib/list.html#length_24">length</a> u }
      <span class=keyword>ensures</span> { L.<a title="list.Nth.nth" href="https://www.why3.org/stdlib/list.html#nth_104">nth</a> k u = <a title="option.Option.Some" href="https://www.why3.org/stdlib/option.html#Some_5">Some</a> result }
      <span class=keyword>variant</span> { u }
      = <span class=keyword>match</span> u <span class=keyword>with</span> L.<a title="list.List.Cons" href="https://www.why3.org/stdlib/list.html#Cons_8">Cons</a> x w -&gt;
          <span class=keyword>if</span> k <a title="int.Int.(=)" href="https://www.why3.org/stdlib/int.html#infix%20=_16">=</a> 1 <span class="comment">(*incorrect*)</span> <span class=keyword>then</span> x <span class=keyword>else</span> w[k<a title="int.Int.(-)" href="https://www.why3.org/stdlib/int.html#infix%20-_23">-</a>1]
        <span class=keyword>end</span>
  
    <span class=keyword>predicate</span> (<a><div class=anchor id="infix%20%3D%3D"></div>==</a>) (u v : <a title="certif.S.seq" href="#seq">seq</a> &#39;a) =
      L.<a title="list.Length.length" href="https://www.why3.org/stdlib/list.html#length_24">length</a> u = L.<a title="list.Length.length" href="https://www.why3.org/stdlib/list.html#length_24">length</a> v /\ <span class=keyword>forall</span> k. 0 <a title="int.Int.(<=)" href="https://www.why3.org/stdlib/int.html#infix%20%3C=_25">&lt;=</a> k <a title="int.Int.(<)" href="https://www.why3.org/stdlib/int.html#infix%20%3C_21">&lt;</a> L.<a title="list.Length.length" href="https://www.why3.org/stdlib/list.html#length_24">length</a> u -&gt; u[k] = v[k]
  
    <span class=keyword>lemma</span> <a><div class=anchor id="reflexivity"></div>reflexivity</a><a href="certif.proof.html#S.reflexivity" title="Valid (one goal)" class="icon valid icofont-check"></a> : <span class=keyword>forall</span> u : <a title="certif.S.seq" href="#seq">seq</a> &#39;a. u <a title="certif.S.(==)" href="#infix%20%3D%3D">==</a> u
  
    <span class=keyword>let</span> <span class=keyword>rec</span> <span class=keyword>lemma</span> <a><div class=anchor id="extensivity"></div>extensivity</a><a href="certif.proof.html#S.extensivity" title="Partial proof (2/3 goals)" class="icon warning icofont-error"></a> (a b : <a title="certif.S.seq" href="#seq">seq</a> &#39;a)
      <span class=keyword>requires</span> { a <a title="certif.S.(==)" href="#infix%20%3D%3D">==</a> b }
      <span class=keyword>ensures</span> { a = b }
      <span class="section level1"><span class=comment>{</span><span class="attribute section-toggle">proof</span><span class="comment section-text active">…</span><span class=comment>}</span><span class="section-text">
      <span class=keyword>variant</span> { a, b }
      = <span class=keyword>match</span> a, b <span class=keyword>with</span>
        | L.<a title="list.List.Cons" href="https://www.why3.org/stdlib/list.html#Cons_8">Cons</a> _ a&#39; , L.<a title="list.List.Cons" href="https://www.why3.org/stdlib/list.html#Cons_8">Cons</a> _ _ -&gt; extensivity a&#39; b <span class="comment">(*incorrect*)</span>
        | _ -&gt; ()
        <span class=keyword>end</span>
      <span class=comment>{</span><span class="attribute section-toggle">qed</span><span class=comment>}</span></span></span>
  
    <span class=keyword>goal</span> <a><div class=anchor id="wrong"></div>wrong</a><a href="certif.proof.html#S.wrong" title="Failed (no proof)" class="icon failed icofont-error"></a>: 1 = 0
  
  <span class=keyword>end</span>
  </pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  $ cat html/clones.proof.html
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
  <pre class="src crc"><span class=keyword>module</span> <a href="clones.A.html"><div class=anchor id="A"></div>clones.A</a><span title="3 logic parameters, 2 hypotheses, 1 incomplete instance" class="icon small warning icofont-warning-alt"></span><span title="Valid (one goal)" class="icon valid icofont-check"></span></pre>
  <pre class="src crc">
    <span class=keyword>axiom</span> <a href="clones.A.html#neutral"><div class=anchor id="A.neutral"></div>neutral</a><span title="uncloned hypothesis" class="icon small warning icofont-warning-alt"></span>
    <span class=keyword>axiom</span> <a href="clones.A.html#commutative"><div class=anchor id="A.commutative"></div>commutative</a><span title="uncloned hypothesis" class="icon small warning icofont-warning-alt"></span>
    <span class=keyword>instance</span> <a href="clones.B.html#clone-8">clones.B</a><span title="incomplete instance" class="icon small warning icofont-warning-alt"></span>
  </pre>
  <pre class="src crc">
    <span class=keyword>goal</span> <a href="clones.A.html#neutral_com"><div class=anchor id="A.neutral_com"></div>neutral_com</a><span title="Valid (one goal)" class="icon valid icofont-check"></span>
      <span class=prover title="alt-ergo@2.4.2">alt-ergo</span> 500ns</pre><pre class="src crc"><span class=keyword>module</span> <a href="clones.B.html"><div class=anchor id="B"></div>clones.B</a><span title="1 logic parameter, 1 hypothesis, no instance found" class="icon small warning icofont-warning-alt"></span><span title="Valid (one goal)" class="icon valid icofont-check"></span></pre>
  <pre class="src crc">
    <span class=keyword>axiom</span> <a href="clones.B.html#A.neutral"><div class=anchor id="B.A.neutral"></div>A.neutral</a><span title="uncloned hypothesis" class="icon small warning icofont-warning-alt"></span>
  </pre>
  <pre class="src crc">
    <span class=keyword>goal</span> <a href="clones.B.html#A.commutative"><div class=anchor id="B.A.commutative"></div>A.commutative</a><span title="Valid (one goal)" class="icon valid icofont-check"></span>
      <span class=prover title="alt-ergo@2.4.2">alt-ergo</span> 400ns</pre><pre class="src crc"><span class=keyword>module</span> <a href="clones.C.html"><div class=anchor id="C"></div>clones.C</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre>
  <pre class="src crc">
    <span class=keyword>goal</span> <a href="clones.C.html#A.neutral"><div class=anchor id="C.A.neutral"></div>A.neutral</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre><pre class="src crc">
    <span class=keyword>goal</span> <a href="clones.C.html#A.commutative"><div class=anchor id="C.A.commutative"></div>A.commutative</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre></div>
  </div>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  $ cat html/certif.proof.html | sed s/569ms/570ms/ # x86-32
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Library certif</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="certif.index.html">certif</a></code> — <code>proofs</code></header>
  <h1>Proofs</h1>
  <div class=dashboard>
  <div class=tab>
  <pre class="src crc"><span class=keyword>module</span> <a href="certif.S.html"><div class=anchor id="S"></div>certif.S</a><span title="Partial proof (6/10 goals)" class="icon warning icofont-error"></span></pre>
  <pre class="src crc">
    <span class=keyword>goal</span> <a href="certif.S.html#mixfix%20%5B%5D"><div class=anchor id="S.mixfix%20%5B%5D"></div>([])</a><span title="Partial proof (3/5 goals)" class="icon warning icofont-error"></span>
      split_vc<span title="Partial proof (3/5 goals)" class="icon warning icofont-error"></span>
        <span class=prover title="alt-ergo@2.4.2">alt-ergo</span> 4ms
        split_vc<span title="Partial proof (1/2 goals)" class="icon warning icofont-error"></span>
          stuck<span class="icon failed icofont-error"></span>
          <span class=prover title="alt-ergo@2.4.2">alt-ergo</span> 3ms
        <span class=prover title="alt-ergo@2.4.2">alt-ergo</span> 3ms
        stuck<span class="icon failed icofont-error"></span></pre><pre class="src crc">
    <span class=keyword>goal</span> <a href="certif.S.html#reflexivity"><div class=anchor id="S.reflexivity"></div>reflexivity</a><span title="Valid (one goal)" class="icon valid icofont-check"></span>
      <span class=prover title="alt-ergo@2.4.2">alt-ergo</span> 2ms</pre><pre class="src crc">
    <span class=keyword>goal</span> <a href="certif.S.html#extensivity"><div class=anchor id="S.extensivity"></div>extensivity</a><span title="Partial proof (2/3 goals)" class="icon warning icofont-error"></span>
      split_vc<span title="Partial proof (2/3 goals)" class="icon warning icofont-error"></span>
        <span class=prover title="alt-ergo@2.4.2">alt-ergo</span> 4ms
        stuck<span class="icon failed icofont-error"></span>
        <span class=prover title="cvc4@1.8">cvc4</span> 70ms</pre><pre class="src crc">
    <span class=keyword>goal</span> <a href="certif.S.html#wrong"><div class=anchor id="S.wrong"></div>wrong</a><span title="Failed (no proof)" class="icon failed icofont-error"></span></pre></div>
  </div>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
