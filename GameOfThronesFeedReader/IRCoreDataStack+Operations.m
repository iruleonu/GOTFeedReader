//
//  IRCoreDataStack+Operations.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 28/03/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "IRCoreDataStack+Operations.h"

@implementation IRCoreDataStack (Operations)

- (void)saveIntoMainContext {
    [self saveIntoContext:self.managedObjectContext];
}

- (BOOL)saveIntoContext:(NSManagedObjectContext*)context {
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

- (void)saveDataIntoMainContextUsingBlock:(IRCoreDataStackSaveCompletion)savedBlock {
    [self saveDataIntoContext:self.managedObjectContext usingBlock:savedBlock];
}

- (void)saveDataIntoContext:(NSManagedObjectContext*)context usingBlock:(IRCoreDataStackSaveCompletion)savedBlock {
    NSError *saveError = nil;
    
    if (savedBlock) {
        savedBlock([context save:&saveError], saveError);
    }
    else {
        [context save:&saveError];
    }
}

- (id)createEntityWithClassName:(NSString *)className attributesDictionary:(NSDictionary *)attributesDictionary {
    return [self createEntityWithClassName:className attributesDictionary:attributesDictionary inManagedObjectContext:self.managedObjectContext];
}

- (id)createEntityWithClassName:(NSString *)className
           attributesDictionary:(NSDictionary *)attributesDictionary
         inManagedObjectContext:(NSManagedObjectContext *)context {
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:className
                                                            inManagedObjectContext:context];
    
    for (NSString *key in attributesDictionary.allKeys) {
        NSObject *obj = attributesDictionary[key];
        if ([obj isValidObject]) {
            // Ensure same thread
            [context performBlock:^{
                [entity setValue:obj forKey:key];
            }];
        }
    }
    
    return entity;
}

- (void)deleteEntity:(NSManagedObject *)entity {
    [self.managedObjectContext deleteObject:entity];
}

- (void)deleteAllFromEntity:(NSString *)entityName {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    NSError *deleteError = nil;
    [self.managedObjectContext executeRequest:delete error:&deleteError];
}

- (void)deleteEntity:(NSManagedObject *)entity inManagedObjectContext:(NSManagedObjectContext *)context {
    [context deleteObject:entity];
}

- (void)deleteAllFromEntity:(NSString *)entityName inManagedObjectContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    NSError *deleteError = nil;
    [context executeRequest:delete error:&deleteError];
}

- (void)fetchEntriesForClassName:(NSString *)className
                   withPredicate:(NSPredicate *)predicate
                 sortDescriptors:(NSArray *)sortDescriptors
                 completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock {
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
                 completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock {
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
                 completionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock {
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
