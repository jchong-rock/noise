//
//  RenameViewController.m
//  Noise
//
//  Created by Jake on 7/30/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "RenameViewController.h"


@implementation RenameViewController

- (id) initWithDelegate:(JSON_RPC *) delgt {
	self = [super init];
	[NSBundle loadNibNamed: @"AddContact" owner: self];
	delegate = delgt;
	return self;
}

- (void) awakeFromNib {
	[addButton setTitle: @"Rename"];
	[addButton setEnabled: YES];
	[dialogWindow setTitle: @"Rename Contact"];
}

- (IBAction) cancelClicked:(id) sender {
	//NSLog(@"cancel, %@", dialogWindow);
	[dialogWindow close];
}
- (IBAction) addClicked:(id) sender {
	NSString * field1 = [[contactForm cellAtIndex:0] stringValue];
    NSString * field2 = [[contactForm cellAtIndex:1] stringValue];
	[delegate renameContact: field1 forNumber: field2];
	//[contactTable deselectAll: self];
	[contactTable reloadData];
	[dialogWindow close];
}
- (IBAction) showWindow:(NSTableView *) tblv {
	[[contactForm cellAtIndex:1] setEditable: NO];
	NSString * name = [delegate contactAtIndex:[tblv selectedRow]];
	NSString * num = [delegate phoneNumberAtIndex:[tblv selectedRow]];
	[[contactForm cellAtIndex:0] setStringValue: name];
	[[contactForm cellAtIndex:1] setStringValue: num];
	[dialogWindow makeKeyAndOrderFront: nil];
	[NSApp activateIgnoringOtherApps: YES];
	contactTable = tblv;
}


@end
