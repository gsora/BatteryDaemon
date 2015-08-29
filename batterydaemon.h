#include <signal.h>
#include <string.h>
#include <unistd.h>
#include <mach/mach_time.h>
#include "infinite.h"
#import <Foundation/Foundation.h>
#import <notify.h>

#define STD_PID_PATH "/var/mobile/.batterydaemon.pid"
#define STD_CURRENT_LOG_FILE "/var/mobile/batterydaemon.current.log"

// start() data structure
uint64_t startTime;
// PID file
FILE *pid;
// log file
FILE *log_file;
// session's "display on" seconds
float display_on_elapsed_time;

// start a timer
void start();
// stop a timer and return elapsed seconds
double stop();
// setup PID and log files
void setup();
// shut all down, write back to files
void shut_all_down();
// log something
void log_this(float elapsed_time);
// get current date and time, already formatted
char *currentDateTime();
// handle SIGINT 
void catch_SIGINT(int signo);
