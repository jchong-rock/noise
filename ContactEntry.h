//
//  ContactEntry.h
//  Noise
//
//  Created by Jake on 7/26/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ContactEntry : NSObject {
	NSString * _name;
	NSString * _phone_number;
}

- (NSString *) name;

- (NSString *) phoneNumber;

- (void) setName:(NSString *) name;

- (void) setPhoneNumber:(NSString *) phoneNumber;

@end
