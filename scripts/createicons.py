import glob,os, sys

svgic = glob.glob("../*.svg")

pri = ["# autogenerateb by createicons.py"]



for ic in svgic:
    bn = os.path.basename(ic)
    name = os.path.splitext(bn)[0]
    
    sizes = [16, 24, 32, 64]
    for sz in sizes:
        tgt = os.path.abspath("../data/%dx%d" % (sz, sz))
        if not os.path.isdir(tgt):
            os.makedirs(tgt)
            print "mkdir",tgt
        cmd = "convert -depth 32 -background transparent -resize %dx%d %s %s/%s.png" % (
            sz, sz, ic, tgt, name
            
        )
        
        pri.append("icon%d.files = data/%dx%d/%s.png" % (sz, sz, sz, name))
        pri.append("icon%d.path = /usr/share/icons/hicolor/%dx%d/apps" % (sz, sz, sz))
        pri.append("INSTALLS += icon%d" % sz)
        
        print cmd
        os.system(cmd)

open ("../installicons.pri", "w").write("\n".join(pri))    