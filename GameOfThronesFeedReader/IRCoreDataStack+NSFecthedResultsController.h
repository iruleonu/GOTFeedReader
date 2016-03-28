//
//  IRCoreDataStack+NSFecthedResultsController.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 28/03/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "IRCoreDataStack.h"

@interface IRCoreDataStack (NSFecthedResultsController)

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
