//
//  TCPController.m
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "TCPController.h"
#import <arpa/inet.h>
#import <sys/socket.h>
#import <sys/select.h>
#import <netinet/in.h>
#import <netinet/tcp.h>

@implementation TCPController

- (BOOL) connect {
	[socket set: init_tcp([[delegate ip_addr] UTF8String], [[delegate port] intValue])];
	if ([socket value] == -1) {
		//NSLog(@"Connection failed"); // TODO: convert to alert box
		NSRunAlertPanel(@"Error", [NSString stringWithFormat:
										 @"Connection to '%@:%@' failed.", [delegate ip_addr], [delegate port]
			], @"OK", nil, nil);
		return NO;
	}
	return YES;
}

- (id) initWithDelegate:(id <TCPDelegate>) d {
	self = [super init];
	delegate = d;
	socket = [[AtomicInt alloc] init];
	return self;
}

- (void) recvLoop {
	char buffer[2048];
	memset(buffer, NULL, sizeof(buffer));
	int total = 0;
	while (1) {
		socket_descriptor sock = [socket value];
		if (sock == -1) {
			[delegate setUsername: @"" andIP: @"" andPort: @""];
			NSRunAlertPanel(@"Error", [NSString stringWithFormat:
											 @"Connection failed."
				], @"OK", nil, nil);
			return;
		}
		fd_set read_fds;
		FD_ZERO(&read_fds);
		FD_SET(sock, &read_fds);
		
		int activity = select(sock + 1, &read_fds, NULL, NULL, NULL);
		if (activity < 0) {
			if (![self connect]) {
				return;
			}
			continue;
		}
		if (FD_ISSET(sock, &read_fds)) {
			
			char c;
			int bytes = read(sock, &c, 1);
			if (bytes <= 0) {
				[self connect];
				continue;
			}
			if (total < sizeof(buffer))
				buffer[total++] = c;
			if (c == '\n') {
				buffer[total] = '\0';
				// call function to handle
				NSString * ns_buffer = [NSString stringWithUTF8String: buffer];
				[delegate receive_tcp: ns_buffer];
				total = 0;
			}
		}
	}
}

- (void) send:(NSString *) message {
	while (!send_tcp([message UTF8String], [socket value])) {
		[self connect];
	}
}

- (void) dealloc {
	close_tcp([socket value]);
	[socket release];
	[super dealloc];
}

@end
