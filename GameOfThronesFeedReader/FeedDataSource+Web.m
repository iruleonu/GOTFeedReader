//
//  ContactsDataSource+Web.m
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "FeedDataSource+Web.h"
#import "ApiClient+Feed.h"
#import "FeedDataSource+Parser.h"

@implementation FeedDataSource (Web)

+ (void)feedFromWebWithApiClient:(ApiClient * _Nonnull)apiClient
                excludingPostIds:(NSArray<NSString *> * _Nullable)excludingIds
            lastUpdatedTimestamp:(NSString * _Nullable)timestmap
                      pageNumber:(NSInteger)pageNumber
                 completionBlock:(FeedDataSourceCompletion _Nonnull)completionBlock {
    // Build dictionary with parameters to send to the server.
    // This should be a mantle object after calling dictionaryValue
    NSDictionary *parameters = nil;
    
    [apiClient fetchFeedWithPageNumber:0
                            parameters:parameters
                            beforeLoad:nil
                             afterLoad:nil
                             onSuccess:^(id _Nullable response) {
                                 [FeedDataSource parseFeedData:response withCompletion:completionBlock];
                             } onError:^(NSError * _Nonnull error) {
                                 completionBlock(nil, error);
                             }];
}

@end
