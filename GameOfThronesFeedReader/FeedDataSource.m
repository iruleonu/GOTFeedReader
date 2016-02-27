//
//  ContactsDataSource.m
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "FeedDataSource.h"
#import "FeedDataSource+Web.h"

@implementation FeedDataSource

+ (void)feedWithCompletionBlock:(FeedDataSourceCompletion)completionBlock {
    [FeedDataSource feedFromWebWithCompletionBlock:completionBlock];
}

@end
