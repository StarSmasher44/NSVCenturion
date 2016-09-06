var/global/datum/travel/travel

/datum/travel
	var/obj/effect/landmark/TravelMarker
	var/list/spaceturfs = list()
	var/travelling = 0 // Starts docked
	var/initialized = 0
	var/datum/travel/ships/currentship

/datum/travel/proc/initialize()
	world.log << "Initializing"
	if(initialized)
		return world.log << "ERROR: Travel init was called but was already done?"
	currentship()
	for(var/obj/effect/landmark/L in landmarks_list)
		if(L.name = "TravelMark")
			TravelMarker = L
	if(TravelMarker)
		for(var/turf/space/S in trange(currentship.size,TravelMarker)) // Large estimate for now.
			spaceturfs.Add(S)
			CHECK_TICK
		world.log << "TRAVEL: Initialized: Ship: [currentship()]"
		initialized = 1

/datum/travel/proc/currentship()
	if(!currentship)
		var/list/L = typesof(/datum/travel/ships)-/datum/travel/ships
		for(var/T in L)
			var/datum/travel/ships/S = new T
			if(S.active)
				if(!currentship) // Set ship no matter what when this is called.
					currentship = S
				return S
	else
		return currentship
/*
/datum/travel/proc/SetShipIcon(var/turf/space/S)
	if(currentship && currentship.speed > 0)
		var/delay = GetShipSpeed()
		world.log << "delay is [delay]"
		var/icon/NewIcon = new(S.icon)
		NewIcon.Insert(S.icon, S.icon_state, delay= -1)
		S.icon = NewIcon
	else	return 0

/datum/travel/proc/GetShipSpeed()
	if(currentship)
		switch(currentship.speed)
			if(0 to 5) // Not fast enough
				return 0
			if(6 to 25)
				return -0.25
			if(26 to 49)
				return -0.35
			if(50 to 74)
				return -0.50
			if(75 to 99)
				return -0.75
			if(100 to 125)
				return -1
*/
/datum/travel/proc/SetFlyingState(var/update = 0)
	if(travelling) // We are already in flight
//		if(update)
//			for(var/turf/space/transit/north/N in spaceturfs)
//				SetShipIcon(N)
//				CHECK_TICK
//		else
		for(var/turf/space/transit/north/N in spaceturfs)
			var/turf/space/S = new(N)
			spaceturfs -= N
			spaceturfs += S // Deletion of the other should go automated?
			CHECK_TICK
		travelling = 0
	else // We are not in flight?
		for(var/turf/space/S in spaceturfs)
			var/turf/space/transit/north/N = new(S)
			spaceturfs -= S
			spaceturfs += N
			CHECK_TICK
		travelling = 1

/mob/verb/setfly()
	set name = "FLY"
//	travel.currentship.speed = input("Insert speed (0|100)") as num
//	var/update = input("Update speed? (1|0)") as num
	if(!travel.initialized)
		travel.initialize()
	travel.SetFlyingState()