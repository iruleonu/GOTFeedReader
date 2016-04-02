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

+ (void)feedFromWebWithCompletionBlock:(FeedDataSourceCompletion)completionBlock {
    [[ApiClient instance] fetchFeedWithPageNumber:0
                                       parameters:nil
                                       beforeLoad:nil
                                        afterLoad:nil
                                        onSuccess:^(id _Nullable response) {
                                            [FeedDataSource parseFeedData:response withCompletion:completionBlock];
                                        } onError:^(NSError * _Nonnull error) {
                                            completionBlock(nil, error);
                                        }];
}

@end
