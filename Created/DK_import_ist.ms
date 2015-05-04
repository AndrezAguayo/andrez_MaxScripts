myPath = "\\chiproduction.thisisdk.com\\chiproduction\\users\\aaguayo\\LesSchwab_Rig_Test\\2D\\PSL_Exports\\mechanic_v08\\mechanic_v08\\N0006.png" 


bob = getSavePath()
jeff="L:\users\aaguayo\LesSchwab_Rig_Test\2D\PSL_Exports\mechanic_v08\mechanic_v08\mechanic_v08\N0021.ai"


fileName=  

getDirectories jeff

for i in getFiles jeff do 
(
	pathString = i as string
	--print pathString
	tolken = filterString pathString "\\"
	--fileName = tolken[tolken.count]
	print tolken[tolken.count]
)


InventorImport.ReplaceScene 

InventorImport.ReplaceScene:False 

InventorImport.ReplaceScene false
importFile jeff #noPrompt using:Adobe_Illustrator_Shape


$shape1.name= "N0023"
#noPrompt using:Adobe_Illustrator_Shape 



getmethods importFile
using:Adobe_Illustrator_Shape
Interface: InventorImport


getproperties 
listproperties
getmethods 
listmethods 
showProperties
