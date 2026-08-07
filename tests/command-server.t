--------------------------------------------------------------------------
--- why3find server
--------------------------------------------------------------------------
  $ why3find server --help
  USAGE:
  
    why3find server [OPTIONS]
  
  DESCRIPTION:
  
    Establishes a proof server.
  
  OPTIONS:
  
    --stats Print cache disk usage
    --prune AGE Prune cache generations older than AGE
    --address URL server address (default "tcp://*:5555")
    --database DIR Database (default "why3server")
    --polling TIME server polling interval (default 1.0s)
    --trace Trace server protocol
    --debug FLAG Activate the given debug flag (eg default)
    --why3-debug FLAG Activate the given Why3 debug flag
    --show-progress {never|auto|always} When to show progress
    -help  Display this list of options
    --help  Display this list of options
  
