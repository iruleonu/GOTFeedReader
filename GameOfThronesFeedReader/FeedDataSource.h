//
//  ContactsDataSource.h
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FeedDataSourceCompletion)(NSArray *products, NSError *error);

@interface FeedDataSource : NSObject

+ (void)feedWithCompletionBlock:(FeedDataSourceCompletion)completionBlock;

@end
