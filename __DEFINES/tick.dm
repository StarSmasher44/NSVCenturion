#define TICK_LIMIT_UPPER 98
#define TICK_LIMIT_RUNNING 90
#define TICK_LIMIT_TO_RUN 87

#define MC_TICK_CHECK ( world.tick_usage > TICK_LIMIT_TO_RUN ? 1 : 0 )
#define TICK_USAGE_HIGH ( world.tick_usage > TICK_LIMIT_RUNNING ? 1 : 0)
#define CHECK_TICK if (world.tick_usage > TICK_LIMIT_TO_RUN)  stoplag()

//Key thing that stops lag. Cornerstone of performance in ss13, Just sitting here, in unsorted.dm.
/proc/stoplag()
//	. = 1
	sleep(world.tick_lag)
	if (world.tick_usage > TICK_LIMIT_TO_RUN) //woke up, still not enough tick, sleep for more.
//		. += 2
		sleep(world.tick_lag*2)
		if (world.tick_usage > TICK_LIMIT_TO_RUN) //woke up, STILL not enough tick, sleep for more.
//			. += 4
			sleep(world.tick_lag*4)
			//you might be thinking of adding more steps to this, or making it use a loop and a counter var
			//	not worth it.