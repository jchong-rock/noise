//
//  ContactEntry.h
//  Noise
//
//  Created by Jake on 7/26/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ContactEntry : NSObject {
	NSString * _key;
	NSString * _sender;
	NSString * _message;
	BOOL _isRecv;
	
}

- (NSString *) key;
- (NSString *) sender;
- (BOOL) isRecv;
- (NSString *) message;
- (id) initWithSender:(NSString *) sender andKey:(NSString *) key andMessage:(NSString *) msg andIsRecv:(BOOL) isRecv;

@end
