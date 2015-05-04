import maya.cmds as cmds


STEP = 24.0
start_pos = 0 
end_pos = 24.0 


mySphere = cmds.sphere()

    
def get_range(Curve_TYPE_FUNCTION, start_pos,end_pos, STEP):
    for i in range(int(STEP+1)):
        
        v = i/STEP
        v = Curve_TYPE_FUNCTION(v)
        VAL =(end_pos*v) +(start_pos *(1 - v))
        
        cmds.setKeyframe(mySphere[0], t= i, at="tx", v=VAL) 
        
    return "Set Keys"



def smoothStep(x):
    val = x*x*(3 - 2*(x))
    return valss

def linear(x):
    return x
       
def higherPower(x):
    val = x*x
    return val

def higherPower_inverse(x):
    val = 1 - (1-x) *(1-x)
    return val




keys = cmds.keyframe(q=True,attribute = "tx")



#keyVAl = cmds.keyframe(q=True,t=(0,0),attribute = "tx", eval=True)
keyValues = []
for i in keys:
    keyVAl = cmds.keyframe(q=True,t=(int(i),int(i)),attribute = "tx", eval=True)
    keyValues.append(keyVAl)
    


STEP = float(keys[-1])
start_pos =  keyValues[0][0]
end_pos =  keyValues[1][0]

 
 
get_range(smoothStep, start_pos,end_pos, STEP)
 
 
 
get_range(linear, start_pos,end_pos, STEP) 
 

 
get_range(higherPower, start_pos,end_pos, STEP) 

get_range(higherPower_inverse, start_pos,end_pos, STEP) 
  
 
"""
for i in range (int(STEP +1)):
    print "here is i: ", i 
    print "Here is Step: ", STEP
    v = i/STEP
    print "here is V: ", v  
    v = smoothStep(v)
    print "here is V after smoothStep: ", v 
    
    
    VAL = (end_pos*v) + (start_pos * (1-v))
    print "Here is Val: ", VAL    
    
    cmds.setKeyframe(mySphere[0], t= i, at="tx", v=VAL) 
        

"""    







