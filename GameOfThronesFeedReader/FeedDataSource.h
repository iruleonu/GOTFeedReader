//
//  ContactsDataSource.h
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApiClient, IRCoreDataStack;

typedef void(^FeedDataSourceCompletion)(NSArray *products, NSError *error);

/**
 *  Ideally, this class would return the refreshed feed based on the current post ids that we already have on
 *  our cache (dataStore). We pass the ids to the server with the latest updated timestamp, and we get only
 *  the new and updated feed posts.
 */
@interface FeedDataSource : NSObject

/**
 *  Init method
 *
 *  @param apiClient Network client for the network request
 *  @param dataStore Local data manager
 */
- (instancetype)initWithApiClient:(ApiClient *)apiClient dataStore:(IRCoreDataStack *)dataStore;

- (void)feedWithCompletionBlock:(FeedDataSourceCompletion)completionBlock;

@end
