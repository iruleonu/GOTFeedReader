//
//  EntityProvider.m
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "EntityProvider.h"
#import "CoreDataStore.h"
#import "NSManagedObject+CoreDataStack.h"
#import "PostMTL.h"
#import "PostCD.h"

@interface EntityProvider ()



@end

@implementation EntityProvider

#pragma mark - initializer

+ (EntityProvider *)instance
{
    static EntityProvider *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[EntityProvider alloc] init];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        [self registerForCoreDataNotifications];
    }
    return self;
}

- (void)registerForCoreDataNotifications {
    // Watch for background managed object context notifications
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      NSManagedObjectContext *moc = self.managedObjectContext;
                                                      if (notification.object != moc) {
                                                          [moc performBlock:^(){
                                                              [moc mergeChangesFromContextDidSaveNotification:notification];
                                                          }];
                                                      }
                                                  }];
    
    // Remove notifications
    [[NSNotificationCenter defaultCenter] addObserverForName:CoreDataStorePurgeUserDataNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *notification) {
                                                      [[NSNotificationCenter defaultCenter] removeObserver:self];
                                                  }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Custom 

- (void)fetchAllPostsWithCompletionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock {
    [PostCD fetchWithPredicate:nil inManagedObjectContext:self.managedObjectContext asynchronous:NO completionBlock:completionBlock];
}

- (void)fetchPostWithManagedObjectID:(id)objectId withCompletionBlock:(CoreDataStoreFetchCompletionBlock)completionBlock {
    NSArray *aux;
    NSError *error;
    
    NSManagedObject *mo = [self.managedObjectContext existingObjectWithID:objectId error:&error];
    aux = (mo) ? @[mo] : @[];
    
    if (completionBlock) {
        completionBlock(aux);
    }
}

- (void)persistEntityFromPostMTLArray:(NSArray *)array withSaveCompletionBlock:(CoreDataStoreSaveCompletion)savedBlock
{
    NSManagedObjectContext *bmoc = self.backgroundManagedObjectContext;
    
    [array enumerateObjectsUsingBlock:^(MTLModel<MantleToCoreDataProtocol> *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block NSManagedObject *mo;
        
        // Update or create a new managed object
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@", [obj uuid]];
        [NSManagedObject fetchWithPredicate:predicate inManagedObjectContext:bmoc asynchronous:NO entityName:NSStringFromClass([obj CDCompanionClass]) completionBlock:^(NSArray *results) {
            mo = [results firstObject];
        }];
        if (!mo) {
            mo = [[CoreDataStore instance] createEntityWithClassName:NSStringFromClass([obj CDCompanionClass])
                                                attributesDictionary:[obj dictionaryWithoutCDRelationships]
                                              inManagedObjectContext:bmoc];
            
            // Do the same for each relationship recursivly
            for (NSString *relationship in [obj CDCompanionClassRelationshipPropertyNames]) {
                SEL selector = NSSelectorFromString(relationship);
                MTLModel<MantleToCoreDataProtocol> *mantleProperty = ((MTLModel<MantleToCoreDataProtocol> *(*)(id, SEL))[obj methodForSelector:selector])(obj, selector);
                
                // Call recursivly and set the relationship in the completion block
                [self persistEntityFromPostMTLArray:@[mantleProperty] withSaveCompletionBlock:^(BOOL saved, NSError *error) {
                    NSPredicate *predicateForTheRelationship = [NSPredicate predicateWithFormat:@"uuid == %@", [mantleProperty uuid]];
                    [NSManagedObject fetchWithPredicate:predicateForTheRelationship
                                 inManagedObjectContext:bmoc
                                           asynchronous:NO
                                             entityName:NSStringFromClass([mantleProperty CDCompanionClass])
                                        completionBlock:^(NSArray *results) {
                                            NSManagedObject *moRelationship = [results firstObject];
                                            [mo setValue:moRelationship forKey:relationship];
                    }];
                }];
            }
        }
        else {
            NSArray *attributes = [obj dictionaryWithoutCDRelationships].allKeys;
            [attributes enumerateObjectsUsingBlock:^(NSString *attrKey, NSUInteger idx, BOOL *stop) {
                NSObject *valueForKey = [obj valueForKey:attrKey];
                if ([valueForKey isValidObject]) {
                    [mo setValue:valueForKey forKey:attrKey];
                }
            }];
            
            // Do the same for each relationship recursivly
            for (NSString *relationship in [obj CDCompanionClassRelationshipPropertyNames]) {
                SEL selector = NSSelectorFromString(relationship);
                MTLModel<MantleToCoreDataProtocol> *mantleProperty = ((MTLModel<MantleToCoreDataProtocol> *(*)(id, SEL))[obj methodForSelector:selector])(obj, selector);
                
                // Call recursivly and set the relationship in the completion block
                [self persistEntityFromPostMTLArray:@[mantleProperty] withSaveCompletionBlock:^(BOOL saved, NSError *error) {
                    NSPredicate *predicateForTheRelationship = [NSPredicate predicateWithFormat:@"uuid == %@", [mantleProperty uuid]];
                    [NSManagedObject fetchWithPredicate:predicateForTheRelationship
                                 inManagedObjectContext:bmoc
                                           asynchronous:NO
                                             entityName:NSStringFromClass([mantleProperty CDCompanionClass])
                                        completionBlock:^(NSArray *results) {
                                            NSManagedObject *moRelationship = [results firstObject];
                                            [mo setValue:moRelationship forKey:relationship];
                                        }];
                }];
            }
        }
    }];
    
    [[CoreDataStore instance] saveDataIntoContext:bmoc usingBlock:^(BOOL saved, NSError *error) {
        if (savedBlock) {
            savedBlock(saved, error);
        }
    }];
}

@end
