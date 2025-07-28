//
//  SettingsViewController.h
//  Noise
//
//  Created by Jake on 7/28/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "json-rpc.h"

@interface SettingsViewController : NSObject {
	IBOutlet NSButton * okButton;
	IBOutlet NSButton * cancelButton;
	IBOutlet NSForm * prefsForm;
	IBOutlet NSWindow * dialogWindow;
	JSON_RPC * delegate;
}

- (IBAction) cancelClicked:(id) sender;
- (IBAction) okClicked:(id) sender;
- (IBAction) showWindow;
- (void) blockCancel;

@end
