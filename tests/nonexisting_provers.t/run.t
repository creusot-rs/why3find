  $ why3find prove -r foo.mlw bar.mlw
  Warning: prover foo not found
  File "foo.mlw", line 3, characters 15-42: proof failed
  Goal T.Add.com: ✘
  File "foo.mlw", line 3, characters 15-42: proof failed
  Goal T.Mul.com: ✘
  Library foo: ✘
  Warning: [hint] prover foo@0.0 discarded
  File "bar.mlw", line 3, characters 17-60: proof failed
  Goal T.Add.assoc: ✘
  Warning: [hint] prover bar@0.0 discarded
  File "bar.mlw", line 4, characters 15-42: proof failed
  Goal T.Add.com: ✘
  Warning: [hint] prover non-existing@1.0 discarded
  File "bar.mlw", line 3, characters 17-60: proof failed
  Goal T.Mul.assoc: ✘
  Warning: [hint] prover alt-ergo@2.8.4 relaxed
  Library bar: ✘ (1/4)
  Error: 2 unproved files
  Summary:
  Warning: prover foo not found
  Warning: [hint] prover foo@0.0 discarded
  Warning: [hint] prover bar@0.0 discarded
  Warning: [hint] prover non-existing@1.0 discarded
  Warning: [hint] prover alt-ergo@2.8.4 relaxed
  Error: 2 unproved files
  Emitted 5 warnings, 1 error
  [1]

  $ why3find config --check
  Warning: prover foo not found
  Warning: [hint] prover non-existing@1.0 discarded
  Warning: [hint] prover foo@0.0 discarded
  Warning: [hint] prover bar@0.0 discarded
  Warning: [hint] prover alt-ergo@2.8.4 relaxed
  Configuration:
   - runner: 2 jobs, 1.0s
   - provers: (?foo), alt-ergo(2.4.2)
   - tactics: split_vc (depth 4)
  Summary:
  Warning: prover foo not found
  Warning: [hint] prover non-existing@1.0 discarded
  Warning: [hint] prover foo@0.0 discarded
  Warning: [hint] prover bar@0.0 discarded
  Warning: [hint] prover alt-ergo@2.8.4 relaxed
  Emitted 5 warnings
  [1]
