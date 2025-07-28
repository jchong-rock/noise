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

- (BOOL) tableView:(NSTableView *) tblv shouldSelectRow:(int) row {
	return NO;
}

- (void) setFroms:(NSDictionary *) frm andTos:(NSDictionary *) tss {
	froms = frm;
	tos = tss;
	NSArray * kys = [[froms allKeys] arrayByAddingObjectsFromArray:
		[tos allKeys]];
	//NSLog(@"class %@", [[kys objectAtIndex:0] class]);
	NSMutableArray * numArray = [NSMutableArray arrayWithCapacity:[kys count]];
	int i;
	for (i = 0; i < [kys count]; i++) {
		NSString * sss = [kys objectAtIndex: i];
		NSScanner * scb = [NSScanner scannerWithString: sss];
		long long va;
		[scb scanLongLong: &va];
		NSNumber * nnn = [NSNumber numberWithLongLong: va];
		[numArray addObject: nnn];
	}
	sortedKeys = [numArray sortedArrayUsingSelector: @selector(compare:)];
	
	[sortedKeys retain];
	//NSLog(@"setcalled, %@-%@-%@", froms, tos, sortedKeys);
	
}

- (int) numberOfRowsInTableView:(NSTableView *) tableView {
	if ((froms != nil) && (tos != nil)) {
		return [froms count] + [tos count];
	}
	return 0;
}

- (NSString *) valueForRow:(int) row {
	id key = [[sortedKeys objectAtIndex: row] stringValue];
	
	NSString * fs = [froms objectForKey: key];
	if (fs) {
		return fs;
	}
	return [tos objectForKey: key];
}

- (struct strBool *) keyAtRow:(int) row {
	struct strBool * rtval = malloc(sizeof(struct strBool));
	id key = [[sortedKeys objectAtIndex: row] stringValue];
	rtval->str = key;
	rtval->bl = ([froms objectForKey: key] == nil);
	return rtval;
}

- (id) tableView:(NSTableView *) tableView objectValueForTableColumn:(NSTableColumn *) column row:(int) row {
	return [self valueForRow: row];
}

- (void) tableView:(NSTableView *) tableView willDisplayCell:(id) cell forTableColumn:(NSTableColumn *) column row:(int) row {
	if ([cell isKindOfClass: [MessageTextCell class]]) {
		id key = [[sortedKeys objectAtIndex: row] stringValue];
		NSString * fs = [froms objectForKey: key];
		//NSLog(@"%@", [cell class]);
		[(MessageTextCell *) cell setFont: [NSFont fontWithName:@"Monaco" size: 12]];
		if (fs) {
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
	NSString * text = [self valueForRow: row];
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
	[sortedKeys release];
	[super dealloc];
}

@end
