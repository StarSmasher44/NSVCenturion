var/global/datum/travel/ships/travelship

//NOTE TO SELF: Change size to shipweight for engine shit, make an area in space that will count the space tiles inside of it and delete itself for easier switching of size
//And easier customization and placement.

/datum/travel/ships
	var/name = ""
	var/active = 0 // 1 means loading settings for that ship, 0 means nuffin.
	var/size = 50 // Standard size, used to calculate space tiles that need changing.
	var/speed = 0 // 0 is standstill, 100 is full engine power.
	var/maxspeed = 100 // Usually the max, smaller ships may be less.
	var/overloadmax = 120 // Maximum percentage engine can be pushed

/datum/travel/ships/icarus
	name = "NSV Icarus"
	active = 1 // Currently on the Icarus
	size = 70
	maxspeed = 80
	overloadmax = 100

/datum/travel/ships/centurion
	name = "NSV Centurion"
	size = 100
	maxspeed = 100
	overloadmax = 120

