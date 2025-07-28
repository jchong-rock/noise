//
//  RWLock.h
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <pthread.h>

@interface RWLock : NSObject {
    pthread_rwlock_t _rwlock;
}
- (void) lockForReading;
- (void) unlockForReading;
- (void) lockForWriting;
- (void) unlockForWriting;
@end

