objA = $

objB = $

tempHelper = PointHelperObj name:"temp3" ;
tempHelper2 = PointHelperObj name:"temp4" ;
posA = objA.pos;
posB = objB.pos;
tempHelper.pos = (posB+ ((posA-posB)*.66666666666666666666666666666666666666666666));
tempHelper2.pos = (posB+ ((posA-posB)*.3333333333333333333333333333333333333333333333));


-- -createLocaters on joint



function temp_helper_locaters_on_joint myObj =
(
	currentBone = obj;
	tempHelper = PointHelperObj name:"tempA" ;
	tempHelper2 = PointHelperObj name:"tempB" ;

	poop = currentBone.children;

	poop[1].pos;


	tempHelper.pos = currentBone.pos;
	tempHelper2.pos = poop[1].pos;



	objA = tempHelper

	objB = tempHelper2

	tempHelper = PointHelperObj name:"temp3" ;
	tempHelper2 = PointHelperObj name:"temp4" ;
	posA = objA.pos;
	posB = objB.pos;
	tempHelper.pos = (posB+ ((posA-posB)*.66666666666666666666666666666666666666666666));
	tempHelper2.pos = (posB+ ((posA-posB)*.3333333333333333333333333333333333333333333333));
)
obj = $; 
temp_helper_locaters_on_joint obj

