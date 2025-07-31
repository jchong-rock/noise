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
	NSMutableDictionary * groups;
	NSArray * phoneNumbers;
	NSArray * groupNumbers;
	NSLock * recvLocks;
	AtomicInt * timestampCounter;
	id <JSONDelegate> delegate;
}

- (void) send:(NSString *) message toRecipient:(PhoneNumber *) rcpt;
- (void) send:(NSString *) message toGroup:(NSString *) rcpt;
- (void) recvMessage:(NSString *) message fromSender:(PhoneNumber *) sndr withGroupInfo:(NSDictionary *) groupInfo;
- (void) addContact:(NSString *) name forNumber:(PhoneNumber *) number;
- (void) addGroup:(NSString *) name forNumber:(NSString *) number;
- (int) numContacts;
- (int) numGroups;
- (NSString *) contactAtIndex:(int) idx;
- (NSString *) groupAtIndex:(int) idx;
- (PhoneNumber *) phoneNumberAtIndex:(int) idx;
- (NSString *) groupNumberAtIndex:(int) idx;
- (void) deleteContact:(int) idx;
- (void) refreshContacts;
- (void) refreshGroups;
- (NSLock *) recvLock;
- (BOOL) initialised;
- (void) setDelegate:(id <JSONDelegate>) deleg;
- (void) deleteMessageWithRecipient:(PhoneNumber *) rcpt andTimestamp:(NSString *) times;
- (void) deleteMessageWithSender:(PhoneNumber *) sndr andTimestamp:(NSString *) stamp;
- (void) renameContact:(NSString *) name forNumber:(PhoneNumber *) number;
- (NSString *) contactForNumber:(PhoneNumber *) num;

@end
