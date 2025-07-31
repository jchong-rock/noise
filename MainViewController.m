//
//  MainViewController.m
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "MessageTextCell.h"

#define NSApplicationSupportDirectory 14

@implementation MainViewController

- (id) init {
	self = [super init];
	json_controller = [[JSON_RPC alloc] init];
	contactTable = [[NSTableView alloc] init];
	groupsTable = [[NSTableView alloc] init];
	groups = NO;
	bigbox = [[NSTableView alloc] init];
	[contactTable setDelegate: self];
	[groupsTable setDelegate: self];
	[json_controller setDelegate: self];
	return self;
}

- (void) reloadContacts {
	[contactTable reloadData];
}

- (void) reloadGroups {
	[groupsTable reloadData];
}

- (void) setBigBoxTitle:(NSString *) title {
	NSTableColumn * col = [bigbox tableColumnWithIdentifier: @"onlycol"];
	[[col headerCell] setStringValue: title];
	[bigbox reloadData];
}

- (IBAction) sendButtonClicked:(id) sender {
	//NSLog(@"clicked send");
	//NSLog(@"%@", [msg_input stringValue]);
	//NSLog(@"group %d", groups);
	NSString * message = [msg_input stringValue];
	if (message != nil && [message length] > 0) {
		if (groups) {
			[json_controller send: message toGroup: current_phone];
		} else {
			[json_controller send: message toRecipient: current_phone];
		}
	}
	[msg_input setStringValue: @""];
	[self reloadMsgs];
	
}

- (void) awakeFromNib {
	if (![json_controller initialised]) {
		settingsPopup = [[SettingsViewController alloc] initWithDelegate: json_controller];
		[settingsPopup blockCancel];
		[settingsPopup showWindow];
	} else {
		[mainWindow makeKeyAndOrderFront: self];
	}
	
	MessageTextCell * m = [[MessageTextCell alloc] init];
	NSTableColumn * col = [bigbox tableColumnWithIdentifier: @"onlycol"];
	[m setWraps: YES];
	[col setDataCell: m];
	[m release];
	
	[bigbox setTarget: self];
	[bigbox setDoubleAction:@selector(deleteMessage:)];
}

- (void) deleteMessage:(id) sender {
	int row = [bigbox clickedRow];
	ContactEntry * entry = [bbd keyAtRow: row];
	if ([entry isRecv]) {
		[json_controller deleteMessageWithRecipient: current_phone andTimestamp: [entry key]];
	}
	else {
		[json_controller deleteMessageWithSender: current_phone andTimestamp: [entry key]];
	}
	[self reloadMsgs];
}

- (void) reloadMsgs {
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSString * sendkey = [NSString stringWithFormat: @"s%@", current_phone];
	NSDictionary * sendMsgs = [defaults dictionaryForKey: sendkey];
	NSString * recvkey = [NSString stringWithFormat: @"r%@", current_phone];
	[[json_controller recvLock] lock];
	NSDictionary * recvMsgs = [defaults dictionaryForKey: recvkey];
	[[json_controller recvLock] unlock];
	if (!bbd) {
		bbd = [bigbox delegate];
	}
	//NSLog(@"messages to %@: %@", current_phone, sendMsgs);
	//NSLog(@"messages from %@: %@", current_phone, recvMsgs);
	if (groups) {
		[bbd setFromsGroup: recvMsgs andTos: sendMsgs];
	} else {
		[bbd setFroms: recvMsgs andTos: sendMsgs];
	}
	//NSLog(@"bigbox del : %@", [bigbox delegate]);
	[bigbox reloadData];
	int lastRow = (int)[bigbox numberOfRows] - 1;
	if (lastRow >= 0) {
		[bigbox scrollRowToVisible: lastRow];
	}
}

- (IBAction) deleteButtonClicked:(id) sender {
	//NSLog(@"clicked delete");
	[bbd setFroms: nil andTos: nil];
	int selectedRow = [contactTable selectedRow];
	if (selectedRow == -1) {
		selectedRow = [groupsTable selectedRow];
		//[json_controller deleteGroup: selectedRow];
	} else {
		[json_controller deleteContact: selectedRow];
	}
	[groupsTable deselectAll: self];
	[groupsTable reloadData];
	[contactTable deselectAll: self];
	[contactTable reloadData];
}

- (IBAction) newButtonClicked:(id) sender {
	if ([[(NSButton *) sender title] isEqualToString: @"Rename"]) {
		if (!renameContactPopup) {
			renameContactPopup = [[RenameViewController alloc] initWithDelegate: json_controller];
		}
		[renameContactPopup showWindow: contactTable];
		[bigbox reloadData];
		return;
	}
	// dialog
	if (!addContactPopup) {
		addContactPopup = [[AddContactViewController alloc] initWithDelegate: json_controller];
	}
	[bbd setFroms: nil andTos: nil];
	[contactTable deselectAll: self];
	[addContactPopup showWindow: contactTable];
}

- (IBAction) renameButtonClicked:(id) sender { // now settings
	//NSLog(@"clicked settings");
	if (!settingsPopup) {
		settingsPopup = [[SettingsViewController alloc] initWithDelegate: json_controller];
	}
	[settingsPopup showWindow];
}

- (void) dealloc {
	[bigbox release];
	[bbd release];
	[contactTable release];
	[groupsTable release];
	[send_button release];
	[new_button release];
	[rename_button release];
	[delete_button release];
	[msg_input release];
	[json_controller release];
	[super dealloc];
}

- (void) tableViewSelectionDidChange:(NSNotification *) notification {
	NSTableView * tv = [notification object];
	groups = (tv == groupsTable);
	int selectedRow = [tv selectedRow];
	if (selectedRow != -1) {
		NSString * cntc = groups ? [json_controller groupAtIndex: selectedRow] : 
									[json_controller contactAtIndex: selectedRow];
		current_phone = groups ? [json_controller groupNumberAtIndex: selectedRow]:
									[json_controller phoneNumberAtIndex: selectedRow];
		[self setBigBoxTitle: [NSString stringWithFormat: @"%@ (%@)", cntc, current_phone]];
		
		if (groups) {
			[contactTable deselectAll: self];
			[new_button setEnabled: NO];
			[delete_button setEnabled: NO];
		} else {
			[groupsTable deselectAll: self];
			[new_button setEnabled: YES];
			[delete_button setEnabled: YES];
			[new_button setTitle: @"Rename"];
		}
		[send_button setEnabled: YES];
		[self reloadMsgs];
		// load messages into frame
	}
	else {
		groups = !groups;
		[new_button setEnabled: YES];
		[self setBigBoxTitle: @"Noise"];
		[send_button setEnabled: NO];
		[new_button setTitle: @"Add"];
		[delete_button setEnabled: NO];
		[bbd setFroms: nil andTos: nil];
		[bigbox reloadData];
	}
}

- (void) windowWillClose:(NSNotification *) noti {
	[NSApp terminate: self];
}

- (void) reloadTitle {
	[self setBigBoxTitle: [NSString stringWithFormat: @"%@ (%@)",
		[json_controller contactForNumber: current_phone], current_phone
		]];
}

- (void) receiveJSON {
	[self reloadMsgs];
}

- (int) numberOfRowsInTableView:(NSTableView *) tableView {
	if (tableView == groupsTable) {
		return [json_controller numGroups];
	}
	return [json_controller numContacts];
}

- (id) tableView:(NSTableView *) tableView objectValueForTableColumn:(NSTableColumn *) column row:(int) row {
	if (tableView == groupsTable) {
		return [json_controller groupAtIndex: row];
	}
	return [json_controller contactAtIndex: row];
}


@end
