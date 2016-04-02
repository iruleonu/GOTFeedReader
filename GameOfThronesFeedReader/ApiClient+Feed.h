//
//  ApiClient+Contacts.h
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "ApiClient.h"

@interface ApiClient (Feed)

- (void)fetchFeedWithPageNumber:(NSInteger)pageNumber
                     parameters:(NSDictionary * _Nullable)parameters
                     beforeLoad:(BeforeLoadBlockType _Nullable)beforeLoad
                      afterLoad:(AfterLoadBlockType _Nullable)afterLoad
                      onSuccess:(FetchResponseSuccessBlockType _Nullable)onSuccess
                        onError:(ErrorBlockType _Nullable)onError;

@end
