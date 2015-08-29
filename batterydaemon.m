#include "batterydaemon.h"

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    
    // register signal handling for SIGINT
    signal(SIGINT, catch_SIGINT);

    // setup PID and log file
    setup();

    int notify_token;
    notify_register_dispatch("com.apple.iokit.hid.displayStatus", &notify_token, dispatch_get_main_queue(), ^(int token) {

        uint64_t state = UINT64_MAX;
        notify_get_state(token, &state);


        if((int)state == 1) {
          start();
        } else if((int) state == 0) {
          double kk = stop(startTime);
          log_this(kk); 
        }
        });
    
    infinite *in = [[infinite alloc] init];
    [in waitInfinite];
  }
  return 0;
}

void start()  {

    startTime = mach_absolute_time();
}

double stop() {
    
    uint64_t endTime = mach_absolute_time();
    
    uint64_t elapsedMTU = endTime - startTime;
    
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    return (((double)elapsedMTU * (double)info.numer / (double)info.denom) / 1000000000);
}

void setup() {
  
  // check if a PID file is already present, if not create it
  FILE *check_PID = fopen(STD_PID_PATH, "r");
  if(check_PID != NULL) {
    printf("There is already a running instance of batterydaemon.\nTo stop it, send a SIGINT.\n");
    exit(2);
    fclose(check_PID);
  } else {
    fclose(check_PID);
    pid = fopen(STD_PID_PATH, "w");
    fprintf(pid, "%d\n", getpid());
    fclose(pid);
  }

  // open the log file
  log_file = fopen(STD_CURRENT_LOG_FILE, "a+");

  // setup with the hour/date when the daemon has been started
  fprintf(log_file, "%s: %s\n", "START: batterydaemon session has been started ->", currentDateTime());

  // write the start time
  start();
}

void shut_all_down() {
  // log shutdown hour/date
  fprintf(log_file, "%s %f %s %f %s : %s\n", "STOP: batterydaemon session has been stopped, display has been on for ", display_on_elapsed_time, "seconds, or ", display_on_elapsed_time/60, "minutes ->", currentDateTime());

  // ease reading with \n\n
  fprintf(log_file, "%s", "\n\n");

  // close the log file
  fclose(log_file);
  
  // delete the PID file
  remove(STD_PID_PATH);

  // byebye!
  exit(0);
}

char *currentDateTime() {
  NSDateFormatter *formatter;
  NSString        *dateString;
  formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
  dateString = [formatter stringFromDate:[NSDate date]];
  return [dateString UTF8String];
}

void log_this(float elapsed_seconds) {
  display_on_elapsed_time += elapsed_seconds;
  float elapsed_minutes = elapsed_seconds/60;
  fprintf(log_file, "LOG: been awake for %f seconds, or %f minutes.\n", elapsed_seconds, elapsed_minutes);
}

void catch_SIGINT(int signo) {
  shut_all_down();
}
