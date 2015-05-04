import maya.cmds as cmds
def smoothStep(x):
    val = x*x*(3 - 2*(x))
    return val

for i in range (int(STEP +1)):
    print "here is i: ", i 
    
    v = i/STEP
    
    v = smooth_step(v)
    
    X = (end_pos*v) + (start_pos * (1-v))
    
    print X 
    
    
mySphere = cmds.sphere(n = "testSpehere")

cmds.keyframe(mySphere