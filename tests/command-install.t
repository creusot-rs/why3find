--------------------------------------------------------------------------
--- why3find install
--------------------------------------------------------------------------
  $ why3find install --help
  USAGE:
  
    why3find install [OPTIONS] PKG PATH...
  
  DESCRIPTION:
  
  
    Install the package PKG at the topmost installation site.
  
    Package dependencies and configuration are taken from the
    local project, or from the command line:
  
      PKG/**         all why3 source files
      PKG/**/*.mlw   specified why3 source files
      **/*.drv       OCaml extraction drivers
  
    If no source file is given, all why3 source files
    in directory PKG will be installed.
  
    Unless --no-doc is specified, documentation in './html'
    directory is also installed.
  
  OPTIONS:
  
    --dune Generate dune installer (default)
    --global Install in global repository (why3find where)
    --lib DIR extraction directory (why3find extract -o DIR)
    --doc DIR doc output directory (why3find doc -o DIR)
    --no-doc Do not install documentation
    --debug FLAG Activate the given debug flag (eg default)
    --why3-debug FLAG Activate the given Why3 debug flag
    --show-progress {never|auto|always} When to show progress
    -help  Display this list of options
    --help  Display this list of options
  










