  $ why3find doc -D drivers.drv drivers.mlw
  Generated $TESTCASE_ROOT/html/index.html
  $ cat html/drivers.A.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Module drivers.A</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Drivers.t</a> — <code>library <a href="drivers.index.html">drivers</a></code> — <code>module A</code></header>
  <pre class=src>
  <span class=keyword>module</span> <span class=scope>A</span><a href="drivers.proof.html#A" title="3 logic parameters, 1 hypothesis, no instance found" class="icon small warning icofont-warning-alt"></a><a href="drivers.proof.html#A" title="Valid (no goals)" class="icon remark icofont-check"></a>
    <span class=keyword>type</span> <a><div class=anchor id="t"></div>t</a><span title="Parameter" class="icon small remark icofont-question-circle"></span>
    <span class=keyword>val</span> <span class=keyword>function</span> <a><div class=anchor id="add"></div>add</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> <a title="drivers.A.t" href="#t">t</a> <a title="drivers.A.t" href="#t">t</a> : <a title="drivers.A.t" href="#t">t</a>
    <span class=keyword>predicate</span> <a><div class=anchor id="leq"></div>leq</a><span title="Parameter" class="icon small remark icofont-question-circle"></span> <a title="drivers.A.t" href="#t">t</a> <a title="drivers.A.t" href="#t">t</a>
    <span class=keyword>axiom</span> <a><div class=anchor id="increasing"></div>increasing</a><span title="Hypothesis" class="icon small warning icofont-warning-alt"></span>: <span class=keyword>forall</span> x,y. <a title="drivers.A.leq" href="#leq">leq</a> x (<a title="drivers.A.add" href="#add">add</a> x y)
  <span class=keyword>end</span>
  </pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
  $ cat html/drivers.proof.html
  <!DOCTYPE html>
  <html>
  <head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
  <link rel="stylesheet" type="text/css" href="style.css">
  <link rel="stylesheet" type="text/css" href="icofont.min.css">
  <title>Library drivers</title>
  </head>
  <body>
  <header><a href="index.html" title="Index">Drivers.t</a> — <code>library <a href="drivers.index.html">drivers</a></code> — <code>proofs</code></header>
  <div class=doc><h1>Proofs</h1></div>
  <pre class="src crc"><span class=keyword>module</span> <a href="drivers.A.html"><div class=anchor id="A"></div>drivers.A</a><span title="3 logic parameters, 1 hypothesis, no instance found" class="icon small warning icofont-warning-alt"></span><span title="Valid (no goals)" class="icon remark icofont-check"></span></pre>
  <pre class="src crc">
    <span class=keyword>axiom</span> <a href="drivers.A.html#increasing"><div class=anchor id="A.increasing"></div>increasing</a><span title="uncloned hypothesis" class="icon small warning icofont-warning-alt"></span>
  </pre>
  <script type="text/javascript" src="script.js"></script>
  </body>
  </html>
