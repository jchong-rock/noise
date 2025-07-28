//
//  SettingsViewController.m
//  Noise
//
//  Created by Jake on 7/28/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

- (id) initWithDelegate:(JSON_RPC *) delgt {
	self = [super init];
	delegate = delgt;
	[NSBundle loadNibNamed: @"SettingsUI" owner: self];
	return self;
}

- (void) awakeFromNib {
	[prefsForm addEntry: @"Port"];
	[[prefsForm cellAtIndex:0] setStringValue: [delegate username]];
	[[prefsForm cellAtIndex:1] setStringValue: [delegate ip_addr]];
	[[prefsForm cellAtIndex:2] setStringValue: [delegate port]];
}

- (IBAction) cancelClicked:(id) sender {
	[dialogWindow close];
}

- (void) blockCancel {
	[[dialogWindow standardWindowButton:NSWindowCloseButton] setEnabled: NO];
	[cancelButton setEnabled: NO];
}

- (IBAction) okClicked:(id) sender {
	NSString * field1 = [[prefsForm cellAtIndex:0] stringValue];
    NSString * field2 = [[prefsForm cellAtIndex:1] stringValue];
	NSString * field3 = [[prefsForm cellAtIndex:2] stringValue];
	[delegate setUsername: field1 andIP: field2 andPort: field3];
	id path = [[NSBundle mainBundle] executablePath];
	NSArray * args = [NSArray arrayWithObjects: nil];
	[NSTask launchedTaskWithLaunchPath: path arguments: args];
	[NSApp terminate: self];
}

- (IBAction) showWindow {
	//[NSApp runModalForWindow: dialogWindow];
	
	[dialogWindow makeKeyAndOrderFront: self];
	[NSApp activateIgnoringOtherApps: YES];
	[dialogWindow setLevel:NSStatusWindowLevel];
}

@end
