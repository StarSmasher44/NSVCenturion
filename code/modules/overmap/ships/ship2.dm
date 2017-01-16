/obj/overmap/ship
	name = "NSV Icarus"
	desc = "Space faring vessel."
	icon = 'maps/overmap/bearcat/bearcat.dmi'
	icon_state = "ship"
	var/vessel_mass = 9000 //tonnes, random number
	var/speed = 0
	var/fore_dir = NORTH
	var/rotate = 1 //For proc rotate
	var/id = 1001
	var/obj/effect/landmark/TravelMarker
	var/targetLoc


//	var/obj/effect/map/current_sector
	var/obj/machinery/computer/helm/nav_control
//	var/obj/machinery/computer/engines/eng_control

/obj/overmap/ship/initialize()
	for(var/obj/machinery/computer/helm/H in world)
		if(H.id == src.id)
			nav_control = H
			H.linked = src

	for(var/obj/effect/landmark/L in landmarks_list)
		if(L.name = "TravelMark")
			TravelMarker = L

	if(TravelMarker)
		for(var/turf/space/S in trange(70,TravelMarker.loc)) // Large estimate for now.
			spaceturfs.Add(S)
		world.log << "TRAVEL: Initialized list cache"

//	for(var/obj/machinery/computer/engines/E in machines)
//		if (E.z == map_z)
//			eng_control = E
//			break
//	for(var/obj/machinery/computer/helm/H in machines)
//		if (H.z == map_z)
//			nav_control = H
//			break
	processing_objects.Add(src)

/obj/overmap/ship/relaymove(mob/user, direction)
	accelerate(direction)
/*
/obj/overmap/ship/proc/is_still()
	return !(speed[1] || speed[2])
*/


/obj/overmap/ship/proc/get_heading()
	if(targetLoc)	return get_dir(src, targetLoc)

/obj/overmap/ship/proc/adjust_stars()
	if(is_still())
		toggle_move_stars(src.TravelMarker)
	else
		toggle_move_stars(src.TravelMarker, fore_dir)

/obj/overmap/ship/proc/CanMove() //TODO: Add Engine shit and other problems.
	if(nav_control)
		return 1

/obj/overmap/ship/proc/rotate(var/direction)
	var/matrix/M = matrix()
	M.Turn(dir2angle(direction))
	src.transform = M //Rotate ship

/obj/overmap/ship/process()
	if(!is_still())
		if(CanMove())
			if(targetLoc)
//				Move(newloc, get_dir(src, newloc))
				walk_to(src, targetLoc, 1, 2, 2)
				rotate(get_heading())