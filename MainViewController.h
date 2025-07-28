//
//  MainViewController.h
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "json-rpc.h"
#import "AddContactViewController.h"
#import "BigBoxDelegate.h"
#import "JSONDelegate.h"
#import "SettingsViewController.h"

@interface MainViewController : NSObject <JSONDelegate> {
	IBOutlet NSButton * send_button;
	IBOutlet NSButton * new_button;
	IBOutlet NSButton * rename_button;
	IBOutlet NSButton * delete_button;
	IBOutlet NSTextField * msg_input;
	JSON_RPC * json_controller;
	IBOutlet NSTableView * contactTable;
	IBOutlet NSWindow * mainWindow;
	AddContactViewController * addContactPopup;
	SettingsViewController * settingsPopup;
	IBOutlet NSTableView * bigbox;
	NSString * current_phone;
	BigBoxDelegate * bbd;
}

- (IBAction) sendButtonClicked:(id) sender;
- (IBAction) deleteButtonClicked:(id) sender;
- (IBAction) newButtonClicked:(id) sender;
- (IBAction) renameButtonClicked:(id) sender;
- (void) deleteMessage:(id) sender;
- (void) reloadMsgs;

@end
