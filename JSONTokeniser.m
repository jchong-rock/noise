//
//  JSONTokeniser.m
//  Noise
//
//  Created by Jake on 7/25/25.
//  Copyright 2025 __MyCompanyName__. All rights reserved.
//

#import "JSONTokeniser.h"


@implementation JSONTokeniser 
- (JSONTokeniser *) initWithString:(NSString *) input {
	if (self = [super init]) {
		_input = [input retain];
		_pos = 0;
	}
	return self;
}

- (void) dealloc {
	[_input release];
	[super dealloc];
}

- (char) peek {
	if (_pos >= [_input length]) return 0;
	return [_input characterAtIndex: _pos];
}

- (char) next {
	if (_pos >= [_input length]) return 0;
	return [_input characterAtIndex: _pos++];
}

- (void) skipWhitespace {
	while (_pos < [_input length] && [[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self peek]]) {
		_pos++;
	}
}

- (JSONToken *) parseString {
	NSMutableString * result = [NSMutableString string];
	_pos++;
	
	while (_pos < [_input length]) {
		char c = [self next];
		if (c == '"') break;
		if (c == '\\') {
			char next = [self next];
			switch (next) {
				case 'n':
					[result appendString:@"\n"]; break;
				case 't':
					[result appendString:@"\t"]; break;
				case 'r':
					[result appendString:@"\r"]; break;
				default:
					[result appendFormat:@"%c", next];
			}
		}
		else {
			[result appendFormat:@"%c", c];
		}
		
	}
	return [JSONToken tokenWithType: JSONTokenString andValue: result];
}

- (JSONToken *) parseNumber {
	unsigned int start = _pos;
	
	while (_pos < [_input length]) {
		char c = [self peek];
		BOOL has_dot = NO;
		if ((c >= '0' && c <= '9') || c == '-') {
			_pos++;
		}
		else if (c == '.' && !has_dot) {
			has_dot = YES;
			_pos++;
		}
		else {
			break;
		}
		
	}
	NSString * numStr = [_input substringWithRange: NSMakeRange(start, _pos - start)];
	return [JSONToken tokenWithType: JSONTokenNumber andValue: numStr];
}

- (JSONToken *) parseLiteral {
	if ([[_input substringWithRange: NSMakeRange(_pos, 4)] isEqualToString: @"true"]) {
		_pos += 4;
		return [JSONToken tokenWithType: JSONTokenTrue andValue: @"true"];
	}
	else if ([[_input substringWithRange: NSMakeRange(_pos, 5)] isEqualToString: @"false"]) {
		_pos += 5;
		return [JSONToken tokenWithType: JSONTokenFalse andValue: @"false"];
	}
	else if ([[_input substringWithRange: NSMakeRange(_pos, 4)] isEqualToString: @"null"]) {
		_pos += 4;
		return [JSONToken tokenWithType: JSONTokenNull andValue: @"null"];
	}
	return [JSONToken tokenWithType: JSONTokenUnknown andValue: @"unknown"];
}

- (JSONToken *) nextToken {
	[self skipWhitespace];
	char c = [self peek];

	if (c == 0) return [JSONToken tokenWithType:JSONTokenEOF andValue: @"EOF"];
	
	switch (c) {
		case '{': 
			_pos++; return [JSONToken tokenWithType: JSONTokenCurlyOpen andValue: @"{"];
		case '}':
			_pos++; return [JSONToken tokenWithType: JSONTokenCurlyClosed andValue: @"}"];
		case '[':
			_pos++; return [JSONToken tokenWithType: JSONTokenSquareOpen andValue: @"["];
		case ']':
			_pos++; return [JSONToken tokenWithType: JSONTokenSquareClosed andValue: @"]"];
		case ':':
			_pos++; return [JSONToken tokenWithType: JSONTokenColon andValue: @":"];
		case ',':
			_pos++; return [JSONToken tokenWithType: JSONTokenComma andValue: @","];
		case '"':
			return [self parseString];
		default:
			if ((c >= '0' && c <= '9') || c == '-') return [self parseNumber];
			else return [self parseLiteral];
	}
}

@end
