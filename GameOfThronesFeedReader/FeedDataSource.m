//
//  ContactsDataSource.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "FeedDataSource.h"
#import "FeedDataSource+Web.h"
#import "ApiClient.h"
#import "IRCoreDataStack.h"

@interface FeedDataSource ()

@property (nonatomic, strong) ApiClient *apiClient;
@property (nonatomic, strong) IRCoreDataStack *dataStore;

@end

@implementation FeedDataSource

- (instancetype)initWithApiClient:(ApiClient *)apiClient dataStore:(IRCoreDataStack *)dataStore {
    if (self = [super init]) {
        self.apiClient = apiClient;
        self.dataStore = dataStore;
    }
    return self;
}

- (void)feedWithCompletionBlock:(FeedDataSourceCompletion)completionBlock {
    // Cool version:
    // Get the latest ids that we already have cached to send to the server
    // Along side with the latest refresh timestamp (case some post has been updated)
    
    // Not a cool version: Endpoint doesnt support this, so:
    [FeedDataSource feedFromWebWithApiClient:self.apiClient
                            excludingPostIds:nil
                        lastUpdatedTimestamp:nil
                                  pageNumber:0
                             completionBlock:completionBlock];
}

@end
