//
//  NSObject+Extensions.m
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "NSObject+Extensions.h"

@implementation NSObject (Extensions)

- (BOOL)isValidObject {
    return (self && ![self isEqual:[NSNull null]]);
}

@end
