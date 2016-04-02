//
//  NSManagedObject+IRCoreDataStack.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 28/03/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "NSManagedObject+IRCoreDataStack.h"
#import "FacadeAPI.h"
#import "IRCoreDataStack+NSFecthedResultsController.h"

@implementation NSManagedObject (IRCoreDataStack)

+ (instancetype)createEntity {
    NSManagedObjectContext *moc = [FacadeAPI sharedInstance].coreDataStack.managedObjectContext;
    return [self createEntityInManagedObjectContext:moc];
}

+ (instancetype)createEntityInManagedObjectContext:(NSManagedObjectContext *)context {
    NSManagedObjectContext *moc = (context == nil) ? [FacadeAPI sharedInstance].coreDataStack.managedObjectContext : context;
    NSManagedObject *entity = [[FacadeAPI sharedInstance].coreDataStack createEntityWithClassName:NSStringFromClass([self class])
                                                                             attributesDictionary:nil
                                                                           inManagedObjectContext:moc];
    return entity;
}

+ (void)fetchWithUUID:(NSString *)uuid completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock {
    [self fetchWithUUID:uuid inManagedObjectContext:nil completionBlock:completionBlock];
}

+ (void)fetchWithUUID:(NSString *)uuid inManagedObjectContext:(NSManagedObjectContext *)context completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock {
    [self fetchWithUUID:uuid inManagedObjectContext:context asynchronous:NO completionBlock:completionBlock];
}

+ (void)fetchWithUUID:(NSString *)uuid inManagedObjectContext:(NSManagedObjectContext *)context asynchronous:(BOOL)asynchronous completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock {
    [self fetchWithPredicate:[NSPredicate predicateWithFormat:@"uuid == %ld", [uuid longLongValue]] inManagedObjectContext:context asynchronous:asynchronous completionBlock:completionBlock];
}

+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock {
    [self fetchWithPredicate:predicate inManagedObjectContext:context asynchronous:NO completionBlock:completionBlock];
}

+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context asynchronous:(BOOL)asynchronous completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock {
    [self fetchWithPredicate:predicate inManagedObjectContext:context sortDescriptors:nil entityName:NSStringFromClass([self class]) asynchronous:asynchronous completionBlock:completionBlock];
}

+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context asynchronous:(BOOL)asynchronous entityName:(NSString *)entityName completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock {
    [self fetchWithPredicate:predicate inManagedObjectContext:context sortDescriptors:nil entityName:entityName asynchronous:asynchronous completionBlock:completionBlock];
}

+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context sortDescriptors:(NSArray *)sortDescriptors asynchronous:(BOOL)asynchronous completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock {
    [self fetchWithPredicate:predicate inManagedObjectContext:context sortDescriptors:sortDescriptors entityName:NSStringFromClass([self class]) asynchronous:NO completionBlock:completionBlock];
}

+ (void)fetchWithPredicate:(NSPredicate *)predicate inManagedObjectContext:(NSManagedObjectContext *)context sortDescriptors:(NSArray *)sortDescriptors entityName:(NSString *)entityName asynchronous:(BOOL)asynchronous completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock {
    NSString *entriesForClassName = (entityName) ? entityName : NSStringFromClass([self class]);
    [[FacadeAPI sharedInstance].coreDataStack fetchEntriesForClassName:entriesForClassName
                                                       withPredicate:predicate
                                                     sortDescriptors:sortDescriptors
                                                managedObjectContext:context
                                                        asynchronous:asynchronous
                                                     completionBlock:completionBlock];
}

+ (NSFetchedResultsController *)fetchAllSortedBy:(NSArray *)properties ascending:(BOOL)ascending predicate:(NSPredicate *)predicate groupBy:(NSArray *)groupBy delegate:(id)delegate {
    return [self fetchAllSortedBy:properties ascending:ascending predicate:predicate fetchLimit:0 fetchBatchSize:0 groupBy:groupBy delegate:delegate];
}

+ (NSFetchedResultsController *)fetchAllSortedBy:(NSArray *)properties ascending:(BOOL)ascending predicate:(NSPredicate *)predicate fetchLimit:(NSUInteger)fetchLimit fetchBatchSize:(NSUInteger)batchSize groupBy:(NSArray *)groupBy delegate:(id)delegate {
    NSArray *sortDescriptors = [properties arrayFromObjectsCollectedWithBlock:^id(NSString *propertyName) {
        return [NSSortDescriptor sortDescriptorWithKey:propertyName ascending:ascending];
    }];
    
    NSFetchedResultsController *fc = [[FacadeAPI sharedInstance].coreDataStack controllerWithEntitiesName:NSStringFromClass([self class])
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
