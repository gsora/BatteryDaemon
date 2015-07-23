#import <Foundation/Foundation.h>
#import <notify.h>
#import <signal.h>
#include <mach/mach_time.h>
#import "infinite.h"

void start();
double stop();

uint64_t startTime;

int main(int argc, const char * argv[]) {
  @autoreleasepool {

    start();

    int notify_token;
    notify_register_dispatch("com.apple.iokit.hid.displayStatus", &notify_token, dispatch_get_main_queue(), ^(int token) {

        uint64_t state = UINT64_MAX;
        notify_get_state(token, &state);


        if((int)state == 1) {
          start();
        } else if((int) state == 0) {
          double kk = stop(startTime);
          NSLog(@"Been awake for %f seconds, or %f minutes", kk, (kk / 60));
        }

        NSLog(@"com.apple.iodkit.hid.displayStatus = %llu", state);
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

void gotCTRLC(int signal) {
  exit(0);
}
