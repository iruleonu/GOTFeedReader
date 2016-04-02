//
//  ApiClient+Contacts.m
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "ApiClient+Feed.h"

static NSString * const EndpointFetchFeed = @"http://www.makinggameofthrones.com/production-diary?format=JSON&page=%ld";

@implementation ApiClient (Feed)

- (void)fetchFeedWithPageNumber:(NSInteger)pageNumber
                     parameters:(NSDictionary * _Nullable)parameters
                     beforeLoad:(BeforeLoadBlockType _Nullable)beforeLoad
                      afterLoad:(AfterLoadBlockType _Nullable)afterLoad
                      onSuccess:(FetchElementsSuccessBlockType _Nullable)onSuccess
                        onError:(ErrorBlockType _Nullable)onError {
    NSString *url = [NSString stringWithFormat:EndpointFetchFeed, (long)pageNumber];

    [self.networkManager requestWithType:HTTP_REQUEST_TYPE_GET
                                     url:url
                              parameters:parameters
                              beforeLoad:beforeLoad
                               afterLoad:afterLoad
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
                                     if (onSuccess) {
                                         onSuccess(response);
                                     }
                                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     if (onError) {
                                         onError(error);
                                     }
                                 }];
}

@end
