//
//  json-rpc.m
//  Noise
//
//  Created by Jake on 7/24/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "json-rpc.h"
#import "JSONParser.h"
#import "MainViewController.h"

#define NSApplicationSupportDirectory 14

@implementation JSON_RPC

- (id) init {
	self = [super init];
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	pnum = [defaults stringForKey: @"user"];
	if (!pnum) {
		// open popup
		return self;
	}
	timestampCounter = [[AtomicInt alloc] init];
	NSNumber * val = [defaults valueForKey: @"stmp"];
	if (val) {
		[timestampCounter set: 1 + [val longValue]];
	}
	controller = [[TCPController alloc] initWithDelegate: self];
	if (![controller connect]) {
		return self;
	}
	parser = [[JSONParser alloc] init];
	[self refreshContacts];
	[NSThread detachNewThreadSelector: @selector(recvLoop)
							 toTarget: controller
						   withObject: nil];
	return self;
}

- (BOOL) initialised {
	return (pnum != nil);
}

- (NSString *) ip_addr {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSString * val = [defaults stringForKey: @"ip"];
	if (val)
		return val;
	return @"";
}
- (NSString *) port {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSString * val = [defaults stringForKey: @"port"];
	if (val)
		return val;
	return @"";
}
- (NSString *) username {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSString * val = [defaults stringForKey: @"user"];
	if (val)
		return val;
	return @"";
}
- (void) setUsername:(NSString *) user andIP:(NSString *) ip andPort:(NSString *) port {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: user forKey:@"user"];
	[defaults setObject: port forKey:@"port"];
	[defaults setObject: ip forKey:@"ip"];
}

- (void) receive_tcp:(NSString *) buffer {
	NSDictionary * parsed = [parser parseJSON: buffer];
	//NSLog(@"gopt: %@", buffer);
	NSString * method = [parsed objectForKey: @"method"];
	if ([method isEqualToString: @"receive"]) {
		NSDictionary * payload = [[parsed objectForKey: @"params"] objectForKey: @"envelope"];
		//NSLog(@"got: %@", payload);
		if ([payload objectForKey: @"dataMessage"] != nil) {
			// TODO: add attachments
			NSString * message = [[payload objectForKey: @"dataMessage"] objectForKey: @"message"];
			if (message) {
				[self recvMessage: message
					   fromSender: [payload objectForKey: @"source"]
				];
			}
		}
	}
}

- (NSString *) phoneNumberAtIndex:(int) idx {
	return [phoneNumbers objectAtIndex: idx];
}

- (void) recvMessage:(NSString *) message fromSender:(PhoneNumber *) sndr {
	
	if (![contacts objectForKey: sndr]) {
		[self addContact: sndr forNumber: sndr];
		[delegate reloadContacts];
	}
	
	
	/*if (![contacts objectForKey: sndr]) {
		return;
	}*/
	
	[recvLocks lock];
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSString * phonekey = [NSString stringWithFormat: @"r%@", sndr];
	NSMutableDictionary * messages = [[defaults dictionaryForKey: phonekey] mutableCopy];
	long times = [timestampCounter getAndInc];
	[defaults setObject: [NSNumber numberWithLong: times] forKey: @"stmp"];
	NSString * stamp = [NSString stringWithFormat: @"%ld", times];
	if (!messages) {
		messages = [[NSMutableDictionary alloc] init];
	}
	if (!message) {
		message = @"This message could not be received.";
	}
	[messages setObject: message forKey: stamp];
	if ([messages count] > 100) {
		NSArray * kys = [messages allKeys];
		NSMutableArray * numArray = [NSMutableArray arrayWithCapacity:[kys count]];
		int i;
		for (i = 0; i < [kys count]; i++) {
			NSString * sss = [kys objectAtIndex: i];
			NSScanner * scb = [NSScanner scannerWithString: sss];
			long long va;
			[scb scanLongLong: &va];
			NSNumber * nnn = [NSNumber numberWithLongLong: va];
			[numArray addObject: nnn];
		}
		NSArray * sortedKeys = [numArray sortedArrayUsingSelector: @selector(compare:)];
		id smallestKey = [sortedKeys objectAtIndex: 0];
		[messages removeObjectForKey: smallestKey];
	}
	[defaults setObject: messages forKey: phonekey];
	[defaults synchronize];
	[messages release];
	[recvLocks unlock];
	if (delegate) {
		[delegate receiveJSON];
	}
}

- (void) deleteMessageWithSender:(NSString *) sndr andTimestamp:(NSString *) stamp {	
	[recvLocks lock];
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSString * phonekey = [NSString stringWithFormat: @"r%@", sndr];
	NSMutableDictionary * messages = [[defaults dictionaryForKey: phonekey] mutableCopy];
	
	[messages removeObjectForKey: stamp];

	[defaults setObject: messages forKey: phonekey];
	[defaults synchronize];
	[messages release];
	[recvLocks unlock];
}

- (void) deleteMessageWithRecipient:(NSString *) rcpt andTimestamp:(NSString *) times {	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSString * phonekey = [NSString stringWithFormat: @"s%@", rcpt];
	NSMutableDictionary * messages = [[defaults dictionaryForKey: phonekey] mutableCopy];

	[messages removeObjectForKey: times];
	[defaults setObject: messages forKey: phonekey];
	[defaults synchronize];
	[messages release];
	
}

- (void) setDelegate:(id <JSONDelegate>) deleg {
	delegate = deleg;
}

- (void) send:(NSString *) message toRecipient:(PhoneNumber *) rcpt {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	long times = [timestampCounter getAndInc];
	[defaults setObject: [NSNumber numberWithLong: times] forKey: @"stmp"];
	NSString * stamp = [NSString stringWithFormat: @"%ld", times];
	NSString * payload = [[NSString alloc] initWithFormat:
		@"{\"jsonrpc\":\"2.0\",\"method\":\"send\",\"params\":{\"recipient\":[\"%@\"],\"message\":\"%@\"},\"id\":%@}",
		rcpt, JSONStringEscape(message), stamp];
	[controller send: payload];
	[payload release];
	
	NSString * phonekey = [NSString stringWithFormat: @"s%@", rcpt];
	NSMutableDictionary * messages = [[defaults dictionaryForKey: phonekey] mutableCopy];
	
	if (!messages) {
		messages = [[NSMutableDictionary alloc] init];
	}

	[messages setObject: message forKey: stamp];
	if ([messages count] > 100) {
		NSArray * kys = [messages allKeys];
		NSMutableArray * numArray = [NSMutableArray arrayWithCapacity:[kys count]];
		int i;
		for (i = 0; i < [kys count]; i++) {
			NSString * sss = [kys objectAtIndex: i];
			NSScanner * scb = [NSScanner scannerWithString: sss];
			long long va;
			[scb scanLongLong: &va];
			NSNumber * nnn = [NSNumber numberWithLongLong: va];
			[numArray addObject: nnn];
		}
		NSArray * sortedKeys = [numArray sortedArrayUsingSelector: @selector(compare:)];
		id smallestKey = [sortedKeys objectAtIndex: 0];
		[messages removeObjectForKey: smallestKey];
	}
	[defaults setObject: messages forKey: phonekey];
	[defaults synchronize];
	[messages release];
}

- (void) addContact:(NSString *) name forNumber:(NSString *) number {
	NSString * exist = [contacts objectForKey: number];
	if (exist != nil) {
		NSRunAlertPanel(@"Contact Exists", [NSString stringWithFormat:
										 @"Contact '%@' already exists for number %@.", exist, number
			], @"OK", nil, nil);
		return;
	}
	[contacts setObject: name forKey: number];
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: contacts forKey: @"adr"];
	[defaults setObject: [NSDictionary dictionary] forKey:[NSString stringWithFormat: @"s%@", number]];
	[defaults setObject: [NSDictionary dictionary] forKey:[NSString stringWithFormat: @"r%@", number]];
	[defaults synchronize];
	[phoneNumbers release];
	phoneNumbers = [[contacts allKeys] sortedArrayUsingSelector: @selector(compare:)];
	[phoneNumbers retain];
}

- (void) renameContact:(NSString *) name forNumber:(NSString *) number {
	[contacts setObject: name forKey: number];
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject: contacts forKey: @"adr"];
	[defaults synchronize];
	if (delegate) {
		[delegate receiveJSON];
	}
}

- (int) numContacts {
	return [phoneNumbers count];
}
- (NSString *) contactAtIndex:(int) idx {
	return [contacts objectForKey: [phoneNumbers objectAtIndex: idx]];
}
- (void) deleteContact:(int) idx {
	if (idx != -1) {
		NSString * selectedPhoneNumber = [phoneNumbers objectAtIndex: idx];
		[contacts removeObjectForKey: selectedPhoneNumber];
		NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject: contacts forKey: @"adr"];
		[defaults removeObjectForKey:[NSString stringWithFormat: @"s%@", selectedPhoneNumber]];
		[defaults removeObjectForKey:[NSString stringWithFormat: @"r%@", selectedPhoneNumber]];
		[defaults synchronize];
		[phoneNumbers release];
		phoneNumbers = [[contacts allKeys] sortedArrayUsingSelector: @selector(compare:)];
		[phoneNumbers retain];
	}
}

- (void) refreshContacts {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	contacts = [[defaults dictionaryForKey: @"adr"] mutableCopy];
	if (contacts == nil) {
		contacts = [NSMutableDictionary dictionary]; // string -> string
		[defaults setObject: contacts forKey: @"adr"];
		[defaults synchronize];
	}
	[phoneNumbers release];
	phoneNumbers = [[contacts allKeys] sortedArrayUsingSelector: @selector(compare:)];
	[phoneNumbers retain];
	[contacts retain];
}

- (NSLock *) recvLock {
	return recvLocks;
}

- (NSString *) contactForNumber:(PhoneNumber *) num {
	return [contacts objectForKey: num];
}

- (void) dealloc {
	[pnum release];
	[timestampCounter release];
	[contacts release];
	[phoneNumbers release];
	[controller release];
	[parser release];
	[super dealloc];
}

@end

