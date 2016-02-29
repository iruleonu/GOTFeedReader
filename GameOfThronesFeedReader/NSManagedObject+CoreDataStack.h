//
//  NSManagedObject+CoreDataStack.h
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "CoreDataStore.h"

@interface NSManagedObject (CoreDataStack)

+ (void)fetchWithUUID:(NSString *)uuid completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
+ (void)fetchWithUUID:(NSString *)uuid inManagedObjectContext:(NSManagedObjectContext *)context completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
+ (void)fetchWithUUID:(NSString *)uuid inManagedObjectContext:(NSManagedObjectContext *)context asynchronous:(BOOL)asynchronous completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context asynchronous:(BOOL)asynchronous completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context asynchronous:(BOOL)asynchronous entityName:(NSString *)entityName completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
+ (void)fetchWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inManagedObjectContext:(NSManagedObjectContext *)context completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
+ (void)fetchWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inManagedObjectContext:(NSManagedObjectContext *)context entityName:(NSString *)entityName completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
+ (NSFetchedResultsController *)fetchAllSortedBy:(NSArray *)properties ascending:(BOOL)ascending predicate:(NSPredicate *)predicate groupBy:(NSArray *)groupBy delegate:(id)delegate;
+ (NSFetchedResultsController *)fetchAllSortedBy:(NSArray *)properties ascending:(BOOL)ascending predicate:(NSPredicate *)predicate fetchLimit:(NSUInteger)fetchLimit fetchBatchSize:(NSUInteger)batchSize groupBy:(NSArray *)groupBy delegate:(id)delegate;
- (void)copyAttributesAndValuesTo:(NSManagedObject *)toNSManagedObject;

@end
