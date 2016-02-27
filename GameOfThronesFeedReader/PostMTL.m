//
//  PostMTL.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "PostMTL.h"
#import "MTLModel+Extensions.h"
#import "PostCD.h"
#import "PostAuthorMTL.h"

@implementation PostMTL

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [self dictionaryMapping:@{ @"uuid" : @"id" }];
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:PostAuthorMTL.class];
}

+ (NSValueTransformer *)publishOnJSONTransformer {
    return [self timestampToDateTransformer];
}

#pragma mark - Custom

- (Class)coreDataCompanionClass {
    return [PostCD class];
}

@end
