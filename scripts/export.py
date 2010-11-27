#@+leo-ver=5-thin
#@+node:ville.20101127205006.2026: * @thin export.py

import sloppycode.shortcuts as sc
#g.sh = sc.shrun
#g.cap = sc.shcap
#g.ns = sc.ns
#g.cd = sc.chdir
#@+<< meat >>
#@+node:ville.20101127205006.2027: ** << meat >>
sc.ns.VER = "0.0.1"

sh = sc.shrun
with sc.chdir('..'):
    sh("git archive -o qmlreddit-${VER}.tar --prefix qmlreddit-$VER/ HEAD" )
    sh("gzip qmlreddit-${VER}.tar")
    sh('tar tf qmlreddit-${VER}.tar.gz')
    sh('specify qmlreddit.yaml')


#@-<< meat >>
#@-leo
