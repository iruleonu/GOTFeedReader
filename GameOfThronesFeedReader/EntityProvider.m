//
//  EntityProvider.m
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "EntityProvider.h"
#import "FacadeAPI.h"
#import "NSManagedObject+IRCoreDataStack.h"
#import "PostMTL.h"
#import "PostCD.h"
#import "IRCoreDataStack+Operations.h"
#import "IRCoreDataStack+NSFecthedResultsController.h"

@interface EntityProvider ()

@property (nonatomic, strong) IRCoreDataStack *coreDataStack;

@end

@implementation EntityProvider

#pragma mark - initializer

+ (EntityProvider *)instance
{
    return [FacadeAPI sharedInstance].entityProvider;
}

- (instancetype)initWithDataProvider:(IRCoreDataStack *)dataProvider {
    if (self = [super init]) {
        self.coreDataStack = dataProvider;
    }
    return self;
}

#pragma mark - Custom 

- (void)fetchAllPostsWithCompletionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock {
    [PostCD fetchWithPredicate:nil inManagedObjectContext:self.coreDataStack.managedObjectContext asynchronous:NO completionBlock:completionBlock];
}

- (void)fetchPostWithManagedObjectID:(id)objectId withCompletionBlock:(IRCoreDataStackFetchCompletionBlock)completionBlock {
    NSArray *aux;
    NSError *error;
    
    NSManagedObject *mo = [self.coreDataStack.managedObjectContext existingObjectWithID:objectId error:&error];
    aux = (mo) ? @[mo] : @[];
    
    if (completionBlock) {
        completionBlock(aux);
    }
}

- (void)persistEntityFromPostMTLArray:(NSArray *)array withSaveCompletionBlock:(IRCoreDataStackSaveCompletion)savedBlock
{
    NSManagedObjectContext *bmoc = self.coreDataStack.backgroundManagedObjectContext;
    
    [array enumerateObjectsUsingBlock:^(MTLModel<MantleToCoreDataProtocol> *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block NSManagedObject *mo;
        
        // Update or create a new managed object
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@", [obj uuid]];
        [NSManagedObject fetchWithPredicate:predicate inManagedObjectContext:bmoc asynchronous:NO entityName:NSStringFromClass([obj CDCompanionClass]) completionBlock:^(NSArray *results) {
            mo = [results firstObject];
        }];
        if (!mo) {
            mo = [self.coreDataStack createEntityWithClassName:NSStringFromClass([obj CDCompanionClass])
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
                    [bmoc performBlock:^{
                        [mo setValue:valueForKey forKey:attrKey];
                    }];
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
    
    [self.coreDataStack saveDataIntoContext:bmoc usingBlock:^(BOOL saved, NSError *error) {
        if (savedBlock) {
            savedBlock(saved, error);
        }
    }];
}

@end
