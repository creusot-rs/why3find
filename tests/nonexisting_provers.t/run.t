  $ why3find prove -r foo.mlw bar.mlw
  Warning: prover foo not found
  File "foo.mlw", line 3, characters 15-42: proof failed
  Goal T.Add.com: ✘
  File "foo.mlw", line 3, characters 15-42: proof failed
  Goal T.Mul.com: ✘
  Library foo: ✘
  Warning: [proofss] foo discarded
  File "bar.mlw", line 3, characters 17-60: proof failed
  Goal T.Add.assoc: ✘
  Warning: [proofss] bar discarded
  File "bar.mlw", line 4, characters 15-42: proof failed
  Goal T.Add.com: ✘
  Warning: [proofss] non-existing@1.0 discarded
  File "bar.mlw", line 3, characters 17-60: proof failed
  Goal T.Mul.assoc: ✘
  Warning: [proofs] alt-ergo@2.8.4 relaxed to 2.4.2
  Library bar: ✘ (1/4)
  Error: 2 unproved files
  Summary:
  Warning: prover foo not found
  Warning: [proofss] foo discarded
  Warning: [proofss] bar discarded
  Warning: [proofss] non-existing@1.0 discarded
  Warning: [proofs] alt-ergo@2.8.4 relaxed to 2.4.2
  Error: 2 unproved files
  Emitted 5 warnings, 1 error
  [1]

  $ why3find config --check
  Warning: prover foo not found
  Warning: [proofs] foo will be discarded
  Warning: [proofs] non-existing@1.0 will be discarded
  Warning: [proofs] alt-ergo@2.8.4 will be relaxed to 2.4.2
  Warning: [proofs] bar will be discarded
  Configuration:
   - runner: 2 jobs, 1.0s
   - provers: (?foo), alt-ergo(2.4.2)
   - tactics: split_vc (depth 4)
  Summary:
  Warning: prover foo not found
  Warning: [proofs] foo will be discarded
  Warning: [proofs] non-existing@1.0 will be discarded
  Warning: [proofs] alt-ergo@2.8.4 will be relaxed to 2.4.2
  Warning: [proofs] bar will be discarded
  Emitted 5 warnings
  [1]
