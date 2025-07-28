//
//  JSONToken.h
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
	JSONTokenString,
	JSONTokenNumber,
	JSONTokenCurlyOpen,
	JSONTokenCurlyClosed,
	JSONTokenSquareOpen,
	JSONTokenSquareClosed,
	JSONTokenColon,
	JSONTokenComma,
	JSONTokenTrue,
	JSONTokenFalse,
	JSONTokenNull,
	JSONTokenUnknown,
	JSONTokenEOF
} JSONTokenType;

@interface JSONToken : NSObject {
	JSONTokenType type;
	NSString * value;
}

+ (JSONToken *) tokenWithType:(JSONTokenType) type andValue:(NSString *) val;
+ (JSONToken *) tokenWithType:(JSONTokenType) type;
- (JSONTokenType) type;
- (NSString *) value;

@end
