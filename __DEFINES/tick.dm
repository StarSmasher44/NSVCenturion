#define TICK_LIMIT_RUNNING 81
#define TICK_LIMIT_TO_RUN 80
#define TICK_LIMIT_MC 73
#define TICK_LIMIT_MC_INIT 98

#define MC_TICK_CHECK ( world.tick_usage > TICK_LIMIT_TO_RUN ? 1 : 0 )
#define TICK_USAGE_HIGH ( world.tick_usage > TICK_LIMIT_RUNNING ? 1 : 0)
#define CHECK_TICK if (world.tick_usage > TICK_LIMIT_TO_RUN)  stoplag()
