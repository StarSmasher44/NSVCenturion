/obj/overmap/ship
	name = "NSV Icarus"
	desc = "Space faring vessel."
	icon = 'maps/overmap/bearcat/bearcat.dmi'
	icon_state = "ship"
	var/vessel_mass = 9000 //tonnes, random number
	var/default_delay = 60
	var/list/speed = list(0,0)
	var/last_burn = 0
	var/list/last_movement = list(0,0)
	var/fore_dir = NORTH
	var/rotate = 1 //For proc rotate
	var/id = 1001
	var/obj/effect/landmark/TravelMarker


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

/obj/overmap/ship/proc/is_still()
	return !(speed[1] || speed[2])

/obj/overmap/ship/proc/get_acceleration()
	return 100/vessel_mass

/obj/overmap/ship/proc/get_speed()
	return round(sqrt(speed[1]*speed[1] + speed[2]*speed[2]))

/obj/overmap/ship/proc/get_heading()
	var/res = 0
	if(speed[1])
		if(speed[1] > 0)
			res |= EAST
		else
			res |= WEST
	if(speed[2])
		if(speed[2] > 0)
			res |= NORTH
		else
			res |= SOUTH
	return res

/obj/overmap/ship/proc/adjust_speed(n_x, n_y)
	speed[1] = Clamp(speed[1] + n_x, -default_delay, default_delay)
	speed[2] = Clamp(speed[2] + n_y, -default_delay, default_delay)
	if(is_still())
		toggle_move_stars(src.TravelMarker)
	else
		toggle_move_stars(src.TravelMarker, fore_dir)

/obj/overmap/ship/proc/can_burn()
//	if (!eng_control)
//		return 0
	if (world.time < last_burn + 10)
		return 0
//	if (!eng_control.burn())
//		return 0
	return 1

/obj/overmap/ship/proc/get_brake_path()
	if(!get_acceleration())
		return INFINITY
	return get_speed()/get_acceleration()

#define SIGN(X) (X == 0 ? 0 : (X > 0 ? 1 : -1))
/obj/overmap/ship/proc/decelerate()
	if(!is_still() && can_burn())
		if (speed[1])
			adjust_speed(-SIGN(speed[1]) * min(get_acceleration(),abs(speed[1])), 0)
		if (speed[2])
			adjust_speed(0, -SIGN(speed[2]) * min(get_acceleration(),abs(speed[2])))
		last_burn = world.time

/obj/overmap/ship/proc/accelerate(direction)
	if(can_burn())
		last_burn = world.time

		if(direction & EAST)
			adjust_speed(get_acceleration(), 0)
		if(direction & WEST)
			adjust_speed(-get_acceleration(), 0)
		if(direction & NORTH)
			adjust_speed(0, get_acceleration())
		if(direction & SOUTH)
			adjust_speed(0, -get_acceleration())


/obj/overmap/ship/proc/rotate(var/direction)
	var/matrix/M = matrix()
	M.Turn(dir2angle(direction))
	src.transform = M //Rotate ship

/obj/overmap/ship/process()
	if(!is_still())
		var/list/deltas = list(0,0)
		for(var/i=1, i<=2, i++)
			if(speed[i] && world.time > last_movement[i] + default_delay - abs(speed[i]))
				deltas[i] = speed[i] > 0 ? 1 : -1
				last_movement[i] = world.time
		var/turf/newloc = locate(x + deltas[1], y + deltas[2], z)
		if(newloc)
			Move(newloc, get_dir(src, newloc)
		if(rotate)
			rotate(get_heading())