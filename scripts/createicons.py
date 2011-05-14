import glob,os, sys

svgic = glob.glob("../*.svg")

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
        
        print cmd
        os.system(cmd)
    