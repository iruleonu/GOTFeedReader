//
//  ContactMTL.m
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "FeedPagedResultsMTL.h"
#import "MTLModel+Extensions.h"
#import "FeedPaginationMTL.h"
#import "PostMTL.h"

@implementation FeedPagedResultsMTL

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [self dictionaryMapping:nil];
}

+ (NSValueTransformer *)paginationJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:FeedPaginationMTL.class];
}

+ (NSValueTransformer *)itemsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:PostMTL.class];
}

@end
