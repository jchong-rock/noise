/*
 *  TCPDelegate.h
 *  Noise
 *
 *  Created by Jake on 7/25/25.
 *  Copyright 2025 __MyCompanyName__. All rights reserved.
 *
 */

#import <Cocoa/Cocoa.h>

@protocol TCPDelegate

- (void) receive_tcp:(NSString *) buffer;
- (NSString *) ip_addr;
- (NSString *) port;
- (NSString *) username;
- (void) setUsername:(NSString *) user andIP:(NSString *) ip andPort:(NSString *) port;

@end
