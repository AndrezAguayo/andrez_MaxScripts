/*
Created By: Paul Neale
Company: PEN Productions

Thanks go to Jon Lanz from Blizzard for the GetSelectedRoots function. 

Purpose: Creates groups like in Maya using point helpers

Bugs:
-Check box in menus doesn't update correctly. This is with the Colours options that
	is currently disabled.

Wish List:

To Do:
-Unique name function
-Hook up colours
*/

--Main Struct
struct mGroup 
(
--Script Version
versionVr = "Version: 0.01 
Created By: Paul Neale 
Company: PEN Productions Inc.
Last Updated: Nov. 10 2003",
	
	--Help Function
	fn help =
	(
		helpStr =
		"
		--Display Options Rollout
		mGroup.options()
		--Creates point helpers 
		mGroup.mkPoint <Object : Node> <trans:Matrix3/undefined>
		--Called by displayPoints but can be used on it's own
		mGroup.displayPoints <Point Helper> <True/False>
		--Display and Hide point helpers
		mGroup.showHidePoints <True/False : Boolean>
		--Write to the mGroup INI file
		mGroup.writeIni <section : string> <key : String> <val : String>
		--Creates the default INI file
		mGroup.createIni()
		--Creates an M Group using settings in the INI file
		mGroup.createMgroup()
		--Ungroups objects
		mGroup.deleteMgroup()
		"
		format "%\n" helpStr
	),
	
	--Path to INI file
	pathVr = ((getDir #plugCfg) + "\\mGroup.ini"),
	
	--Creates options rollout
	fn options =
	(
		mGroup.createIni()
		rollout mGoptionsR "\"M\" Group Options" width:190
		(
			local btW=80
			group "Align To:"
			(
				radioButtons alignToRb "" labels:#(":Local", ":Parent", ":World", ":Selection Center") columns:1 align:#left
			)
			group "Affects:"
			(
				radioButtons affectRb "" labels:#(":Group Each Object", ":Group All Objects") columns:1 align:#left
			)
			group "Creation Display:"
			(
				radioButtons showGroupRb "" labels:#(":Hide Group Point Helpers", ":Show Group Point Helpers") columns:1 align:#left
			)
			group "Post Display:"
			(
				checkBox selOnlyCb ":Selected Only" --***Need to hook this up.
				spinner pointSizeSp "Point Size:" range:[0,1000,20]
				button showPointsBt "On" width:btw across:2
				button hidePointsBt "Off" width:btW
			)
			group "Group:"
			(
				button groupBt "Group" width:btW across:2
				button unGroupBt "Ungroup" width:btW
			)
--			button cancelBt "Cancel" width:btW align:#right
			
			on mGoptionsR open do
			(
				mG=mGroup()
				alignToRb.state = (getIniSetting mG.pathVr "mGroup:" "AlignTo:") as integer
				affectRb.state = (getIniSetting mG.pathVr "mGroup:" "Affect:") as integer
				showGroupRb.state = (getIniSetting mG.pathVr "mGroup:" "ShowGroup:") as integer
				pointSizeSp.value = (getIniSetting mG.pathVr "mGroup:" "PointSize:") as float
				selOnlyCb.checked = execute (getIniSetting mG.pathVr "mGroup:" "Selonly:")
--				if affectRb.state==2 then alignToRb.enabled=false
			)
			
			on alignToRb changed state do (mGroup.writeIni "mGroup:" "AlignTo:" (state as string))
			on affectRb changed state do 
			(
/*				if state == 1 then 
				(
					alignToRb.enabled=true
				)
				if state == 2 then 
				(
					alignToRb.enabled=false
					alignToRb.state=4
					mGroup.writeIni "mGroup:" "AlignTo:" (4 as string)
				)
*/
				mGroup.writeIni "mGroup:" "Affect:" (state as string)
			)
			on showGroupRb changed state do (mGroup.writeIni "mGroup:" "ShowGroup:" (state as string))
			
			on selOnlyCb changed state do (mGroup.writeIni "mGroup:" "Selonly:" (selOnlyCb.checked as string))
			on pointSizeSp entered do (mGroup.writeIni "mGroup:" "PointSize:" (pointSizeSp.value as string))
			on pointSizeSp buttonUp do (mGroup.writeIni "mGroup:" "PointSize:" (pointSizeSp.value as string))
			on showPointsBt pressed do (mGroup.showHidePoints true)
			on hidePointsBt pressed do (mGroup.showHidePoints false)
			
			on groupBt pressed do (mGroup.createMgroup())
			on unGroupBt pressed do	(mGroup.deleteMgroup())
			
--			on cancelbt pressed do (destroyDialog mGoptionsR)
		)
	),
	
	--Colour setup.
	fn colourSetup =
	(
		rollout colourR "Colour Setup" width:190
		(
			local fW=30, btW=80
			GroupBox grp1 "Colours:" pos:[4,7] width:182 height:163
			label leftRightLb "                                Left <- > Right" pos:[14,26] width:171 height:13
				
				--Geo
			colorPicker geoL "" pos:[100,45] width:35 height:20 color:(color 0 0 155) fieldWidth:30
			colorPicker geoR "" pos:[143,45] width:35 height:20 color:(color 0 0 155) fieldWidth:30
			label geoLb "Geometry:" pos:[15,45] width:65 height:15
			
			colorPicker shapesL "" pos:[100,70] width:35 height:20 color:(color 0 0 155) fieldWidth:30
			colorPicker shapesR "" pos:[143,70] width:35 height:20 color:(color 0 0 155) fieldWidth:30
			label shapesLb "Shapes:" pos:[15,70] width:65 height:15
			
			colorPicker cp9 "" pos:[100,95] width:35 height:20 color:(color 0 0 155) fieldWidth:30
			colorPicker cp10 "" pos:[143,95] width:35 height:20 color:(color 0 0 155) fieldWidth:30
			label helpersLb "Helpers:" pos:[15,95] width:65 height:15
			
			colorPicker bonesl "" pos:[100,120] width:35 height:20 color:(color 0 0 155) fieldWidth:30
			colorPicker bonesR "" pos:[143,120] width:35 height:20 color:(color 0 0 155) fieldWidth:30
			label bonesLb "Bones:" pos:[15,120] width:65 height:15
			
			colorPicker miscCol "" pos:[143,145] width:35 height:20 color:(color 0 0 155) fieldWidth:30
			label lbl7 "Others:" pos:[15,145] width:65 height:15
			
			GroupBox grp3 "All Objects:" pos:[5,176] width:182 height:45
			checkbox useForAllCb ":Use For All" pos:[15,196] width:75 height:15 checked:true
			colorPicker allCol "" pos:[143,196] width:35 height:20 color:(color 0 0 155) fieldWidth:30
			
			button setBt "Set" pos:[12,226] width:80 height:21
			button cancelBt "Cancel" pos:[97,226] width:80 height:21
						
			on cancelBt pressed do (destroyDialog colourR)
		)	
	),
	
	--Menu items
	fn menus =
	(
		rcMenu mGroupMenu
		(
			local useCol = true
			subMenu "File"
			(
				menuItem close "Close"
			)
--			subMenu "Colours"
--			(
--				menuItem useColour "Use Colour" checked:useCol
--				menuItem setupColour "Set Up Colour"
--			)
			subMenu "Help"
			(
				menuItem help "Help!"
				menuItem email "Email"
				seperator helpSep01 
				menuItem version "Author/Version Number..."
			)
			
			on close picked do
			(
				destroyDialog (mGroup.options())
			)
			
			on useColour picked do
			(
				useCol=not useCol
				--useColour.checked = useCol
				print useCol
			)
			on setupColour picked do
			(
				mG=mGroup()
				createDialog (mG.colourSetup()) pos:((getdialogPos (mG.options())) + [195,0])
			)
			
			on help picked do
			(
				shellLaunch "http://members.rogers.com/paulneale" ""
			)
			on email picked do
			(
				shellLaunch "mailTo:pen_productions@yahoo.com" ""
			)
			on version picked do
			(
				mG = mGroup()
				ver = (mG.versionVr as string)
				messageBox ver title:"Author/Version"
			)
		)
	),
	
	--Show/Hide points
	fn showHidePoints tf =
	(
		mG=mGroup()
		objs = case (execute (getIniSetting mG.pathVr "mGroup:" "Selonly:")) of 
		(
			true: selection
			false: objects
		)
		for x in objs do
		(
			if (classOf x) == point then
			(
				mGroup.displayPoints x tf
			)
		)
	),
	
	--Write INI
	fn writeIni section key val =
	(
		mG=mGroup()
		setIniSetting mG.pathVr section key val
	),
	
	--Create INI on first run with default settings
	fn createIni =
	(
		mG = mGroup()
		if (getFiles mg.pathVr).count == 0 then
		(
			mGroup.writeIni "mGroup:" "AlignTo:" "1"
			mGroup.writeIni "mGroup:" "Affect:" "2"
			mGroup.writeIni "mGroup:" "PointSize:" "10"
			mGroup.writeIni "mGroup:" "ShowGroup:" "1"
			mGroup.writeIni "mGroup:" "Selonly:" "false"
		)
	),
	
	--get transform for group
	--obj is a single object if Group Each Object is selected and an array if Group All Objects is selected.
	fn transGroup obj =
	(
		mG=mGroup()
		lpw = (getIniSetting mG.pathVr "mGroup:" "AlignTo:") as integer
		affects=(getIniSetting mG.pathVr "mGroup:" "Affect:") as integer
		case lpw of
		(
			1: 
			(
				case affects of
				(
					1: obj.transform
					2: 
					(
						if obj.count == 0 then return undefined
						if obj.count > 1 then
						(
							pos=[0,0,0]
							for x in obj do (pos+=x.pos)
							pos/=obj.count
							(matrix3 [1,0,0] [0,1,0] [0,0,1] pos)
						)else --if there is only one object selected then return the transform for that object.
						(
							(matrix3 [1,0,0] [0,1,0] [0,0,1] obj[1].pos)
						)
					)
				)
			)
			2: 
			(
				case affects of
				(
					1: if obj.parent != undefined then (obj.parent.transform)else (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
					2: 
					(
						if obj.count == 0 then return undefined
						if obj.count > 1 then
						(
							pos=[0,0,0]
							for x in obj do 
							(
								if x.parent != undefined then 
								(
									pos+=x.parent.pos
								)else
								(
									pos+=[0,0,0]
								)
								
							)
							pos/=obj.count
							(matrix3 [1,0,0] [0,1,0] [0,0,1] pos)
						)else --if there is only one object selected then return the transform for that object.
						(
							if obj[1].parent != undefined then (obj[1].parent.transform)else (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
						)	
					)
				)
			)
			3: 
			(
				case affects of
				(
					1: (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
					2: (matrix3 [1,0,0] [0,1,0] [0,0,1] [0,0,0])
				)
			)
			4: 
			(
				case affects of
				(
					1: (matrix3 [1,0,0] [0,1,0] [0,0,1] selection.center)
					2: 
					(
						if obj.count == 0 then return undefined
						if obj.count > 1 then
						(
							pos=[0,0,0]
							for x in obj do (pos+=x.center)
							pos/=obj.count
							(matrix3 [1,0,0] [0,1,0] [0,0,1] pos)
						)else --if there is only one object selected then return the transform for that object.
						(
							(matrix3 [1,0,0] [0,1,0] [0,0,1] obj[1].center)
						)
					)
				)
			)
		)
	),
	
/*	--Finds the center of the pivots of the most parent objects selected.
	fn parentCenter objs =
	(
		if objs.count == 0 then return undefined
		if objs.count > 1 then
		(
			pos=[0,0,0]
			for x in objs do (pos+=x.pos)
			pos/=objs.count
			return (matrix3 [1,0,0] [0,1,0] [0,0,1] pos)
		)else --if there is only one object selected then return the transform for that object.
		(
			return objs[1].transform
		)
	),
*/	
	--Makes point helpers
	fn mkPoint obj trans =
	(
		mG=mGroup()
		pt = point()
		pt.transform = if trans == undefined then(mG.transGroup obj)else(trans)
		pt.name = (obj.name + "_group") --uniqueName --***Need to work on this
		pt.wireColor=[255,255,0]
		tf = case ((getIniSetting mG.pathVr "mGroup:" "ShowGroup:") as integer) of 
		(
			1: false
			2: true 
		)
		mGroup.displayPoints pt tf
		return pt
	),
	
	
	fn groupAllMakePoint obj trans =
	(
		mG=mGroup()
		pt = point()
		pt.transform = trans
		pt.name = (obj.name + "_group") --uniqueName --***Need to work on this
		pt.wireColor=[255,255,0]
		tf = case ((getIniSetting mG.pathVr "mGroup:" "ShowGroup:") as integer) of 
		(
			1: false
			2: true 
		)
		mGroup.displayPoints pt tf
		return pt
	),
	
	--Displays/Hides points
	--***This doesn't hide them in Max terms but turns off the display properties of the point helpers.
	--***It does unhide them when they are displayed though.
	fn displayPoints pt tf =
	(
		mG=mGroup()
		pt.size = (getIniSetting mG.pathVr "mGroup:" "PointSize:") as float
		pt.box = tf
		pt.centerMarker = false
		pt.axisTripod = false
		pt.cross = tf
		pt.constantscreensize = false
		pt.drawontop = false
		if tf then (unHide pt)
	),
	
	--Gets the parent object
	fn getParent obj =
	(
		return obj.parent
	),
	
	--Returns the most parent objects of a selection
	fn GetSelectedRoots selObjs =
	(
		-- this will store the 'most parent' abjects as we find them
		local rootObjs = #()
		
		for obj in selObjs do 		(
			local hasSelParent = false
			
			local curObj = obj
			local isDone = false
			while not IsDone do
			(
				if curObj.parent == undefined then
				(
					isDone = true
				)
				else if finditem selObjs curObj.parent != 0 then
				(
					hasSelParent = true
					isDone = true
				)
				else curObj = curObj.parent
			)
			
			if not hasSelParent then append rootObjs obj
		)
		return rootObjs
	),
	
	--Called when creating an "M" Group
	fn createMgroup =
	(
		mG=mGroup()
		mG.createIni()--Create the INI if it doesn't exist
		affects=(getIniSetting mG.pathVr "mGroup:" "Affect:") as integer
		local allPt=#()
		undo on
		(
		case affects of
		(
			1:--If the objects are to have seperate groups do this.
			(
				for x in selection do
				(
					if not (isGroupMember x) then
					(
						parentObj = mGroup.getParent x
						pt = mGroup.mkPoint x undefined
						append allPt pt
						
						if parentObj != undefined then
						(
							pt.parent = parentObj
						)
						x.parent = pt
					)
				)
				select allPt
			)
			2:--if the objects are to be all grouped together do this.
			(
				
				selObjs=(selection as array)--Selected objects
				if selObjs.count>0 then
				(
					selRoots=mGroup.GetSelectedRoots selObjs--most parent objects
					trans=mGroup.transGroup selRoots--transform
					parentObj = if selRoots.count == 1 then (mGroup.getParent selObjs[1])else(undefined)--Parent of an object
					pt=mGroup.mkPoint selObjs[1] trans
					append allPt pt
					
					for x in selObjs do
					(
						if not (isGroupMember x) then
						(
							x.parent=pt
						)
					)
				)
			)
		)
		select allPt
		)
	),
	
	--Delete group
	fn deleteMgroup =
	(
		del=#()
		for x in selection do
		(
			if (classOf x)==point then
			(
				append del x
				children=x.children
				parent=x.parent
				children.parent=parent
			)
		)
		delete del
	)
)

