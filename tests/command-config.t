--------------------------------------------------------------------------
--- why3find config
--------------------------------------------------------------------------
  $ why3find config --help
  USAGE:
  
    why3find config [OPTIONS]
  
  DESCRIPTION:
  
    Configuration of the local package.
    By default, report on the current configuration.
  
  OPTIONS:
  
    --root DIR change to directory
    --why3-warn-off WRN,… disable why3 warnings
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
    --autoload  automatic download of missing provers
    --no-autoload  disable downloading of missing provers
    --no-autodetect  disable prover autodetection
    --no-downloaded  disable downloaded provers
    --log-prover-results FILE log the prover results in the given file
    --master calibrate provers (master)
    --velocity evaluate prover velocity (local)
    --quiet do not list final configuration
    --reset configure from scratch
    --default import available provers
    --list-provers list available provers
    --list-tactics list available tactics
    --strict commit prover versions
    --relax relax prover versions
    --update update provers to latest version
    --check check that proof certificates conform to configuration
    --debug FLAG Activate the given debug flag (eg default)
    --why3-debug FLAG Activate the given Why3 debug flag
    --show-progress {never|auto|always} When to show progress
    -help  Display this list of options
    --help  Display this list of options
  





