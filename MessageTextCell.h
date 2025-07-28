//
//  MessageTextCell.h
//  Noise
//
//  Created by Jake on 7/28/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MessageTextCell : NSTextFieldCell {
	BOOL isRecv;
}

- (NSBezierPath *) classicRoundedRectInRect:(NSRect) r radius:(double) radius;
- (void) setIsRecv:(BOOL) isIt;

@end
