//
//  TCPController.h
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "tcp.h"
#import "AtomicInt.h"
#import "TCPDelegate.h"

@interface TCPController : NSObject {
	id <TCPDelegate> delegate;
	AtomicInt * socket;
}

- (void) send:(NSString *) message;
- (id) initWithDelegate:(id <TCPDelegate>) d;
- (void) recvLoop;
- (BOOL) connect;

@end
