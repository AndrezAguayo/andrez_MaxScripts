myAtter3 = attributes Image_Switch
(
	parameters testP rollout:testR(	animationTrack type:#integer UI:imageSwitchSpinner)rollout testR "Material ID Attributes" 
	(
		spinner imageSwitchSpinner "Image_Switch" type:#integer range:[1,4,1] 
		button btn0 "myButton0" pos:[ 5 , 40] width:80 height:80  images:#("C:\\Users\\dkstaff\\Desktop\\LES_SCHWAB_for_Andrez\\02_Elements\\04_Raster\\01_PSDs\\01_Characters\\Man_Image6\\Icons\\_0003_HandR_A.png" , "C:\\Users\\dkstaff\\Desktop\\LES_SCHWAB_for_Andrez\\02_Elements\\04_Raster\\01_PSDs\\01_Characters\\Man_Image6\\Icons\\_0003_HandR_A.png", 1, 1, 1, 1, 1) 
		button btn1 "myButton1" pos:[ 85 , 40] width:80 height:80  images:#("C:\\Users\\dkstaff\\Desktop\\LES_SCHWAB_for_Andrez\\02_Elements\\04_Raster\\01_PSDs\\01_Characters\\Man_Image6\\Icons\\_0004_HandR_B.png" , "C:\\Users\\dkstaff\\Desktop\\LES_SCHWAB_for_Andrez\\02_Elements\\04_Raster\\01_PSDs\\01_Characters\\Man_Image6\\Icons\\_0004_HandR_B.png", 1, 1, 1, 1, 1) 
		button btn2 "myButton2" pos:[ 5 , 120] width:80 height:80  images:#("C:\\Users\\dkstaff\\Desktop\\LES_SCHWAB_for_Andrez\\02_Elements\\04_Raster\\01_PSDs\\01_Characters\\Man_Image6\\Icons\\_0005_HandR_C.png" , "C:\\Users\\dkstaff\\Desktop\\LES_SCHWAB_for_Andrez\\02_Elements\\04_Raster\\01_PSDs\\01_Characters\\Man_Image6\\Icons\\_0005_HandR_C.png", 1, 1, 1, 1, 1) 
		button btn3 "myButton3" pos:[ 85 , 120] width:80 height:80  images:#("C:\\Users\\dkstaff\\Desktop\\LES_SCHWAB_for_Andrez\\02_Elements\\04_Raster\\01_PSDs\\01_Characters\\Man_Image6\\Icons\\_0006_HandR_A.png" , "C:\\Users\\dkstaff\\Desktop\\LES_SCHWAB_for_Andrez\\02_Elements\\04_Raster\\01_PSDs\\01_Characters\\Man_Image6\\Icons\\_0006_HandR_A.png", 1, 1, 1, 1, 1) 
	
		on btn0 pressed do
		(
			for i in selection do
			(
				print "tits"
				i.modifiers[#AttributeHolder].Image_Switch[#animationTrack].value = 1
			)
		)
		on btn1 pressed do
		(
			for i in selection do
			(
				i.modifiers[#AttributeHolder].Image_Switch[#animationTrack].value = 2
			)
		)
		on btn2 pressed do
		(
			for i in selection do
			(
				i.modifiers[#AttributeHolder].Image_Switch[#animationTrack].value = 3
			)
		)
		on btn3 pressed do
		(
			for i in selection do
			(
				i.modifiers[#AttributeHolder].Image_Switch[#animationTrack].value = 4
			)
		)
	)
)

custAttributes.add $.modifiers[#AttributeHolder] myAtter3;
	
	---  --> Wire Connect the ctrl material ID to the shader ID on the Plane 
wireConnect_ctrl_withPlane ctrl objPlan
	