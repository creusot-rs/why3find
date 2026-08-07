--------------------------------------------------------------------------
--- why3find doc
--------------------------------------------------------------------------
  $ why3find doc --help
  USAGE:
  
    why3find doc [OPTIONS] PATH...
  
  DESCRIPTION:
  
    Generate HTML documentation.
  
    Includes all why3 sources and markdown pages
    accessible from PATH.
  
  
  OPTIONS:
  
    --root DIR change to directory
    --why3-warn-off WRN,… disable why3 warnings
    --no-autoload  disable downloading of missing provers
    --no-autodetect  disable prover autodetection
    --no-downloaded  disable downloaded provers
    --package ±PKG,… add package dependency
    --driver ±DRV,… configure drivers
    -p  same as --package
    -D  same as --driver
    -t TITLE document title (default none)
    -o DIR destination directory (default "html")
    -u output generated URI
    --url URL prefix URL for external packages.
    --debug FLAG Activate the given debug flag (eg default)
    --why3-debug FLAG Activate the given Why3 debug flag
    --show-progress {never|auto|always} When to show progress
    -help  Display this list of options
    --help  Display this list of options
  







