--- Create a custom atter --- 
(
--Create the defintion for the custom attribute 
def=attributes Time_Offset 
( 
--Parameter block to store the tracks of animation 
parameters testP rollout:testR 
( 
	
--A track of animation 
--Look under scripted plugins for the types that can be used. 
animationTrack type:#float UI:mySpinner 
	
) 


--The rollout that will show up in the modifier panel. 
rollout testR "Custom Attributes" 
( 
--The spinner that is connected to the animationTrack 
spinner mySpinner "Time_Offset" 
) 
) 

eM=emptyModifier() 
addModifier $ eM 
--Add the definition to the emptyModifier 
custAttributes.add eM def;

)