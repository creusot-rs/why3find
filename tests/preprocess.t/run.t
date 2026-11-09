  $ why3find prove -r foo.mlw
  Warning: Tactic compute_specified not found (skipped)
  File "foo.mlw", line 3, characters 15-42: proof failed
  Goal T.Add.com: ✘
  File "foo.mlw", line 3, characters 15-42: proof failed
  Goal T.Mul.com: ✘
  Theory foo.S: ✔ (-)
  Theory foo.T: ✘
  Error: 1 unproved file
  Summary:
  Warning: Tactic compute_specified not found (skipped)
  Error: 1 unproved file
  Emitted 1 warning, 1 error
  [1]

  $ cat foo/proof.json
  {
    "profile": [ { "prover": "alt-ergo@2.4.2", "size": 16, "time": 0.173 } ],
    "proofs": {
      "S": {},
      "T": {
        "Add.com": {
          "tactic": "compute_specified",
          "children": [ { "prover": "alt-ergo@2.4.2", "time": 0.004 } ]
        },
        "Mul.com": {
          "tactic": "compute_specified",
          "children": [ { "prover": "alt-ergo@2.4.2", "time": 0.0 } ]
        }
      }
    }
  }
