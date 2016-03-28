//
//  IRCoreDataStack+NSFecthedResultsController.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 28/03/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "IRCoreDataStack+NSFecthedResultsController.h"

@implementation IRCoreDataStack (NSFecthedResultsController)

- (BOOL)uniqueAttributeForClassName:(NSString *)className attributeName:(NSString *)attributeName attributeValue:(id)attributeValue {
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
                                                 cacheName:(NSString *)cacheName {
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
                                                 cacheName:(NSString *)cacheName {
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
