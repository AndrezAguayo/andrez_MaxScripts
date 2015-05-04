

function add_image_spinner obj= 
--- Create a custom atter --- 
(
	--Create the defintion for the custom attribute 
	myAtter =attributes Image_Switch 
	( 
		
	--Parameter block to store the tracks of animation 
	parameters testP rollout:testR 
		( 
			
		--A track of animation 
		--Look under scripted plugins for the types that can be used. 
		animationTrack type:#integer UI:mySpinner 
			
		) 

		--The rollout that will show up in the modifier panel. 
		rollout testR "Custom Attributes" 
		(
			
		--The spinner that is connected to the animationTrack 
		spinner mySpinner "Image_Switch" type:#integer range:[1,20,1]
		) 	
	) 
	
	eM=emptyModifier() 
	addModifier obj eM 
	--Add the definition to the emptyModifier 
	custAttributes.add eM myAtter;
	
)




make_standard_2d_ctrl "Lower_Arm"
connect_plane_with_ctrl $ForArmR_plane_Geo $Lower_Arm_Ctrl






make_standard_2d_ctrl "ForArmL"

connect_plane_with_ctrl $ForArmL_plane_Geo $ForArmL_Ctrl 



make_standard_2d_ctrl "Hand"
connect_plane_with_ctrl $HandR_plane_Geo $Hand_Ctrl


make_standard_2d_ctrl "Point"
connect_plane_with_ctrl $HandR_plane_Geo $Hand_Ctrl

