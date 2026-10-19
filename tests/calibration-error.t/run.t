A prover that fails during calibration (here: not enough memory) has its
error reported.

  $ cat > why3.conf <<EOC
  > [main]
  > magic = 14
  > memlimit = 5
  > timelimit = 5.000000
  > [partial_prover]
  > name = "Alt-Ergo"
  > path = "$(which alt-ergo)"
  > version = "$(alt-ergo --version | tr -d '\n')"
  > EOC
  $ export WHY3CONFIG=$PWD/why3.conf
  $ why3find prove foo.mlw 2>&1 | sed 's/@[v0-9.]*/@VERSION/'
  Error: can not calibrate prover alt-ergo@VERSION
  High failure (signaled)
