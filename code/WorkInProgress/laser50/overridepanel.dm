var/global/list/obj/machinery/keycard_auth/authenticators = list()

/obj/machinery/keycard_auth
	name = "Keycard Authentication Device"
	desc = "This device is used to trigger station functions, which require more than one ID card to authenticate."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	var/list/linkeddoors = list()
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON

/obj/machinery/keycard_auth/New()
	..()
	spawn(10)
		for(var/obj/machinery/door/airlock/A in range(2, src))
			if(get_dir(src, A) in cardinal))
				linkeddoors.Add(A)

/obj/machinery/keycard_auth/attack_ai(mob/user as mob)
	to_chat(user, "The station AI is not to interact with these devices.")
	return

/obj/machinery/keycard_auth/attack_paw(mob/user as mob)
	to_chat(user, "You are too primitive to use this device.")
	return

/obj/machinery/keycard_auth/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return
	var/idseclevel = 0
	if(istype(W,/obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/ID = W
		if(access_security) in ID.access) // Security can only lock temporarily and unlock door(s) they have access to
			idseclevel = 1
		if(access_heads in ID.access) // Heads can lock/unlock doors
			idseclevel = 2
//<A href='?src=\ref[src];triggerevent=Red alert'>Red alert</A>"}
	user.set_machine(src)

	var/dat = "<h1>Door Control Panel</h1>"
	if(security_level > SEC_LEVEL_GREEN || idseclevel = 2) // Above Green otherwise we won't allow it, except on heads.
		dat += {"Please input airlock commands.<br><hr><br>"}
		dat += {"<A href='?src=\ref[src];triggerevent=Red alert'>Engage Lockdown</A>
		<A href='?src=\ref[src];triggerevent=Red alert'>Engage Lockdown</A>"}
		user << browse(dat, "window=keycard_auth;size=500x250")
	else
		dat += {"This device has not detected an elevated security level on-station and is therefore not activated.
		<p>Or you lack permission to use this module.</p>"}
		user << browse(dat, "window=keycard_auth;size=500x250")
	return

/obj/machinery/keycard_auth/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
		icon_state = "auth_off"
	else
		stat |= NOPOWER

/obj/machinery/keycard_auth/Topic(href, href_list)
	if(..())
		return 1
	if(usr.stat || stat & (BROKEN|NOPOWER))
		to_chat(usr, "This device is without power.")
		return
	var/datum/signal/signal = getFromPool(/datum/signal)
	signal.transmission_method = 2 // 2 would be a subspace transmission. -- 2 because fucking radio bullshit fuck that

	if(href_list["triggerevent"])
		event = href_list["triggerevent"]
		screen = 2
	if(href_list["reset"])
		reset()

	updateUsrDialog()
	add_fingerprint(usr)
	return




/obj/machinery/door/airlock/allowed(mob/M)
	if(maint_all_access && src.check_access_list(list(access_maint_tunnels)))
		return 1
	return ..(M)