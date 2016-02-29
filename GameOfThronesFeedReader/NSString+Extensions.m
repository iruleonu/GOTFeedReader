//
//  NSString+Extensions.m
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "NSString+Extensions.h"
#import "NSObject+Extensions.h"

@implementation NSString (Extensions)

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isValidString {
    return ([self isValidObject] && [self trim].length != 0);
}

- (NSString *)stringByStrippingHTML {
    NSString *s = [self copy];
    NSRange r;
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end
