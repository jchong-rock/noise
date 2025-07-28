//
//  BigBoxDelegate.h
//  Noise
//
//  Created by Jake on 7/27/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

struct strBool {
	NSString * str;
	BOOL bl;
};

@interface BigBoxDelegate : NSObject {
	NSDictionary * froms;
	NSDictionary * tos;
	NSArray * sortedKeys;
}

- (void) setFroms:(NSDictionary *) frm andTos:(NSDictionary *) tss;
- (struct strBool *) keyAtRow:(int) row;

@end
