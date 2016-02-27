//
//  NSManagedObject+CoreDataStack.m
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "NSManagedObject+CoreDataStack.h"

@implementation NSManagedObject (CoreDataStack)

+ (void)fetchWithUUID:(NSString *)uuid completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock
{
    [self fetchWithUUID:uuid inManagedObjectContext:nil completionBlock:completionBlock];
}

+ (void)fetchWithUUID:(NSString *)uuid inManagedObjectContext:(NSManagedObjectContext *)context completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock
{
    [self fetchWithUUID:uuid inManagedObjectContext:context asynchronous:NO completionBlock:completionBlock];
}

+ (void)fetchWithUUID:(NSString *)uuid inManagedObjectContext:(NSManagedObjectContext *)context asynchronous:(BOOL)asynchronous completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock
{
    [self fetchWithPredicate:[NSPredicate predicateWithFormat:@"uuid == %ld", [uuid longLongValue]] inManagedObjectContext:context asynchronous:asynchronous completionBlock:completionBlock];
}

+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock
{
    [self fetchWithPredicate:predicate inManagedObjectContext:context asynchronous:NO completionBlock:completionBlock];
}

+ (void)fetchWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inManagedObjectContext:(NSManagedObjectContext *)context completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock
{
    [self fetchWithPredicate:predicate sortDescriptors:sortDescriptors inManagedObjectContext:context asynchronous:NO completionBlock:completionBlock];
}

+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context asynchronous:(BOOL)asynchronous completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock
{
    [self fetchWithPredicate:predicate sortDescriptors:nil inManagedObjectContext:context asynchronous:asynchronous completionBlock:completionBlock];
}

+ (void)fetchWithPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors inManagedObjectContext:(NSManagedObjectContext *)context asynchronous:(BOOL)asynchronous completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock
{
    [[CoreDataStore instance] fetchEntriesForClassName:NSStringFromClass([self class])
                                         withPredicate:predicate
                                       sortDescriptors:sortDescriptors
                                  managedObjectContext:context
                                          asynchronous:asynchronous
                                       completionBlock:completionBlock];
}

+ (NSFetchedResultsController *)fetchAllSortedBy:(NSArray *)properties ascending:(BOOL)ascending predicate:(NSPredicate *)predicate groupBy:(NSArray *)groupBy delegate:(id)delegate
{
    return [self fetchAllSortedBy:properties ascending:ascending predicate:predicate fetchLimit:0 fetchBatchSize:0 groupBy:groupBy delegate:delegate];
}

+ (NSFetchedResultsController *)fetchAllSortedBy:(NSArray *)properties ascending:(BOOL)ascending predicate:(NSPredicate *)predicate fetchLimit:(NSUInteger)fetchLimit fetchBatchSize:(NSUInteger)batchSize groupBy:(NSArray *)groupBy delegate:(id)delegate
{
    NSArray *sortDescriptors = [properties arrayFromObjectsCollectedWithBlock:^id(NSString *propertyName) {
        return [NSSortDescriptor sortDescriptorWithKey:propertyName ascending:ascending];
    }];
    
    NSFetchedResultsController *fc = [[CoreDataStore instance] controllerWithEntitiesName:NSStringFromClass([self class])
                                                                                  predicate:predicate
                                                                            sortDescriptors:sortDescriptors
                                                                                  batchSize:batchSize
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil]; // NSStringFromClass([self class])
    fc.delegate = delegate;
    return fc;
}

- (void)copyAttributesAndValuesTo:(NSManagedObject *)toNSManagedObject {
    [self.entity.attributesByName.allKeys enumerateObjectsUsingBlock:^(NSString *attrKey, NSUInteger idx, BOOL *stop) {
        id valueForKey = [[self valueForKey:attrKey] copy];
        [toNSManagedObject setValue:valueForKey forKey:attrKey];
    }];
}

@end
