//
//  CoreDataStore.h
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void(^CoreDataStoreFetchCompletionBlock)(NSArray *results);
typedef void(^CoreDataStoreSaveCompletion)(BOOL saved, NSError *error);

static NSString * const CoreDataStorePurgeUserDataNotification = @"CoreDataStorePurgeUserDataNotification";

/**
 *  Merge and notification behaviour Core Data Stack
 *  -CRUD operations goes in the backgroundManagedObjectContext, after operations, send the NSManagedObjectContextDidSaveNotification
 *  -Listening for the updated changes is performed on the managedObjectContext, by listening for the NSManagedObjectContextDidSaveNotification
 *  and do a mergeChangesFromContextDidSaveNotification
 *  -Fetches uses the main managedObjectContext to...
 */
@interface CoreDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (CoreDataStore *)instance;

// Saving
- (void)saveIntoMainContext;
- (BOOL)saveIntoContext:(NSManagedObjectContext*)context;
- (void)saveDataIntoMainContextUsingBlock:(CoreDataStoreSaveCompletion)savedBlock;
- (void)saveDataIntoContext:(NSManagedObjectContext*)context usingBlock:(CoreDataStoreSaveCompletion)savedBlock;

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

// Fetches
- (void)fetchEntriesForClassName:(NSString *)className
                   withPredicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors
                 completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
- (void)fetchEntriesForClassName:(NSString *)className
                   withPredicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors
            managedObjectContext:(NSManagedObjectContext *)context
                 completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
- (void)fetchEntriesForClassName:(NSString *)className
                   withPredicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors
            managedObjectContext:(NSManagedObjectContext *)context
                    asynchronous:(BOOL)asynchronous
                 completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock;
@end

@interface CoreDataStore (Parsing)

// Temporary moc for model parsing purposes
- (NSManagedObjectContext *)temporaryMOC;

@end

@interface CoreDataStore (NSFecthedResultsController)

- (BOOL)uniqueAttributeForClassName:(NSString *)className
                      attributeName:(NSString *)attributeName
                     attributeValue:(id)attributeValue;

- (NSFetchedResultsController *)controllerWithEntitiesName:(NSString *)className
                                                 predicate:(NSPredicate *)predicate
                                           sortDescriptors:(NSArray *)sortDescriptors
                                                 batchSize:(NSUInteger)batchSize
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 cacheName:(NSString *)cacheName;

- (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
                                                 predicate:(NSPredicate *)predicate
                                           sortDescriptors:(NSArray *)sortDescriptors
                                                 batchSize:(NSUInteger)batchSize
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 cacheName:(NSString *)cacheName;

@end
