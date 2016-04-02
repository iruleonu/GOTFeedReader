//
//  EntityProvider.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IRCoreDataStack+Operations.h"

@interface EntityProvider : NSObject

+ (EntityProvider *)instance;

- (instancetype)init NS_DESIGNATED_INITIALIZER NS_UNAVAILABLE;
- (instancetype)initWithDataProvider:(IRCoreDataStack *)dataProvider NS_DESIGNATED_INITIALIZER;

- (void)fetchAllPostsWithCompletionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
- (void)fetchPostWithManagedObjectID:(id)objectId withCompletionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
- (void)persistEntityFromPostMTLArray:(NSArray *)array withSaveCompletionBlock:(IRCoreDataStackSaveCompletion)savedBlock;

@end
