#@+leo-ver=5-thin
#@+node:ville.20101127205006.2026: * @thin export.py

import sloppycode.shortcuts as sc
#g.sh = sc.shrun
#g.cap = sc.shcap
#g.ns = sc.ns
#g.cd = sc.chdir
#@+<< meat >>
#@+node:ville.20101127205006.2027: ** << meat >>
sc.ns.VER = "1.0.1"
sc.ns.PACKAGE = 'com.vivainio.qmlreddit'

sh = sc.shrun
sc.verbose = 1
with sc.chdir('..'):
    sh("git archive -o ${PACKAGE}-${VER}.tar --prefix ${PACKAGE}-$VER/ HEAD" )
    sh("gzip ${PACKAGE}-${VER}.tar")
    sh('tar tf ${PACKAGE}-${VER}.tar.gz')
    sh('specify ${PACKAGE}.yaml')
#@-<< meat >>
#@-leo
