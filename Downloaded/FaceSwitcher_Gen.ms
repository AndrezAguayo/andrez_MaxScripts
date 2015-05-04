/*************************************************************************************
Author:			Joe Gunn
Company:		Joe Gunn 3d

Script Version:	Read history below. 
Max Version: 	2008 and above
Purpose:		Facial animation, swapping textures via material IDs
				You must USE .bmp files for displaying the thumbnails in the UI.
				Also your bmp's must be named in 01.bmp, 02.bmp, all the way to 10.bmp
				
Bugs:
	-Most likely a bunch but hell it worx

Warning:
	-This script is the property of Joe Gunn
	-Use this script at your own risk. 
	-This script can be used in production free of charge.
*************************************************************************************/

rollout first_roll "Character_Faces" width:275 height:170
(
	button btnSetD "Set Dir:" pos:[5,11] width:42 height:22 toolTip:"locate your images"  
	edittext Fdir "" pos:[50,13] width:201 height:17
	button btn01 "01" pos:[62,40] width:32 height:32  
	button btn02 "02" pos:[102,40] width:32 height:32 
	button btn03 "03" pos:[142,40] width:32 height:32  
	button btn04 "04" pos:[182,40] width:32 height:32  
	button btn05 "05" pos:[220,40] width:32 height:32  
	button btn06 "06" pos:[62,78] width:32 height:32 
	button btn07 "07" pos:[102,78] width:32 height:32 
	button btn08 "08" pos:[142,78] width:32 height:32  
	button btn09 "09" pos:[182,78] width:32 height:32 
	button btn10 "10" pos:[220,78] width:32 height:32  
	--LAYER MANAGER		
	--checkbutton LayerMan "" pos:[12,76] width:27 height:27 toolTip:"Layers Toggle" checked:false images:#("ui\icons\LayerToolbar_24i.bmp", "ui\icons\LayerToolbar_24i.bmp", 6, 5, 5, 5, 5) across:8
	checkbutton LayerMan "" pos:[12,76] width:27 height:27 toolTip:"Layers Toggle" checked:false across:8
		------Open Curve Editor		
	--checkbutton CEdit "CurveEditor" pos:[12,44] width:27 height:27 toolTip:"Curve Toggle" checked:false images:#("ui\icons\TrackBar_24i.bmp", "ui\icons\TrackBar_24i.bmp", 2, 2, 2, 2, 2) across:8
	checkbutton CEdit "CurveEditor" pos:[12,44] width:27 height:27 toolTip:"Curve Toggle" checked:false across:8
	
	
	HyperLink JD "joegunn3D.com" pos:[6,110] width:77 height:16 visitedcolor:(color 255 0 0) color:(color 0 153 204) address:"www.joegunn3d.com"
	GroupBox grptoggles "" pos:[6,33] width:40 height:74
	label lbltag "If you don't know...better ask somebody" pos:[54,125] width:191 height:14
	
	
	on btnSetD pressed do
	(
		local curpath = Fdir.text 
		local newPath = getSavePath initialDir:(curpath) caption:"Select the path where your Face Images are located" 
		if newPath != undefined then
		(
			Fdir.text = newpath
			btn01.images = #(Fdir.text + "\01.bmp", Fdir.text + "\01.bmp", 1, 1, 1, 1, 1)
			btn02.images = #(Fdir.text + "\02.bmp", Fdir.text + "\02.bmp", 1, 1, 1, 1, 1)
			btn03.images = #(Fdir.text + "\03.bmp", Fdir.text + "\03.bmp", 1, 1, 1, 1, 1)
			btn04.images = #(Fdir.text + "\04.bmp", Fdir.text + "\04.bmp", 1, 1, 1, 1, 1)
			btn05.images = #(Fdir.text + "\05.bmp", Fdir.text + "\05.bmp", 1, 1, 1, 1, 1)
			btn06.images = #(Fdir.text + "\06.bmp", Fdir.text + "\06.bmp", 1, 1, 1, 1, 1)
			btn07.images = #(Fdir.text + "\07.bmp", Fdir.text + "\07.bmp", 1, 1, 1, 1, 1)
			btn08.images = #(Fdir.text + "\08.bmp", Fdir.text + "\08.bmp", 1, 1, 1, 1, 1)
			btn09.images = #(Fdir.text + "\09.bmp", Fdir.text + "\09.bmp", 1, 1, 1, 1, 1)
			btn10.images = #(Fdir.text + "\10.bmp", Fdir.text + "\10.bmp", 1, 1, 1, 1, 1)
		)
		
		)
	
	on btn01 pressed do
	(
		for i in selection do
			if i.modifiers[#Material] != undefined then
				i.modifiers[#Material].materialID = 1
	)
	
	on btn02 pressed do
	(
		for i in selection do
			if i.modifiers[#Material] != undefined then
				i.modifiers[#Material].materialID = 2
	)
	
	on btn03 pressed do
	(
		for i in selection do
			if i.modifiers[#Material] != undefined then
				i.modifiers[#Material].materialID = 3
	)
		
	on btn04 pressed do
	(
		for i in selection do
			if i.modifiers[#Material] != undefined then
				i.modifiers[#Material].materialID = 4
	)
	
	on btn05 pressed do
	(
		for i in selection do
			if i.modifiers[#Material] != undefined then
				i.modifiers[#Material].materialID = 5
	)
	
	on btn06 pressed do
	(
		for i in selection do
			if i.modifiers[#Material] != undefined then
				i.modifiers[#Material].materialID = 6
	)
	
	on btn07 pressed do
	(
		for i in selection do
			if i.modifiers[#Material] != undefined then
				i.modifiers[#Material].materialID = 7
	)
	
	on btn08 pressed do
	(
		for i in selection do
			if i.modifiers[#Material] != undefined then
				i.modifiers[#Material].materialID = 8
	)
	
	on btn09 pressed do
	(
		for i in selection do
			if i.modifiers[#Material] != undefined then
				i.modifiers[#Material].materialID = 9
	)
	
	on btn10 pressed do
	(
		for i in selection do
			if i.modifiers[#Material] != undefined then
				i.modifiers[#Material].materialID = 10
	)
	
	on LayerMan changed state do
	(
			if state == on 
			then macros.run "Layers" "LayerManager" -- Layer Manager
			else layermanager.closeDialog()
		)
	on CEdit changed state do
	(
		if state == on 
		then macros.run "Track View" "LaunchFCurveEditor"
		else trackviews.close 1
	)
)
	
FaceFloater = newRolloutFloater "Face Switcher V1.3" 275 176
cui.RegisterDialogBar FaceFloater style:#(#cui_floatable,#cui_dock_left,#cui_dock_right,#cui_handles)

addRollout first_roll FaceFloater


