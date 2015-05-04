function add_empty_modifier_on_object myObject = 
(
	eM = emptyModifier() 
	addModifier myObject eM 
)


function add_atters_IK_FK obj = 
--- Create a custom atter --- 
(
	--Create the defintion for the custom attribute 
	myAtter = attributes IK_FK_Blend
	( 
		
	--Parameter block to store the tracks of animation 
	parameters testP rollout:testR 
		( 
			
		--A track of animation 
		--Look under scripted plugins for the types that can be used. 
		animationTrack type:#float UI:ik_fk_BlendSpinner 
			
		
		--animationTrack type:#integer UI:imageSwitchSpinner 	
			
		) 

		--The rollout that will show up in the modifier panel. 
		rollout testR "IK and FK Attributes" 
		(
			
		--The spinner that is connected to the animationTrack 
		spinner ik_fk_BlendSpinner "IK_FK_Blend" type:#float range:[0,100,0]
		button niceRack "Match IK --> FK" pos:[5,30] width:150 height:40 tooltip:"Match the position of the IK Ctrls to the FK Ctrls"
		button veryNiceRack "Match FK <-- IK" pos:[5,80] width:150 height:40 tooltip:"Match the position of the FK Ctrls to the IK Ctrls"
		--spinner mySpinner "Image_Switch" type:#integer range:[1,20,1]
		
		on niceRack pressed do 
		(
			print "hello you cooco"
		)
		) 	
	) 
	
	--eM=emptyModifier() 
	--addModifier obj eM 
	--Add the definition to the emptyModifier 
	--custAttributes.add eM myAtter;
	
	custAttributes.add obj.modifiers[#AttributeHolder] myAtter;
)



getpixels

showproperties mybox

	
pixel_line = getpixels work_bmp [0,(h-1)] bmp_w 

function make_rollout_string_for_materalID = 
(
	imageDir = "C:\\Users\\dkstaff\\Desktop\\LES_SCHWAB_for_Andrez\\02_Elements\\04_Raster\\01_PSDs\\01_Characters\\Man_Image6\\Icons\\_0000_Head_A.png"
	numbButtons = 15

	_X_counter = 5
	_Y_counter = 40	

	-- crazy ass string formatting to make a rollout with spicific amoutns of buttons
	str = ""

	str += "myAtter3 = attributes Image_Switch\n"
	str += "(\n"	
		--Parameter block to store the tracks of animation 
	str += "parameters testP rollout:testR" 
	str += "(" 
	str += "	animationTrack type:#integer UI:imageSwitchSpinner" 				
	str += ")" 
	str+= "rollout testR \"Material ID Attributes\" \n"
	str+= "(\n"
	str += 	"spinner imageSwitchSpinner \"Image_Switch\" type:#integer range:[1,20,1] \n"
	myCounter = 0

	for i in 1 to numbButtons do
	(	
		if i != 1 then 
		(		
			if  mod i 2 == 0 then
			(	
				_X_counter += 80 
				_Y_counter += 0
			)
			
			else
			(
				
				_X_counter -= 80 
				_Y_counter += 80
			)	
		)			
		buttonString = "button btn" + myCounter as string + " \"myButton" + myCounter as string  +"\" pos:[ "+ _X_counter as String +" , "+ _Y_counter as String +"] width:80 height:80  images:#(\""+ imageDir as string + "\" , \""+ imageDir as string +"\", 1, 1, 1, 1, 1) \n"
		str += buttonString

		myCounter += 1
	)

	str+= ")\n"
	str+= ")\n"

	return str
)



function add_atters_material_ID_test obj =  
(
	execute str
	custAttributes.add obj.modifiers[#AttributeHolder] myAtter3;
)



add_empty_modifier_on_object $
add_atters_IK_FK $
add_atters_material_ID_test $
