//
//  NSManagedObject+IRCoreDataStack.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 28/03/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "IRCoreDataStack.h"
#import "IRCoreDataStack+Operations.h"

@interface NSManagedObject (IRCoreDataStack)

+ (instancetype)createEntity;
+ (instancetype)createEntityInManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)fetchWithUUID:(NSString *)uuid completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
+ (void)fetchWithUUID:(NSString *)uuid inManagedObjectContext:(NSManagedObjectContext *)context completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
+ (void)fetchWithUUID:(NSString *)uuid inManagedObjectContext:(NSManagedObjectContext *)context asynchronous:(BOOL)asynchronous completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context asynchronous:(BOOL)asynchronous completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context asynchronous:(BOOL)asynchronous entityName:(NSString *)entityName completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context sortDescriptors:(NSArray *)sortDescriptors asynchronous:(BOOL)asynchronous completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context sortDescriptors:(NSArray *)sortDescriptors entityName:(NSString *)entityName asynchronous:(BOOL)asynchronous completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock;
+ (NSFetchedResultsController *)fetchAllSortedBy:(NSArray *)properties ascending:(BOOL)ascending predicate:(NSPredicate *)predicate groupBy:(NSArray *)groupBy delegate:(id)delegate;
+ (NSFetchedResultsController *)fetchAllSortedBy:(NSArray *)properties ascending:(BOOL)ascending predicate:(NSPredicate *)predicate fetchLimit:(NSUInteger)fetchLimit fetchBatchSize:(NSUInteger)batchSize groupBy:(NSArray *)groupBy delegate:(id)delegate;
- (void)copyAttributesAndValuesTo:(NSManagedObject *)toNSManagedObject;

@end
