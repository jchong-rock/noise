//
//  json-rpc.h
//  Noise
//
//  Created by Jake on 7/24/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TCPController.h"
#import "TCPDelegate.h"
#import "JSONParser.h"
#import "JSONDelegate.h"
#import "AtomicInt.h"

#define PhoneNumber NSString

@interface JSON_RPC : NSObject<TCPDelegate> {
	PhoneNumber * pnum;
	TCPController * controller;
	JSONParser * parser;
	NSMutableDictionary * contacts;
	NSArray * phoneNumbers;
	NSLock * recvLocks;
	AtomicInt * timestampCounter;
	id <JSONDelegate> delegate;
}

- (void) send:(NSString *) message toRecipient:(PhoneNumber *) rcpt;
- (void) recvMessage:(NSString *) message fromSender:(PhoneNumber *) sndr;
- (void) addContact:(NSString *) name forNumber:(PhoneNumber *) number;
- (int) numContacts;
- (NSString *) contactAtIndex:(int) idx;
- (PhoneNumber *) phoneNumberAtIndex:(int) idx;
- (void) deleteContact:(int) idx;
- (void) refreshContacts;
- (NSLock *) recvLock;
- (BOOL) initialised;
- (void) setDelegate:(id <JSONDelegate>) deleg;
- (void) deleteMessageWithRecipient:(PhoneNumber *) rcpt andTimestamp:(NSString *) times;
- (void) deleteMessageWithSender:(PhoneNumber *) sndr andTimestamp:(NSString *) stamp;
- (void) renameContact:(NSString *) name forNumber:(PhoneNumber *) number;
- (NSString *) contactForNumber:(PhoneNumber *) num;

@end
