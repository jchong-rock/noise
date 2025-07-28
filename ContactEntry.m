//
//  ContactEntry.m
//  Noise
//
//  Created by Jake on 7/26/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "ContactEntry.h"


@implementation ContactEntry

- (id) initWithName:(NSString *) name andPhoneNumber:(NSString *) phoneNumber {
	self = [super init];
	_name = name;
	_phone_number = phoneNumber;
	return self;
}

- (NSString *) name {
	return _name;
}

- (NSString *) phoneNumber {
	return _phone_number;
}

- (void) setName:(NSString *) name {
	_name = name;
}

- (void) setPhoneNumber:(NSString *) phoneNumber {
	_phone_number = phoneNumber;
}

@end
