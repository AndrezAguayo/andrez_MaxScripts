currentSelection = getCurrentSelection()
inc = -20;
for obj  in currentSelection do
(	
	obj.modifiers[#Time_Offset].Time_Offset.animationTrack = inc;

	inc += .25;
	print inc; 
)





currentSelection = getCurrentSelection()
--inc = -20;
for obj  in currentSelection do
(	
	obj.modifiers[#Time_Offset].Time_Offset.animationTrack *= 1.5;

	inc += .25;
	print inc; 
)


---  Scale Value

---  Offset by Selection 
---      -> Offset Amount
---      -> Randomize Amount 
---      -> Randomize Selection

--- 
---
random .5 1.5

function offest_time_attribute mySelection randomAmount offsetStart incAmount= 
(
	--- This function ofsets the  ofset Attribute. It also allows for some randomization if wanted
	--- Also takes in the Offset Start Value and the Offset incrament amount
	---------------------------------------------------------------------------------------------------------
	inc = offsetStart;
	randomMax = 1+randomAmount;
	randomMin = 1-randomAmount;
	
	for obj in mySelection do 
	(
		randomVal = random randomMin	randomMax;
		
		obj.modifiers[#Time_Offset].Time_Offset.animationTrack = inc*randomVal ;
	
		inc += incAmount
		
	)
)