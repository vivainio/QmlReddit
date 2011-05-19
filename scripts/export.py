#@+leo-ver=5-thin
#@+node:ville.20101127205006.2026: * @thin export.py
import sloppycode.shortcuts as sc
import os

#@+others
#@+node:ville.20110516195430.2600: ** Doc
""" Script to generate necessary files for OBS

To get "sloppycode", do "bzr branch lp:sloppycode", and do "setup.py install".

"""
#@+node:ville.20101127205006.2027: ** meat
sc.ns.VER = "1.0"
sc.ns.PACKAGE = 'info.vivainio.qmlreddit'
sc.ns.OBSPRJ = sc.fpath('~/obs/home:vivainio/qmlreddit')
sc.ns.TARB = sc.fpath("${OBSPRJ}/${PACKAGE}-${VER}.tar")


sh = sc.shrun
sc.verbose = 1
with sc.chdir('..'):
    sh("git archive -o ${TARB} --prefix ${PACKAGE}-$VER/ HEAD" )
    sh("gzip ${TARB}")
    sh('tar tf ${TARB}.gz')
    sh('cp ${PACKAGE}.yaml ${PACKAGE}.spec ${PACKAGE}.changes ${OBSPRJ}')
    with sc.chdir('${OBSPRJ}'):
        sh('specify ${PACKAGE}.yaml')

#@-others
#@-leo
