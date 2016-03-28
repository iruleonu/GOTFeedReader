//
//  EntityProvider.h
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "IRCoreDataStack+Operations.h"

@interface EntityProvider : NSObject

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *backgroundManagedObjectContext;

+ (EntityProvider *)instance;

- (void)fetchAllPostsWithCompletionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
- (void)fetchPostWithManagedObjectID:(id)objectId withCompletionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
- (void)persistEntityFromPostMTLArray:(NSArray *)array withSaveCompletionBlock:(IRCoreDataStackSaveCompletion)savedBlock;

@end
