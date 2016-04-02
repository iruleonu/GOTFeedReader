//
//  ContactsDataSource+Parser.m
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "FeedDataSource+Parser.h"
#import "FeedPagedResultsMTL.h"
#import "PostMTL.h"
#import "PostCD.h"
#import "EntityProvider.h"

@implementation FeedDataSource (Parser)

+ (void)parseFeedData:(id)response withCompletion:(FeedDataSourceCompletion)completion {
    NSError *parseError = nil;
    
    FeedPagedResultsMTL *feedPagedResults = [MTLJSONAdapter modelOfClass:[FeedPagedResultsMTL class]
                                                      fromJSONDictionary:response
                                                                   error:&parseError];
    
    if (completion) {
        completion(feedPagedResults.items, parseError);
    }
}

@end
