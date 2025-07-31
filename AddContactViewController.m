//
//  AddContactViewController.m
//  Noise
//
//  Created by Jake on 7/26/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "AddContactViewController.h"

@implementation AddContactViewController

- (id) initWithDelegate:(JSON_RPC *) delgt {
	self = [super init];
	if (self) {
		[NSBundle loadNibNamed: @"AddContact" owner: self];
		delegate = [delgt retain];
	}
	return self;
}

- (void) awakeFromNib {
	[addButton setEnabled: NO];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(formChanged:)
																name:NSControlTextDidChangeNotification
																object:contactForm];
}

- (void) formChanged:(NSNotification *) note {
    NSString * field1 = [[contactForm cellAtIndex:0] stringValue];
    NSString * field2 = [[contactForm cellAtIndex:1] stringValue];
	
    BOOL filled = ([field1 length] > 0 && [field2 length] > 0);
    [addButton setEnabled: filled];
}

- (IBAction) cancelClicked:(id) sender {
	//NSLog(@"cancel, %@", dialogWindow);
	[dialogWindow close];
}
- (IBAction) addClicked:(id) sender {
	NSString * field1 = [[contactForm cellAtIndex:0] stringValue];
    NSString * field2 = [[contactForm cellAtIndex:1] stringValue];
	[delegate addContact: field1 forNumber: field2];
	[[contactForm cellAtIndex:0] setStringValue: @""];
	[[contactForm cellAtIndex:1] setStringValue: @""];
	[contactTable reloadData];
	[dialogWindow close];
}
- (IBAction) showWindow:(NSTableView *) tblv {
	[dialogWindow makeKeyAndOrderFront: nil];
	[NSApp activateIgnoringOtherApps: YES];
	contactTable = tblv;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver: self];
	[delegate release];
	[super dealloc];
}

@end
