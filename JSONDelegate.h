/*
 *  JSONDelegate.h
 *  Noise
 *
 *  Created by Jake on 7/28/25.
 *  Copyright 2025 __MyCompanyName__. All rights reserved.
 *
 */

#include <Cocoa/Cocoa.h>

@protocol JSONDelegate

- (void) receiveJSON;
- (void) reloadContacts;

@end