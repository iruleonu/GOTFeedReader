//
//  IRCoreDataStack+Operations.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 28/03/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "IRCoreDataStack.h"

typedef void(^IRCoreDataStackSaveCompletion)(BOOL saved, NSError *error);
typedef void(^IRCoreDataStackFetchCompletionBlock)(NSArray *results);

@interface IRCoreDataStack (Operations)

// Saving
- (void)saveIntoMainContext;
- (BOOL)saveIntoContext:(NSManagedObjectContext*)context;
- (void)saveDataIntoMainContextUsingBlock:(IRCoreDataStackSaveCompletion)savedBlock;
- (void)saveDataIntoContext:(NSManagedObjectContext*)context usingBlock:(IRCoreDataStackSaveCompletion)savedBlock;

// CRUD
- (id)createEntityWithClassName:(NSString *)className
           attributesDictionary:(NSDictionary *)attributesDictionary;
- (id)createEntityWithClassName:(NSString *)className
           attributesDictionary:(NSDictionary *)attributesDictionary
         inManagedObjectContext:(NSManagedObjectContext *)context;
- (void)deleteEntity:(NSManagedObject *)entity;
- (void)deleteAllFromEntity:(NSString *)entityName NS_AVAILABLE_IOS(9_0);
- (void)deleteEntity:(NSManagedObject *)entity inManagedObjectContext:(NSManagedObjectContext *)context;
- (void)deleteAllFromEntity:(NSString *)entityName inManagedObjectContext:(NSManagedObjectContext *)context NS_AVAILABLE_IOS(9_0);

// FETCHING
- (void)fetchEntriesForClassName:(NSString *)className
                   withPredicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors
                 completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
- (void)fetchEntriesForClassName:(NSString *)className
                   withPredicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors
            managedObjectContext:(NSManagedObjectContext *)context
                 completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
- (void)fetchEntriesForClassName:(NSString *)className
                   withPredicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors
            managedObjectContext:(NSManagedObjectContext *)context
                    asynchronous:(BOOL)asynchronous
                 completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;

@end
