#include "infinite.h"

@implementation infinite

- (void) infiniteWhile:(NSTimer *)timer {
  pause();
}

- (void) waitInfinite {
  NSDate *now = [[NSDate alloc] init];
  NSTimer *timer = [[NSTimer alloc] initWithFireDate:now
                                            interval:.01
                                              target: nil
                                            selector:@selector(infiniteWhile:)
                                            userInfo:nil
                                             repeats:NO];

  NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
  [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
  [runLoop run];
}

@end
