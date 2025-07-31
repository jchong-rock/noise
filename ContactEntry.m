//
//  ContactEntry.m
//  Noise
//
//  Created by Jake on 7/26/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "ContactEntry.h"


@implementation ContactEntry

- (id) initWithSender:(NSString *) sender andKey:(NSString *) key andMessage:(NSString *) msg andIsRecv:(BOOL) isRecv {
	self = [super init];
	_key = key;
	_sender = sender;
	_message = msg;
	_isRecv = isRecv;
	return self;
}

- (NSString *) key {
	return _key;
}
- (NSString *) sender {
	return _sender;
}
- (BOOL) isRecv {
	return _isRecv;
}
- (NSString *) message {
	return _message;
}

@end
