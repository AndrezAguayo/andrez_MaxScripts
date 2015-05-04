/*//////////   SCRIPT:   Delete Modifiers v2.0   //////////*/	
/*//////////   WRITTEN BY:   Branko Zivkovic   //////////*/
/*//////////   EMAIL:   barigazy@hotmail.com   //////////*/	
try(destroyDialog ::delMods)catch()
rollout delMods "Delete Modifiers"
(
	fn collectUniqueNodes objs = if objs.count != 0 do
	(
		local uniqNodes = #(), allHandles = #{}, getObjIns = InstanceMgr.GetInstances 
		for o in objs where o.modifiers.count != 0 do append allHandles (getHandleByAnim o)
		while not allHandles.isEmpty do
		(
			obj = GetAnimByHandle (for i in allHandles do exit with i)
			getObjIns obj &firstOnly ; append uniqNodes firstOnly[firstOnly.count]
			for o in firstOnly do allHandles[(getHandleByAnim o)] = off
		) ; uniqNodes
	)
	fn uniqueModClassNames objArr = 
	(
		local modList = #()
		for o in objArr do
		(
			for i in 1 to o.modifiers.count where findItem modList (mcn = classOf o.modifiers[i] as string) == 0 do append modList mcn
		)
		sort modList
	)
	fn clearDeleted dnCtrl = (for i = dnCtrl.items.count-1 to 0 by -1 where dnCtrl.GetItemChecked i do dnCtrl.items.RemoveAt i)
	fn deleteMods objs modyClasses active: =
	(
		if getCommandPanelTaskMode() == #modify do setCommandPanelTaskMode #create
		undo off 
			with redraw off
			(
				for o in objs do 
				(
					for i = o.modifiers.count to 1 by -1 where findItem modyClasses (classof o.modifiers[i]) != 0 do 
					(
						if not active then deleteModifier o i else
						(
							if o.modifiers[i].enabled do deleteModifier o i
						)
					)
				)
			)
	)
	button btn_collect "Collect Scene Modifiers" pos:[3,3] width:144 height:18
	dotnetcontrol clb_mods "CheckedListBox" pos:[3,23] width:144 height:191 
	button btn_check "Check All" pos:[3,205] width:71 height:18
	button btn_uncheck "Uncheck All" pos:[76,205] width:71 height:18
	button btn_invert "Invert" pos:[3,225] width:71 height:18
	button btn_clear "Clear All" pos:[76,225] width:71 height:18	
	dropdownlist ddl_options "" pos:[3,245] width:144 items:#("Delete Modifiers", "Select By Modifiers", "Turn Modifiers On", "Turn Modifiers Off")
	checkbox cb_selObj "Selected Objects Only" pos:[3,268]
	checkbox cb_enable "Consider Active Modifiers" pos:[3,284]
	checkbox cb_iso "Isolate Selected Objects" pos:[3,300] enabled:off
	button btn_do "D o   T h e   J o b !" pos:[3,316] width:144 height:22
	on ddl_options selected i do
	(
		case of
		(
			(i==1): (cb_selObj.enabled = cb_enable.enabled = on ; cb_iso.enabled = cb_iso.checked = off)
			(i==2): 
			(
				cb_selObj.enabled = cb_enable.enabled = on
				if (maxVersion())[1] > 1400 then cb_iso.enabled = on else
					cb_iso.enabled = cb_iso.checked = off
			)
			(i==3 or i==4): (cb_selObj.enabled = on ; cb_enable.enabled = cb_enable.checked = cb_iso.enabled = cb_iso.checked = off)
		)
	)
	on delMods open do
	(
		clb_mods.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 40 40 40
		clb_mods.ForeColor = (dotNetClass "System.Drawing.Color").FromArgb 200 200 200
		clb_mods.BorderStyle = (dotNetClass "BorderStyle").FixedSingle
		clb_mods.HorizontalScrollbar = clb_mods.MultiColumn = false ; clb_mods.CheckOnClick = true
	)	
	on btn_collect pressed do
	(
		if clb_mods.Items.count != 0 do clb_mods.Items.Clear()
		local objs = if cb_selObj.checked then selection else objects
		if objs.count == 0 then messageBox "No objects in the scene!" title:"Warning" beep:off else
		(
			if (nodes = collectUniqueNodes objs).count == 0 then messageBox "The scene nodes not have modifiers!" title:"Warning" beep:off else
			(
				clb_mods.Items.AddRange (uniqueModClassNames nodes)
			)
		)
	)
	on btn_check pressed do (for i = 0 to clb_mods.Items.count-1 do clb_mods.SetItemChecked i true)
	on btn_uncheck pressed do (for i = 0 to clb_mods.Items.count-1 do clb_mods.SetItemChecked i false)
	on btn_invert pressed do (for i = 0 to clb_mods.Items.count-1 do clb_mods.SetItemChecked i (not (clb_mods.GetItemChecked i)))
	on btn_clear pressed do clb_mods.Items.Clear()
	on btn_do pressed do
	(
		if clb_mods.items.count == 0 then messageBox "Collect scene modifiers first!" title:"Warning" beep:off else
		(
			if clb_mods.CheckedItems.count == 0 then messageBox "Check modifiers that you want to delete!" title:"Warning" beep:off else
			(
				local modyClasses = (for i in 1 to clb_mods.CheckedItems.count collect (execute clb_mods.checkeditems.item[i-1]))
				local mods = #() ; for mc in modyClasses do join mods (getClassInstances mc)
				if cb_enable.checked and ddl_options.selection == 2 do mods = for m in mods where m.enabled collect m
				if mods.count == 0 then (messageBox ("Selected modifiers are deleted already!\nCollect scene modifiers and try again") title:"Warning" beep:off) else
				(
					case ddl_options.selection of
					(
						1:
						(
							local objs = #()
							for m in mods where (nodes = refs.dependentNodes m).count != 0 do join objs nodes
							format "mods: % \nobjs: %\n" mods objs
							if not cb_selObj.checked then 
							(	
								if (queryBox ("Do you want to perform deletion of selected modifiers?") beep:off) 
								then (deleteMods (collectUniqueNodes objs) modyClasses active:cb_enable.checked ; free mods ; free objs ; clearDeleted clb_mods)
								else (free mods ; free objs)
							)
							else
							(
								if selection.count == 0 then (free mods ; free objs ; messageBox "Select some objects first!" title:"Warning" beep:off) else
								(
									objs = collectUniqueNodes (for o in objs where o.isSelected collect o)
									if objs.count == 0 then (free mods ; messageBox "These modifiers are not assigned!" title:"Warning" beep:off) 
									else
									(
										if (queryBox ("Do you want to perform deletion of selected modifiers?") beep:off) 
										then (deleteMods objs modyClasses active:cb_enable.checked ; free mods ; free objs ; clearDeleted clb_mods)
										else (free mods ; free objs)
									)
								)	
							)
						)
						2:
						(
							local objs = #()
							for m in mods where (nodes = refs.dependentNodes m).count != 0 do join objs nodes
							select objs	
							if cb_iso.checked do with redraw off
							(
								if IsolateSelection.IsolateSelectionModeActive() do IsolateSelection.ExitIsolateSelectionMode()
								IsolateSelection.EnterIsolateSelectionMode() 
							)								
						)
						3: mods.enabled = on
						4: mods.enabled = off
					)	
				)
			)
		)
	)
)
createDialog delMods 150 340 10 110 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)