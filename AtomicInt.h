//
//  AtomicInt.h
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <pthread.h>

@interface AtomicInt : NSObject {
	long _value;
	pthread_mutex_t _lock;
}

- (long) value;
- (void) set:(long) val;
- (long) getAndInc;

@end
