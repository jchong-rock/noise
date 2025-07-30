//
//  RenameViewController.h
//  Noise
//
//  Created by Jake on 7/30/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <json-rpc.h>

@interface RenameViewController : NSObject {
	IBOutlet NSButton * addButton;
	IBOutlet NSButton * cancelButton;
	IBOutlet NSForm * contactForm;
	IBOutlet NSWindow * dialogWindow;
	JSON_RPC * delegate;
	IBOutlet NSTableView * contactTable;
}

- (IBAction) cancelClicked:(id) sender;
- (IBAction) addClicked:(id) sender;
- (IBAction) showWindow:(NSTableView *) tblv;

@end
