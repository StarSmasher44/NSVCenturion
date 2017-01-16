/obj/machinery/computer/helm
	name = "helm control console"
	var/id = 1001 // Used to locate ship for overmap
	var/obj/overmap/ship/linked
	var/turf/space/destination
	var/dx // Destination coodinates
	var/dy
	var/list/known_sectors = list()


/obj/machinery/computer/helm/initialize()


/obj/machinery/computer/helm/process()
	..()
	return


/obj/machinery/computer/helm/check_eye(var/mob/user as mob)
	if (!get_dist(user, src) > 1 || user.blinded || !linked )
		return -1
	return 0


/obj/machinery/computer/helm/attack_hand(var/mob/user as mob)
	if(..())
		user.unset_machine()
//		manual_control = 0
		return

	if(!isAI(user))
		user.set_machine(src)
		if(linked)
			user.reset_view(linked)

	ui_interact(user)
	user.verbs += /turf/space/verb/MoveShipTo()
/*
/obj/machinery/computer/helm/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		return

	var/data[0]
//	data["state2"] = state2

	data["sector"] = "Deep Space"
	data["s_x"] = linked.x
	data["s_y"] = linked.y
	data["dest"] = destination
	data["d_x"] = dx
	data["d_y"] = dy
	data["speed"] = linked.GetSpeed()
//	data["accel"] = round(linked.GetSpeed())
//	data["heading"] = dir2angle(linked.get_heading())

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "helm.tmpl", "[linked.name] Helm Control", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

///mob/Stat()
//	..()
//	if(client && client.inactivity < (1200))
//		if (statpanel("Helm Status"))
//			stat(null, "Location:\t([linked.x], [linked.y])")
//			stat(null, "Engine Power:\t [GetSpeed()])")
//			stat(null, "Engine temperature:\t")
//			if(destination)
//				stat(null, "Destination:\t[dx], [dy]")
*/
/turf/space/proc/MoveShipTo()
	set name = "Navigate To"
	set desc = "Orders the Ship's AI to move to the selected destination."
	set category = "Ship"

	if(src.z == OVERMAP_ZLEVEL) // Make sure it's the overmap.
		if(isturf(src))
			linked.targetLoc == src

/*
/obj/machinery/computer/helm/Topic(href, href_list)
	if(..())
		return 1

	if (!linked)
		return

	if (href_list["add"])
		var/datum/data/record/R = new()
		var/sec_name = input("Input naviation entry name", "New navigation entry", "Sector #[known_sectors.len]") as text
		if(!sec_name)
			sec_name = "Sector #[known_sectors.len]"
		R.fields["name"] = sec_name
		switch(href_list["add"])
			if("current")
				R.fields["x"] = linked.x
				R.fields["y"] = linked.y
			if("new")
				var/newx = input("Input new entry x coordinate", "Coordinate input", linked.x) as num
				R.fields["x"] = Clamp(newx, 1, world.maxx)
				var/newy = input("Input new entry y coordinate", "Coordinate input", linked.y) as num
				R.fields["y"] = Clamp(newy, 1, world.maxy)
		known_sectors += R

//	if (href_list["remove"])
//		var/datum/data/record/R = locate(href_list["remove"])
//		known_sectors.Remove(R)

	if (href_list["setx"])
		var/newx = input("Input new destiniation x coordinate", "Coordinate input", dx) as num|null
		if (newx)
			dx = Clamp(newx, 1, world.maxx)

	if (href_list["sety"])
		var/newy = input("Input new destiniation y coordinate", "Coordinate input", dy) as num|null
		if (newy)
			dy = Clamp(newy, 1, world.maxy)

	if (href_list["x"] && href_list["y"])
		dx = text2num(href_list["x"])
		dy = text2num(href_list["y"])

	if (href_list["reset"])
		dx = 0
		dy = 0

	if (href_list["move"])
		var/ndir = text2num(href_list["move"])
		linked.relaymove(usr, ndir)

//	if (href_list["brake"])
//		linked.decelerate()

//	if (href_list["state2"])
//		state2 = href_list["state2"]
	add_fingerprint(usr)
	updateUsrDialog()
*/
