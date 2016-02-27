//
//  NSArray+HOM.m
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "NSArray+Extensions.h"

@implementation NSArray (Extensions)

- (NSArray *)arrayFromObjectsCollectedWithBlock:(id(^)(id object))block
{
    __block NSMutableArray *collection = [NSMutableArray arrayWithCapacity:[self count]];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id nullFailSafe = block(obj);
        if (nullFailSafe) {
            [collection addObject:nullFailSafe];
        }
    }];
    
    return collection;
}

@end
