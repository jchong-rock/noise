//
//  JSONToken.m
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "JSONToken.h"


@implementation JSONToken

- (JSONToken *) initWithType:(JSONTokenType) t andValue:(NSString *) val {
	self = [super init];
	type = t;
	value = val;
	return self;
}

+ (JSONToken *) tokenWithType:(JSONTokenType) type andValue:(NSString *) val {
	return [[JSONToken alloc] initWithType: type andValue: val];
}

+ (JSONToken *) tokenWithType:(JSONTokenType) type {
	return [[JSONToken alloc] initWithType: type andValue: nil];
}

- (JSONTokenType) type {
	return type;
}

- (NSString *) value {
	return value;
}

@end
