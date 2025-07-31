//
//  BigBoxDelegate.h
//  Noise
//
//  Created by Jake on 7/27/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ContactEntry.h"

@interface BigBoxDelegate : NSObject {
	NSDictionary * messages;
	NSArray * sortedKeys;
	NSLock * bigboxLock;
}

- (void) setFromsGroup:(NSDictionary *) frm andTos:(NSDictionary *) tss;
- (void) setFroms:(NSDictionary *) frm andTos:(NSDictionary *) tss;
- (ContactEntry *) keyAtRow:(int) row;
- (void) keySort:(NSArray *) unsorted;

@end
