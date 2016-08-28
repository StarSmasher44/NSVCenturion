//Mob_List located in global_lists.dm

/datum/controller/process/shipmovement
	schedule_interval = 23 // every 2 seconds

/datum/controller/process/shipmovement/setup()
	name = "shipmovement"

/datum/controller/process/shipmovement/doWork()
	if (travel && travel.travelling)
		travel.SetFlyingState(1) // Updates the overlays manually.
