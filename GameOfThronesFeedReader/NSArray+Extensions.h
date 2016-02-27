//
//  NSArray+HOM.h
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extensions)

- (NSArray *)arrayFromObjectsCollectedWithBlock:(id(^)(id object))block;

@end
