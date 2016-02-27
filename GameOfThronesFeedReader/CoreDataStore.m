//
//  CoreDataStore.m
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "CoreDataStore.h"

@interface CoreDataStore ()

@property (strong, nonatomic) NSString *managedObjectModelFilename;
@property (strong, nonatomic) NSString *storePath;
@property (strong, nonatomic) NSURL *storeURL;
@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;

@end

@implementation CoreDataStore

#pragma mark - initializer

+ (CoreDataStore *)instance
{
    static CoreDataStore *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataStore alloc] init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        self.managedObjectModelFilename = @"GameOfThronesFeedReader";
        self.storePath = @"GameOfThronesFeedReader.sqlite";
        self.storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:self.storePath];
        self.managedObjectContext = [self setupManagedObjectContextWithConcurrencyType:NSMainQueueConcurrencyType];
        self.backgroundManagedObjectContext = [self setupManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        // Cache related
        //[self.managedObjectContext setStalenessInterval:300];
        //[self.backgroundManagedObjectContext setStalenessInterval:300];
        
        // Importing related
        // This is be especially beneficial for background worker threads, as well as for large import or batch operations.
        self.managedObjectContext.undoManager = nil;
        self.backgroundManagedObjectContext.undoManager = nil;
    }
    return self;
}

- (NSManagedObjectContext *)setupManagedObjectContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)concurrencyType
{
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:concurrencyType];
    managedObjectContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
    return managedObjectContext;
}

- (NSURL *)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.locassa.camra" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    //NSURL *documentDirectoryURL = [fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask][0];
}

#pragma mark - Core Data stack

- (NSManagedObjectModel *)managedObjectModel
{
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    // If the expected store doesn't exist, copy the default store.
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.managedObjectModelFilename]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:self.managedObjectModelFilename withExtension:@"sqlite"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    // Create the nsmanagedobjectmodel
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.managedObjectModelFilename withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSDictionary *persistentStoreCoordinatorOptions = @{ NSSQLitePragmasOption : @{@"journal_mode":@"WAL"},
                                                         NSMigratePersistentStoresAutomaticallyOption: @YES,
                                                         NSInferMappingModelAutomaticallyOption : @YES };
    
    // Check if we need a migration
    // (based on: http://pablin.org/2013/05/24/problems-with-core-data-migration-manager-and-journal-mode-wal/)
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:self.storeURL options:persistentStoreCoordinatorOptions error:&error];
    NSManagedObjectModel *destinationModel = [_persistentStoreCoordinator managedObjectModel];
    BOOL isModelCompatible = (sourceMetadata == nil) || [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
    if (!isModelCompatible) {
        // We need a migration, so we set the journal_mode to DELETE
        persistentStoreCoordinatorOptions = @{ NSMigratePersistentStoresAutomaticallyOption : @YES,
                                               NSInferMappingModelAutomaticallyOption : @YES,
                                               NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}};
    }
    
    NSPersistentStore *persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:persistentStoreCoordinatorOptions error:&error];
    if (! persistentStore) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Reinstate the WAL journal_mode
    if (!isModelCompatible) {
        [_persistentStoreCoordinator removePersistentStore:persistentStore error:NULL];
        persistentStoreCoordinatorOptions = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
                                              NSInferMappingModelAutomaticallyOption:@YES,
                                              NSSQLitePragmasOption: @{@"journal_mode": @"WAL"} };
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:persistentStoreCoordinatorOptions error:&error];
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Misc

- (void)saveIntoMainContext
{
    [self saveIntoContext:self.managedObjectContext];
}

- (BOOL)saveIntoContext:(NSManagedObjectContext*)context
{
    BOOL check = NO;
    
    NSManagedObjectContext *managedObjectContext = (context == nil) ? self.managedObjectContext : context;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        }
        else check = YES;
    }
    
    return check;
}

- (void)saveDataIntoMainContextUsingBlock:(CoreDataStoreSaveCompletion)savedBlock
{
    [self saveDataIntoContext:self.managedObjectContext usingBlock:savedBlock];
}

- (void)saveDataIntoContext:(NSManagedObjectContext*)context usingBlock:(CoreDataStoreSaveCompletion)savedBlock
{
    NSError *saveError = nil;
    
    if (savedBlock) {
        savedBlock([context save:&saveError], saveError);
    }
    else {
        [context save:&saveError];
    }
}

#pragma mark - CRUD

- (id)createEntityWithClassName:(NSString *)className attributesDictionary:(NSDictionary *)attributesDictionary
{
    return [self createEntityWithClassName:className attributesDictionary:attributesDictionary inManagedObjectContext:self.managedObjectContext];
}

- (id)createEntityWithClassName:(NSString *)className
           attributesDictionary:(NSDictionary *)attributesDictionary
         inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:className
                                                            inManagedObjectContext:context];
    [attributesDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSObject *obj, BOOL *stop) {
        if ([obj isValidObject]) {
            [entity setValue:obj forKey:key];
        }
    }];
    
    return entity;
}

- (void)deleteEntity:(NSManagedObject *)entity
{
    [self.managedObjectContext deleteObject:entity];
}

- (void)deleteAllFromEntity:(NSString *)entityName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    NSError *deleteError = nil;
    [self.managedObjectContext executeRequest:delete error:&deleteError];
}

- (void)deleteEntity:(NSManagedObject *)entity inManagedObjectContext:(NSManagedObjectContext *)context
{
    [context deleteObject:entity];
}

- (void)deleteAllFromEntity:(NSString *)entityName inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    NSError *deleteError = nil;
    [context executeRequest:delete error:&deleteError];
}

#pragma mark - Fetches

- (void)fetchEntriesForClassName:(NSString *)className
                   withPredicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors
                 completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock
{
    [self fetchEntriesForClassName:className
                     withPredicate:predicate
                   sortDescriptors:sortDescriptors
              managedObjectContext:self.managedObjectContext
                   completionBlock:completionBlock];
}

- (void)fetchEntriesForClassName:(NSString *)className
                   withPredicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors
            managedObjectContext:(NSManagedObjectContext *)context
                 completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock
{
    [self fetchEntriesForClassName:className
                     withPredicate:predicate
                   sortDescriptors:sortDescriptors
              managedObjectContext:self.managedObjectContext
                      asynchronous:YES
                   completionBlock:completionBlock];
}

- (void)fetchEntriesForClassName:(NSString *)className
                   withPredicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors
            managedObjectContext:(NSManagedObjectContext *)context
                    asynchronous:(BOOL)asynchronous
                 completionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = sortDescriptors;
    if (!context) {
        context = self.managedObjectContext;
    }
    fetchRequest.entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
    
    if (asynchronous) {
        [context performBlock:^{
            NSArray *results = [context executeFetchRequest:fetchRequest error:NULL];
            if (completionBlock) {
                completionBlock(results);
            }
        }];
    }
    else {
        [context performBlockAndWait:^{
            NSArray *results = [context executeFetchRequest:fetchRequest error:NULL];
            if (completionBlock) {
                completionBlock(results);
            }
        }];
    }
}

@end

@implementation CoreDataStore (Parsing)

- (NSManagedObjectContext *)temporaryMOC
{
    return [self setupManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
}

@end

@implementation CoreDataStore (NSFecthedResultsController)

- (BOOL)uniqueAttributeForClassName:(NSString *)className attributeName:(NSString *)attributeName attributeValue:(id)attributeValue
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@", attributeName, attributeValue];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:attributeName ascending:YES]];
    
    NSFetchedResultsController *fetchedResultsController = [self fetchEntitiesWithClassName:className
                                                                                  predicate:predicate
                                                                            sortDescriptors:sortDescriptors
                                                                                  batchSize:0
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];
    return fetchedResultsController.fetchedObjects.count == 0;
}

- (NSFetchedResultsController *)controllerWithEntitiesName:(NSString *)className
                                                 predicate:(NSPredicate *)predicate
                                           sortDescriptors:(NSArray *)sortDescriptors
                                                 batchSize:(NSUInteger)batchSize
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 cacheName:(NSString *)cacheName
{
    NSFetchedResultsController *fetchedResultsController;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.sortDescriptors = sortDescriptors;
    fetchRequest.predicate = predicate;
    fetchRequest.shouldRefreshRefetchedObjects = YES;
    fetchRequest.fetchBatchSize = batchSize;
    //fetchRequest.fetchLimit = fetchLimit;
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:self.managedObjectContext
                                                                     sectionNameKeyPath:sectionNameKeypath
                                                                              cacheName:cacheName];
    
    return fetchedResultsController;
}

- (NSFetchedResultsController *)fetchEntitiesWithClassName:(NSString *)className
                                                 predicate:(NSPredicate *)predicate
                                           sortDescriptors:(NSArray *)sortDescriptors
                                                 batchSize:(NSUInteger)batchSize
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 cacheName:(NSString *)cacheName
{
    NSFetchedResultsController *fetchedResultsController = [self controllerWithEntitiesName:className
                                                                                  predicate:predicate
                                                                            sortDescriptors:sortDescriptors
                                                                                  batchSize:batchSize
                                                                         sectionNameKeyPath:sectionNameKeypath
                                                                                  cacheName:cacheName];
    NSError *error = nil;
    BOOL success = [fetchedResultsController performFetch:&error];
    
    if (!success) {
        NSLog(@"fetchManagedObjectsWithClassName error -> %@", error.description);
    }
    
    return fetchedResultsController;
}

@end
