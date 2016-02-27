//
//  FeedPagination.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "FeedPaginationMTL.h"
#import "MTLModel+Extensions.h"

@implementation FeedPaginationMTL

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [self dictionaryMapping:nil];
}

@end
