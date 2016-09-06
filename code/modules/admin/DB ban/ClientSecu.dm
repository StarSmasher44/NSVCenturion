// This is ClientSecu, my own attempt at adding another layer of security
// to the game, if all goes right this should rid us of multi-keying and ban-evading.
// Remember WIP; If I find another method that works better, I will use it.
var/global/savefile/SHash = new("data/hashcheck.sav")

/client
	var/savefile/CHash

/client/New()
	..()
	spawn(50) // Make sure all is loaded
		if(CHash = Import(CHash))
			world.log << "CHASH = [CHash]"
			CheckFile()
		else
			MakeCHash()
			CheckFile()

/client/proc/MakeCHash()
	if(src)
		var/savefile/CHash = new()
		var/clienthash = md5("[ckey]/[computer_id]/[address]")
		CHash["[ckey]"] << clienthash
		CHash["[ckey]+CID"] << computer_id
		CHash["[ckey]+IP"] << address
		sleep(-1) // Make sure everything's done for.
		Export(CHash) // Send it over to the client, thats it.
		// Add Player to server list.
		SHash["[ckey]"] << clienthash
		SHash["[ckey]+CID"] << computer_id
		SHash["[ckey]+IP"] << address
		sleep(-1)
		CheckFile() // Check for validity

/client/proc/CheckFile()
	if(src && CHash)
		var/clienthash
		var/serverhash
		var/oldcid
		var/oldip
		CHash["[ckey]"] >> clienthash // Client's Code

		SHash["[ckey]"] >> serverhash // Server's Code
		SHash["[ckey]+CID"] >> oldcid
		SHash["[ckey]+IP"] >> oldip
		if(clienthash != serverhash || !CHash["[ckey]"] != ckey || !CHash["[ckey]+CID"] != computer_id || !CHash["[ckey]+IP"] != address) // Mismatch, display admins all the shit
			message_admins("<font color='red'>Hash Mismatch! (Bad Hash Compare)</font>",1)
			message_admins("<font color='red'>Registered: C: [ckey], ID: [oldcid], IP: [oldip]</font>",1)
			message_admins("<font color='red'>New/Current: C: [ckey], ID: [computer_id], IP: [address]</font>",1)
		src.MakeCHash() // Update info again, hope admins saw it.