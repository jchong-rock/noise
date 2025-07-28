//
//  MessageTextCell.m
//  Noise
//
//  Created by Jake on 7/28/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "MessageTextCell.h"
#import <float.h>

@implementation MessageTextCell

- (id) init {
	self = [super init];
	isRecv = NO;
	return self;
}

- (void) setIsRecv:(BOOL) isIt {
	isRecv = isIt;
}

- (void) drawWithFrame:(NSRect) cellFrame inView:(NSView *) controlView {
	
	NSRect bubbleRect = NSInsetRect(cellFrame, 4, 4);
	NSBezierPath * bubblePath = [self classicRoundedRectInRect:bubbleRect radius:10];
	NSColor * bubbleColor = isRecv ? [NSColor colorWithCalibratedWhite:0.9 alpha:1.0]
								   : [NSColor colorWithCalibratedRed:0.8 green:0.9 blue:1.0 alpha:1.0];
	[bubbleColor set];
	[bubblePath fill];
	NSRect textRect = NSInsetRect(bubbleRect, 8, 6);
	[super drawWithFrame:textRect inView:controlView];
}

- (NSBezierPath *) classicRoundedRectInRect:(NSRect) r radius:(double) radius {
	NSBezierPath * path = [NSBezierPath bezierPath];
	float minX = NSMinX(r), midX = NSMidX(r), maxX = NSMaxX(r);
	float minY = NSMinY(r), midY = NSMidY(r), maxY = NSMaxY(r);
	[path moveToPoint:NSMakePoint(minX, midY)];
	[path appendBezierPathWithArcFromPoint:NSMakePoint(minX, maxY)
								   toPoint:NSMakePoint(midX, maxY)
									radius:radius];
	[path appendBezierPathWithArcFromPoint:NSMakePoint(maxX, maxY)
								   toPoint:NSMakePoint(maxX, midY)
									radius:radius];
	[path appendBezierPathWithArcFromPoint:NSMakePoint(maxX, minY)
								   toPoint:NSMakePoint(midX, minY)
									radius:radius];
	[path appendBezierPathWithArcFromPoint:NSMakePoint(minX, minY)
								   toPoint:NSMakePoint(minX, midY)
									radius:radius];
	[path closePath];
	return path;
}

@end
