--------------------------------------------------------------------------
--- why3find prove
--------------------------------------------------------------------------
  $ why3find prove --help
  USAGE:
  
    why3find prove [OPTIONS] PATH...
  
  DESCRIPTION:
  
    Prove all why3 files and directories accessible from PATH.
  
  OPTIONS:
  
    --root DIR change to directory
    --why3-warn-off WRN,… disable why3 warnings
    --no-autoload  disable downloading of missing provers
    --no-autodetect  disable prover autodetection
    --no-downloaded  disable downloaded provers
    --package ±PKG,… add package dependency
    --fast TIME fast proof time (default 200ms)
    --time TIME median proof time (default 1s)
    --depth DEPTH proof search limit
    --prover ±PRV,… configure provers
    --tactic ±TAC,… configure tactics
    --preprocess ±TAC configure the preprocessing tactic
    --driver ±DRV,… configure drivers
    -p  same as --package
    -t  same as --time
    -d  same as --depth
    -P  same as --prover
    -T  same as --tactic
    -D  same as --driver
    -j JOBS max parallel provers
    --no-cache do not read results from cache
    --log-prover-results FILE log the prover results in the given file
    -g <name> goals selection
    -f force rebuild proofs
    -u update proofs (default)
    -r replay proofs (no update)
    -m minimize proofs (or update)
    -x show context on failed proof (tty only)
    -X show task on failed proof
    -i run Why3 IDE on failed proof (implies -s)
    -s save why3 session
    -l performance details (cache, prover, tactics)
    -a report axioms and parameters
    -H [0-4] hammer strategy level (default 4)
    --host HOST Proof Server host (default: none)
    --port PORT Proof Server port (default: 5555)
    --server URL Proof Server address (default: "tcp://HOST:PORT")
    --polling TIME server polling interval (default 1.0s)
    --trace Trace server protocol
    --summary make a summary of results
    --modules list results by module
    --theories list results by theory
    --goals list results by goals
    --proofs list proofs by goals
    --context <n> show n-lines context on failed proof (tty only, default 2)
    --stdlib report hypotheses from stdlib
    --extern report also external symbols
    --builtin report also builtin symbols
    --debug FLAG Activate the given debug flag (eg default)
    --why3-debug FLAG Activate the given Why3 debug flag
    --show-progress {never|auto|always} When to show progress
    -help  Display this list of options
    --help  Display this list of options
  





