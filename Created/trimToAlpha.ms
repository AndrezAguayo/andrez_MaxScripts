--MAXScript Tutorials
--LESSON 01
--by Borislav Petrov [FA]
--bobo@email.archlab.tuwien.ac.at
-----------------------------------------------
--Visit 
--http://support.ktx.com/~10 
--for more MAXScript information and resources.
--Visit the Diner
--http://support.ktx.com/~8 
--for a public discussion on these Tutorials.
-----------------------------------------------
--Open a New Max scene
--Load the script
--PRESS Ctrl+E to Evaluate


work_bmp = openbitmap "C:\\Users\\dkstaff\\Desktop\\LES_SCHWAB_for_Andrez\\02_Elements\\04_Raster\\01_PSDs\\01_Characters\\Man_Image6\\_0003_HandR_A.png"
--open an existing TGA bitmap from the tutorials directory.
--make sure to change the path if your path is different.

bmp_w = work_bmp.width
--read the width of the bitmap into a variable

bmp_h = work_bmp.height
--read the height of the bitmap into a variable

progressstart "Generating Objects..."
--display progress indicator

for h = 1 to bmp_h do
--loop through all rows in the image
	(
	pixel_line = getpixels work_bmp [0,(h-1)] bmp_w
	--store a single row #h into an array
	
	progressupdate (h as float /bmp_h *100)
	--update the progress indicator
	
	for w = 1 to bmp_w do
	--loop through all pixels in the current row
		(
		size_value = 100 + (pixel_line[w].a)
		--calculate a value based on the luminosity (R+G+B)/3 of the pixel. 
		
		new_object = box length:100 width:100 height:size_value
		--create a new box with height based on the pixel value above
		
		new_object.pos = [w*100, (-h*100), 0]
		--put the new object on a new position based on the pixel's coords.
		--NOTE that in MAX, 0,0 is lower left corner, in images the UPPER left
		--this explains the - sign in (-h*100)
		--100 is the distance between objects.
		
		new_material = standardmaterial diffuse:pixel_line[w]
		--create a new standard material with diffuse color taken from the pixel's color
		
		new_object.material = new_material
		--assign the new material to the new object
		
		)--end w loop
	
	)--end h loop

progressend ()	
--end of the progress display

close work_bmp
--close the bitmap

	
$.modifiers[#Edit_Poly].Select #Vertex #{1..2}
$.modifiers[#Edit_Poly].MoveSelection  [0,201.68,0] 
parent:(transMatrix [-1846.3855,-115.5039,0.0000]) axis:(transMatrix [-1846.3855,-3859.0527,0.0000])





	
sel = polyop.getvertselection $
--ep = editable_mesh name:(uniquename"EPoly") --create an empty EMesh
convertTo ep Editable_Poly --convert to Editable_Poly 
	
	
myPlane = plane()	
--ep = editable_mesh name:(uniquename"EPoly") --create an empty EMesh
myPlane = convertTo $ Editable_Poly --convert to Editable_Poly 

vertPosition = polyop.getvert myPlane 3
polyop.setvert myPlane 3 [vertPosition.x,vertPosition.y,vertPosition.z+5]

1 = TopL
2 = bottomL
3 = TopR
4 = bottomR

-- ok so working with relative posion here on moving bit maps! 






$.modifiers[#Edit_Poly].MoveSelection  [0,201.68,0] parent:(transMatrix [-1846.3855,-115.5039,0.0000]) axis:(transMatrix [-1846.3855,-3859.0527,0.0000])
	
$.modifiers[#Edit_Poly].MoveSelection  [0,-2705,0] axis:(transMatrix [0.0000,-1980.0000,0.0000])

$.modifiers[#Edit_Poly].Select #Vertex #{1}.position
	
	
pixel_line = getpixels work_bmp [0,0] bmp_w	

pixel_line[1].alpha 
	
	
pixel_line = getpixels work_bmp [0,(h-1)] bmp_w 
	
wArray = #()
hArray = #()



bmp_w = work_bmp.width
bmp_h = work_bmp.height


-- find lowest alpha pixel
for h = 1 to bmp_h do
(
	pixel_line = getpixels work_bmp [0,(h-1)] bmp_w

	for w = 1 to bmp_w do
	(--loop through all pixels in the current row
		alphaValue =  (pixel_line[w].a)
		-- if alpha is not 0 then
		if alphaValue != 0.0 then
		(
			append wArray w
			append hArray h
		)
	)	
)	
widthMax = amax wArray-- jot down the h and the w into an array 
heightMAx = amax hArray	

WidthMin = amin wArray
heightMin = amin hArray	
		
	
	-- ask for the min and max of H and W
	-- and Bomm!!! Big tits all day! 
			
	
-- find highest alpha pixel 
-- find rightmost alpha pixel	
-- find leftmost alpha pixel  	


myPlane = plane()	
--ep = editable_mesh name:(uniquename"EPoly") --create an empty EMesh
myPlane = convertTo $ Editable_Poly --convert to Editable_Poly 


myEPoly.preserveUvs = True

-- Top Row of verts must be moved down 
vertPosition = polyop.getvert myPlane 3 


$.modifiers[#Edit_Poly].MoveSelection [0,-heightMin,0]

$.modifiers[#Edit_Poly].MoveSelection [0,bmp_h-heightMax,0]

$.modifiers[#Edit_Poly].MoveSelection [WidthMin,0,0]

$.modifiers[#Edit_Poly].MoveSelection [-(bmp_w-WidthMin),0,0]



move $.selectedVerts [0,-WidthMin,0]


polyop.movevert myPlane 3 [vertPosition.x,vertPosition.y  ,vertPosition.z]
vertPosition = polyop.getvert myPlane 4
polyop.setvert myPlane 4 [vertPosition.x,vertPosition.y - WidthMin ,vertPosition.z]

	