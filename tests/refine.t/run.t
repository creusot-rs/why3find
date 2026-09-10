--------------------------------------------------------------------------
--- This is just to be sure that everything is OK with why3 cloning
--------------------------------------------------------------------------
  $ why3find doc refine.mlw
  Generated $TESTCASE_ROOT/html/index.html
  $ cat html/refine.Interface.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Module refine.Interface</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Index</a> — <code>library <a href="refine.index.html">refine</a></code> — <code>module Interface</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>Interface</span><a href="refine.proof.html#Interface" title="2 value parameters, 5 logic parameters, 2 hypotheses, 1 incomplete instance" class="icon small warning icofont-warning-alt"></a><a href="refine.proof.html#Interface" title="Failed (no proof)" class="icon failed icofont-error"></a>
    <span class=keyword>use</span> int.<a title="int.Int" href="https://www.why3.org/stdlib/int.html#Int_">Int</a>
  </pre>
  <div class=doc>
  <p>All these are defined values, they can not be refined</p>
  </div>
  <pre class=src>
    <span class=keyword>constant</span> <a><div class=anchor id="vA"></div>vA</a> : int = 42
    <span class=keyword>val</span> <a><div class=anchor id="zB"></div>zB</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> : int
    <span class=keyword>let</span> <a><div class=anchor id="vC"></div>vC</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> : int = <span class=keyword>any</span> int
  </pre>
  <div class=doc>
  <p>Standard refinable constants with assumption</p>
  </div>
  <pre class=src>
    <span class=keyword>constant</span> <a><div class=anchor id="cA"></div>cA</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> : int
    <span class=keyword>axiom</span> <a><div class=anchor id="pA"></div>pA</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span> : <a title="refine.Interface.cA" href="#cA">cA</a> <a title="int.Int.(>)" href="https://www.why3.org/stdlib/int.html#infix%20%3E_24">&gt;</a> 0
    <span class=keyword>axiom</span> <a><div class=anchor id="qA"></div>qA</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span> : <a title="refine.Interface.cA" href="#cA">cA</a> <a title="int.Int.(<)" href="https://www.why3.org/stdlib/int.html#infix%20%3C_21">&lt;</a> 66
  </pre>
  <div class=doc>
  <p>All these can be instantiated by constants or functions</p>
  </div>
  <pre class=src>
    <span class=keyword>val</span> <span class=keyword>constant</span> <a><div class=anchor id="cB"></div>cB</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> : int
    <span class=keyword>let</span> <span class=keyword>constant</span> <a><div class=anchor id="cC"></div>cC</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> : int = <span class=keyword>any</span> int
    <span class=keyword>let</span> <span class=keyword>constant</span> <a><div class=anchor id="cD"></div>cD</a><a href="refine.proof.html#Interface.cD" title="Failed (no proof)" class="icon failed icofont-error"></a> : int = <span class=keyword>any</span> int <span class=keyword>ensures</span> { result <a title="int.Int.(>)" href="https://www.why3.org/stdlib/int.html#infix%20%3E_24">&gt;</a> 0 }
    <span class=keyword>let</span> <span class=keyword>function</span> <a><div class=anchor id="cE"></div>cE</a><a href="refine.proof.html#Interface.cE" title="Failed (no proof)" class="icon failed icofont-error"></a> : int = <span class=keyword>any</span> int <span class=keyword>ensures</span> { result <a title="int.Int.(>)" href="https://www.why3.org/stdlib/int.html#infix%20%3E_24">&gt;</a> 0 }
  </pre>
  <div class=doc>
  <p>All these are refinable functions</p>
  </div>
  <pre class=src>
    <span class=keyword>val</span> <a><div class=anchor id="fX"></div>fX</a><span title="Value Parameter" class="icon small warning icofont-warning-alt"></span> (x : int) : int <span class=keyword>ensures</span> { result <a title="int.Int.(>)" href="https://www.why3.org/stdlib/int.html#infix%20%3E_24">&gt;</a> x }
    <span class=keyword>val</span> <span class=keyword>function</span> <a><div class=anchor id="fY"></div>fY</a><span title="Value Parameter" class="icon small warning icofont-warning-alt"></span> (x : int) : int <span class=keyword>ensures</span> { result <a title="int.Int.(<)" href="https://www.why3.org/stdlib/int.html#infix%20%3C_21">&lt;</a> x }
  </pre>
  <div class=doc>
  <p>This function can <em>not</em> be refined</p>
  </div>
  <pre class=src>
    <span class=keyword>let</span> <span class=keyword>function</span> <a><div class=anchor id="fZ"></div>fZ</a><a href="refine.proof.html#Interface.fZ" title="Failed (no proof)" class="icon failed icofont-error"></a> (x : int) : int = <span class=keyword>any</span> int <span class=keyword>ensures</span> { result &lt;&gt; x }
  
  <span class=keyword>end</span>
  </pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>

