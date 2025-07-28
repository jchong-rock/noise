//
//  JSON-parse.h
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSONTokeniser.h"

NSString * JSONStringEscape(NSString * input);
NSString * JSONUnescape(NSString * input);

@interface JSONParser : NSObject {
	JSONTokeniser *_tokeniser;
	JSONToken *_currentToken;
}

- (id) parseJSON:(NSString *) json;

@end
