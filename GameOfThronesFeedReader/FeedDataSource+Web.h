//
//  ContactsDataSource+Web.h
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "FeedDataSource.h"

@interface FeedDataSource (Web)

+ (void)feedFromWebWithCompletionBlock:(FeedDataSourceCompletion)completionBlock;

@end
