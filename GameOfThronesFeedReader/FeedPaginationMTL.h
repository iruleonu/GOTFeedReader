//
//  FeedPagination.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface FeedPaginationMTL : MTLModel <MTLJSONSerializing>

@property (nonatomic) BOOL nextPage;
@property (nullable, nonatomic, retain) NSNumber *nextPageOffset;
@property (nullable, nonatomic, retain) NSString *nextPageUrl;
@property (nullable, nonatomic, retain) NSNumber *pageSize;

@end
