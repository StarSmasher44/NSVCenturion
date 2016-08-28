/obj/overmap/ship
	name = "generic ship"
	desc = "Space faring vessel."
	icon = 'maps/overmap/bearcat/bearcat.dmi'
	icon_state = "ship"
	var/vessel_mass = 9000 //tonnes, random number
	var/id = 1001 // used to link ship and console

	var/obj/machinery/computer/helm/nav_control

/obj/overmap/ship/initialize()
	for(var/obj/machinery/computer/helm/H in world)
		if(H.id == src.id)
			nav_control = H
			H.linked = src

/obj/overmap/ship/proc/CanMove() //TODO: Add Engine shit and other problems.
	if(nav_control)
		return 1

/obj/overmap/ship/proc/GetSpeed()
	// Engine Power divided by mass.
	return 2

/obj/overmap/ship/proc/MoveTo(var/turf/T)
	if(get_dist(src.loc, T) > 1)
		Move(T, get_dir(src.loc,T))
		walk_to(src, T, 1, GetSpeed(), 2)



