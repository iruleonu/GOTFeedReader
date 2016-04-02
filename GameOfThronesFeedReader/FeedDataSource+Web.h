//
//  ContactsDataSource+Web.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "FeedDataSource.h"

@interface FeedDataSource (Web)

+ (void)feedFromWebWithApiClient:(ApiClient * _Nonnull)apiClient
                 excludingPostIds:(NSArray<NSString *> * _Nullable)excludingIds
            lastUpdatedTimestamp:(NSString * _Nullable)timestmap
                      pageNumber:(NSInteger)pageNumber
                 completionBlock:(FeedDataSourceCompletion _Nonnull)completionBlock;


@end
