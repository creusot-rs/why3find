  $ why3find prove -P alt-ergo -r foo.mlw -a --stdlib --extern --builtin
  Theory foo.S: ✔ (-)
    Parameter  logic foo.S.op
    Hypothesis axiom foo.S.com
  Theory foo.T: ✔ (2)
  Dependencies:
    External   value int.Int.(=) (stdlib, extern)
    External   param int.Int.(-) (stdlib, builtin, extern)
    External   param int.Int.(+) (stdlib, builtin, extern)
    External   param int.Int.(*) (stdlib, builtin, extern)
    External   param int.Int.(<) (stdlib, builtin, extern)
  Hypotheses:
   - parameter: 1
   - hypothesy: 1
   - externalized: 5
  Proved (foo.mlw) ✔
  $ cat foo/proof.json
  {
    "profile": [ { "prover": "alt-ergo@2.4.2", "size": 16, "time": 0.1852 } ],
    "proofs": {
      "S": {},
      "T": {
        "Add.com": { "prover": "alt-ergo@2.4.2", "time": 0.0004 },
        "Mul.com": { "prover": "alt-ergo@2.4.2", "time": 0.0004 }
      }
    }
  }
  $ why3find stats
  Proofs 2/2 800ns
  Saved to .why3find/stats.json
  $ cat .why3find/stats.json
  {
    "files": [
      {
        "path": "foo",
        "file": "foo.mlw",
        "url": "foo.html",
        "children": [
          {
            "path": "foo.S",
            "file": "foo.mlw",
            "line": 1,
            "url": "foo.S.html#_L1",
            "children": [],
            "time": 0.0
          },
          {
            "path": "foo.T",
            "file": "foo.mlw",
            "line": 6,
            "url": "foo.T.html#_L6",
            "children": [
              {
                "path": "foo.T.Add.com",
                "goal": "Add.com",
                "status": "Valid (alt-ergo)",
                "href": "foo.T.html#_L3",
                "location": { "line": 3, "column": 14, "end_column": 41 },
                "time": 0.0004,
                "proved": 1,
                "prover": "alt-ergo"
              },
              {
                "path": "foo.T.Mul.com",
                "goal": "Mul.com",
                "status": "Valid (alt-ergo)",
                "href": "foo.T.html#_L3",
                "location": { "line": 3, "column": 14, "end_column": 41 },
                "time": 0.0004,
                "proved": 1,
                "prover": "alt-ergo"
              }
            ],
            "time": 0.0008,
            "proved": 2
          }
        ],
        "time": 0.0008,
        "proved": 2
      }
    ],
    "time": 0.0008,
    "proved": 2
  }
