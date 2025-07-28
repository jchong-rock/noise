//
//  AtomicInt.m
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "AtomicInt.h"

@implementation AtomicInt

- (id) init {
	self = [super init];
	_value = 0;
	pthread_mutex_init(& _lock, NULL);
	return self;
}

- (long) value {
	pthread_mutex_lock(& _lock);
	int v = _value;
	pthread_mutex_unlock(& _lock);
	return v;
}

- (void) set:(long) val {
	pthread_mutex_lock(& _lock);
	_value = val;
	pthread_mutex_unlock(& _lock);
}

- (long) getAndInc {
	pthread_mutex_lock(& _lock);
	int v = _value++;
	pthread_mutex_unlock(& _lock);
	return v;
}


@end
