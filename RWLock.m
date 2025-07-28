//
//  RWLock.m
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "RWLock.h"


@implementation RWLock

- (id) init {
    if ((self = [super init])) {
        pthread_rwlock_init(& _rwlock, NULL);
    }
    return self;
}

- (void) lockForReading {
    pthread_rwlock_rdlock(& _rwlock);
}

- (void) unlockForReading {
    pthread_rwlock_unlock(& _rwlock);
}

- (void) lockForWriting {
	int success = pthread_rwlock_trywrlock(& _rwlock);
	if (success == EBUSY) {
		success = pthread_rwlock_wrlock(& _rwlock);
	}
	if (success == EDEADLK) {
		pthread_rwlock_unlock(& _rwlock);
		[self lockForWriting];
	}
}

- (void) unlockForWriting {
    pthread_rwlock_unlock(& _rwlock);
}

- (void) dealloc {
    pthread_rwlock_destroy(& _rwlock);
    [super dealloc];
}

@end

