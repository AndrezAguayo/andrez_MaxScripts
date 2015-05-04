/*
Created By: Paul Neale
Company: PEN Productions

Purpose: MacroScripts creating groups like in Maya using point helpers

Bugs:

Wish List:

To Do:

*/

macroScript mGroup \
	category:"\"M\" Group" \
	buttontext:"\"M\" Group" \
	toolTip:"Groups selected objects using \"M\" Group"
(
	on execute do
	(
		mG = mGroup()
		mG.createMgroup()
	)
	on altExecute type do
	(
		mG = mGroup()
		try(destroyDialog (mG.options()))catch()
		createDialog (mG.options()) menu:(mG.menus())
	)
)
macroScript mUnGroup \
	category:"\"M\" Group" \
	buttontext:"\"M\" Ungroup" \
	toolTip:"Ungroups selected objects using \"M\" Group"
(
	on execute do
	(
		mG = mGroup()
		mG.deleteMgroup()
	)
)
macroScript mGroupOptions \
	category:"\"M\" Group" \
	buttontext:"\"M\" Group Options" \
	toolTip:"Opens \"M\" Group Options window"
(
	on execute do
	(
		mG = mGroup()
		try(destroyDialog (mG.options()))catch()
		createDialog (mG.options()) menu:(mG.menus())
	)
)
macroScript mGroupDisplayOn \
	category:"\"M\" Group" \
	buttontext:"\"M\" Group Display On" \
	toolTip:"\"M\" Group Display On"
(
	on execute do
	(
		mG = mGroup()
		mG.showHidePoints true
	)
)
macroScript mGroupDisplayOff \
	category:"\"M\" Group" \
	buttontext:"\"M\" Group Display Off" \
	toolTip:"\"M\" Group Display Off"
(
	on execute do
	(
		mG = mGroup()
		mG.showHidePoints false
	)
)

