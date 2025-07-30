//
//  main.m
//  Noise
//
//  Created by Jake on 7/24/25.
//  Copyright __MyCompanyName__ 2025. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "json-rpc.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retval = NSApplicationMain(argc,  (const char **) argv);
	[pool release];
    return retval;
}
