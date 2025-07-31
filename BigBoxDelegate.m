//
//  BigBoxDelegate.m
//  Noise
//
//  Created by Jake on 7/27/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "BigBoxDelegate.h"
#import "MessageTextCell.h"
#import <ctype.h>

@implementation BigBoxDelegate

- (id) init {
	self = [super init];
	bigboxLock = [[NSLock alloc] init];
	return self;
}

- (BOOL) tableView:(NSTableView *) tblv shouldSelectRow:(int) row {
	return NO;
}

- (void) setFromsGroup:(NSDictionary *) frm andTos:(NSDictionary *) tss {
	NSMutableDictionary * frms = [NSMutableDictionary dictionary];
	int j;
	NSArray * kees = [frm allKeys];
	[bigboxLock lock];
	for (j = 0; j < [frm count]; j++) {
		id key = [kees objectAtIndex: j];
		id dictt = [frm objectForKey: key];
		int k;
		NSArray * kyes = [dictt allKeys];
		for (k = 0; k < [dictt count]; k++) {
			id ky = [kyes objectAtIndex: k];
			ContactEntry * rtval = [[ContactEntry alloc] initWithSender: key
																 andKey: ky
															 andMessage: [dictt objectForKey: ky]
															  andIsRecv: YES
				];
			[frms setObject: rtval forKey: ky];
			[rtval release];
		}
	}
	NSArray * kyes = [tss allKeys];
	int k;
	
	for (k = 0; k < [tss count]; k++) {
		id ky = [kyes objectAtIndex: k];
		ContactEntry * rtval = [[ContactEntry alloc] initWithSender: nil
															 andKey: ky
														 andMessage: [tss objectForKey: ky]
														  andIsRecv: NO
			];
		[frms setObject: rtval forKey: ky];
		[rtval release];
	}
	[messages release];
	[frms retain];
	messages = frms;
	[self keySort: [frms allKeys]];
	
}

- (void) setFroms:(NSDictionary *) frm andTos:(NSDictionary *) tss {
	[bigboxLock lock];
	if (frm == nil || tss == nil) {
		messages = nil;
		sortedKeys = nil;
		[bigboxLock unlock];
		return;
	}
	NSMutableDictionary * frms = [NSMutableDictionary dictionary];
	int k;
	NSArray * kyes = [frm allKeys];
	for (k = 0; k < [frm count]; k++) {
		id ky = [kyes objectAtIndex: k];
		ContactEntry * rtval = [[ContactEntry alloc] initWithSender: nil
															 andKey: ky
														 andMessage: [frm objectForKey: ky]
														  andIsRecv: YES
			];
		[frms setObject: rtval forKey: ky];
		[rtval release];
	}
	kyes = [tss allKeys];
	for (k = 0; k < [tss count]; k++) {
		id ky = [kyes objectAtIndex: k];
		ContactEntry * rtval = [[ContactEntry alloc] initWithSender: nil
															 andKey: ky
														 andMessage: [tss objectForKey: ky]
														  andIsRecv: NO
			];
		[frms setObject: rtval forKey: ky];
		[rtval release];
	}
	[messages release];
	[frms retain];
	messages = frms;
	[self keySort: [frms allKeys]];
}

- (void) keySort:(NSArray *) unsorted {
	[sortedKeys release];
	int i;
	NSMutableArray * numerical = [NSMutableArray array];
	for (i = 0; i < [unsorted count]; i++) {
		NSString * sss = [unsorted objectAtIndex: i];
		NSScanner * scb = [NSScanner scannerWithString: sss];
		long long va;
		[scb scanLongLong: &va];
		NSNumber * nnn = [NSNumber numberWithLongLong: va];
		[numerical addObject: nnn];
	}
	[bigboxLock unlock];
	sortedKeys = [numerical sortedArrayUsingSelector: @selector(compare:)];
	[sortedKeys retain];
}

- (int) numberOfRowsInTableView:(NSTableView *) tableView {
	int retval = 0;
	[bigboxLock lock];
	if (messages != nil) {
		retval = [messages count];
	}
	[bigboxLock unlock];
	return retval;
}

- (ContactEntry *) keyAtRow:(int) row {
	[bigboxLock lock];
	ContactEntry * entry = [messages objectForKey: [[sortedKeys objectAtIndex: row] stringValue]];
	[bigboxLock unlock];
	return entry;
}

- (id) tableView:(NSTableView *) tableView objectValueForTableColumn:(NSTableColumn *) column row:(int) row {
	ContactEntry * val = [self keyAtRow: row];
	// change to make prettier
	return ([val sender] == nil) ? [val message] :
		[NSString stringWithFormat: @"%@:\n%@", [val sender], [val message]];
}

- (void) tableView:(NSTableView *) tableView willDisplayCell:(id) cell forTableColumn:(NSTableColumn *) column row:(int) row {
	if ([cell isKindOfClass: [MessageTextCell class]]) {
		
		ContactEntry * val = [self keyAtRow: row];
		
		[(MessageTextCell *) cell setFont: [NSFont fontWithName:@"Monaco" size: 12]];
		if ([val isRecv]) {
			[(MessageTextCell *) cell setIsRecv: YES];
			[(MessageTextCell *) cell setAlignment: NSLeftTextAlignment];
		}
		else {
			[(MessageTextCell *) cell setIsRecv: NO];
			[(MessageTextCell *) cell setAlignment: NSRightTextAlignment];
		}
	}
}

- (double) tableView:(NSTableView *) tableView heightOfRow:(int) row {
	unsigned sizeOfRow = 43;
	unsigned numberOfLines = 2;
	unsigned i;
	ContactEntry * val = [self keyAtRow: row];
	NSString * text = ([val sender] == nil) ? [val message] :
		[NSString stringWithFormat: @"%@:\n%@", [val sender], [val message]];
	unsigned word = 0;
	unsigned line = 0;
	for (i = 0; i < [text length]; i++) {
		char c = [text characterAtIndex: i];
		switch (c) {
			case '\n':
				line = 0;
				numberOfLines++;
				word = i;
				break;
			default:
				if (!isalnum(c)) {
					word = i;
				}
				if (++line > sizeOfRow) {
					line = 0;
					numberOfLines++;
					line = i - word;
				}
		}
	}
	//numberOfLines = MAX(numberOfLines);
	return 17 * numberOfLines + 6; 
}

- (void) dealloc {
	[bigboxLock release];
	[messages release];
	[sortedKeys release];
	[super dealloc];
}

@end
