//
//  JSONTokeniser.h
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSONToken.h"

@interface JSONTokeniser : NSObject {
	NSString * _input;
	unsigned int _pos;
}

- (JSONTokeniser *) initWithString:(NSString *) input;
- (JSONToken *) nextToken;

@end
