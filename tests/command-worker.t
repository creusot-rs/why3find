--------------------------------------------------------------------------
--- why3find worker
--------------------------------------------------------------------------
  $ why3find worker --help
  USAGE:
  
    why3find worker [OPTIONS]
  
  DESCRIPTION:
  
    Provides a worker for the specified proof server.
  
  OPTIONS:
  
    -j JOBS max parallel provers
    --server URL proof server address (default "tcp://localhost:5555")
    --polling TIME server polling interval (default 1.0s)
    --trace Trace server protocol
    --local no calibration (use local times)
    --reftime TIME set calibration time (default 0.5s)
    --sequential use sequential calibration algorithm
    --debug FLAG Activate the given debug flag (eg default)
    --why3-debug FLAG Activate the given Why3 debug flag
    --show-progress {never|auto|always} When to show progress
    -help  Display this list of options
    --help  Display this list of options
  





