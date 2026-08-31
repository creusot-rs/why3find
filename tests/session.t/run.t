  $ why3find prove -P alt-ergo -r -s foo.mlw
  Theory foo.S: ✔ (-)
  Theory foo.T: ✔ (2)
  Proved (foo.mlw) ✔
  $ cat foo/why3session.xml | grep -e "proved=\"true\""
  <file format="whyml" proved="true">
  <theory name="T" proved="true">
   <goal name="Add.com" proved="true">
   <goal name="Mul.com" proved="true">
  $ why3find prove foo.mlw
  Warning: Moving proof files to `./why3find.proofs
  Theory foo.S: ✔ (-)
  Theory foo.T: ✔ (2)
  Proved (foo.mlw) ✔
  Summary:
  Warning: Moving proof files to `./why3find.proofs
  Emitted 1 warning
  $ ls why3find.proofs
  foo.json
