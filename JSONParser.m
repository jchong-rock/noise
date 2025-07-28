//
//  JSON-parse.m
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "JSONParser.h"

NSString * JSONStringEscape(NSString * input) {
	NSMutableString * escaped = [NSMutableString stringWithString:input];
	[escaped replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:0 range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:0 range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\b" withString:@"\\b" options:0 range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\f" withString:@"\\f" options:0 range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\n" withString:@"\\n" options:0 range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\r" withString:@"\\r" options:0 range:NSMakeRange(0, [escaped length])];
	[escaped replaceOccurrencesOfString:@"\t" withString:@"\\t" options:0 range:NSMakeRange(0, [escaped length])];
	return escaped;
}

NSString * JSONUnescape(NSString * input) {
	NSMutableString * unescaped = [NSMutableString stringWithString:input];
	[unescaped replaceOccurrencesOfString:@"\\\\" withString:@"\\" options:0 range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"\\\"" withString:@"\"" options:0 range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"\\n" withString:@"\n" options:0 range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"\\r" withString:@"\r" options:0 range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"\\t" withString:@"\t" options:0 range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"\\b" withString:@"\b" options:0 range:NSMakeRange(0, [unescaped length])];
	[unescaped replaceOccurrencesOfString:@"\\f" withString:@"\f" options:0 range:NSMakeRange(0, [unescaped length])];
	return unescaped;
}


@implementation JSONParser

- (void) advance {
	_currentToken = [_tokeniser nextToken];
}


- (NSDictionary *) parseObject {
	NSMutableDictionary * dict = [NSMutableDictionary dictionary];
	[self advance];
	
	while ([_currentToken type] != JSONTokenCurlyClosed && [_currentToken type] != JSONTokenEOF) {
		if ([_currentToken type] != JSONTokenString) {
			NSLog(@"Expected key string");
			return nil;
		}
		NSString * key = [[[_currentToken value] copy] autorelease];
		[self advance];
		
		if ([_currentToken type] != JSONTokenColon) {
			NSLog(@"Expected ':' after key");
			return nil;
		}
		[self advance];
		
		id value = [self parseValue];
		[dict setObject: value forKey: key];
		
		if ([_currentToken type] == JSONTokenComma) {
			[self advance];
		}
		else if ([_currentToken type] != JSONTokenCurlyClosed) {
			NSLog(@"Expected ',' or '}'");
			return nil;
		}
	}
	[self advance];
	return dict;
}

- (NSArray *) parseArray {
	NSMutableArray * array = [NSMutableArray array];
	[self advance];
	while ([_currentToken type] != JSONTokenSquareClosed && [_currentToken type] != JSONTokenEOF) {
		id value = [self parseValue];
		[array addObject: value];
		
		if ([_currentToken type] == JSONTokenComma) {
			[self advance];
		}
		else if ([_currentToken type] != JSONTokenSquareClosed) {
			NSLog(@"Expected ',' or ']'");
			return nil;
		}
	}
	[self advance];
	return array;
}

- (id) parseValue {
	switch ([_currentToken type]) {
		case JSONTokenCurlyOpen:
			return [self parseObject];
		case JSONTokenSquareOpen:
			return [self parseArray];
		case JSONTokenString: {
			NSString * val = [[[_currentToken value] copy] autorelease];
			[self advance];
			return val;
		}
		case JSONTokenNumber: {
			NSNumber * num = [NSNumber numberWithDouble: [[_currentToken value] doubleValue]];
			[self advance];
			return num;
		}
		case JSONTokenTrue:
			[self advance];
			return [NSNumber numberWithBool: YES];
		case JSONTokenFalse:
			[self advance];
			return [NSNumber numberWithBool: NO];
		case JSONTokenNull:
			[self advance];
			return [NSNull null];
		default:
			NSLog(@"Unexpected token: %@", [_currentToken value]);
			return nil;
	}
}

- (id) parseJSON:(NSString *) json {
	_tokeniser = [[JSONTokeniser alloc] initWithString: json];
	[self advance];
	id result = [self parseValue];
	[_tokeniser release];
	return result;
}

- (void) dealloc {
	[_tokeniser release];
	[_currentToken release];
	[super dealloc];
}

@end
