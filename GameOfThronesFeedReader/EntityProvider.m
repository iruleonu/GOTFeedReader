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

- (void)persistPostsFromPostMTLArray:(NSArray *)array withSaveCompletionBlock:(CoreDataStoreSaveCompletion)savedBlock
{
    NSManagedObjectContext *bmoc = self.backgroundManagedObjectContext;
    
    [array enumerateObjectsUsingBlock:^(PostMTL *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block PostCD *mo;
        
        // Post without the author
        PostMTL *auxObj = [obj copy];
        auxObj.author = nil;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@", obj.uuid];
        [PostCD fetchWithPredicate:predicate inManagedObjectContext:bmoc asynchronous:NO completionBlock:^(NSArray *results) {
            mo = [results firstObject];
        }];
        if (!mo) {
            mo = [[CoreDataStore instance] createEntityWithClassName:NSStringFromClass([obj coreDataCompanionClass])
                                                attributesDictionary:[auxObj dictionaryValue]
                                              inManagedObjectContext:bmoc];
        }
        else {
            NSArray *attributes = [auxObj dictionaryValue].allKeys;
            [attributes enumerateObjectsUsingBlock:^(NSString *attrKey, NSUInteger idx, BOOL *stop) {
                NSObject *valueForKey = [auxObj valueForKey:attrKey];
                if ([valueForKey isValidObject]) {
                    [mo setValue:valueForKey forKey:attrKey];
                }
            }];
        }
    }];
    
    [[CoreDataStore instance] saveDataIntoContext:bmoc usingBlock:^(BOOL saved, NSError *error) {
        if (saved) {
            savedBlock(saved, error);
        }
    }];
}

@end
