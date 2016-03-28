//
//  LocalServices.m
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "LocalServices.h"
#import "EntityProvider.h"
#import "IRCoreDataStack+Operations.h"

@interface LocalServices ()

@property (nonatomic, strong, readwrite) IRCoreDataStack *coreDataStack;

@end

@implementation LocalServices

static LocalServices *instance = nil;

+ (LocalServices *)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#pragma mark - Instance Methods

- (instancetype)init {
    self = [super init];
    
    if(self) {
        [self setupLocalServices];
    }
    
    return self;
}

#pragma mark - Private

- (void)cleanInternalDB {
    [self deleteAllEntities:@"PostCD" withCompletionBlock:nil];
    [self deleteAllEntities:@"PostAuthorCD" withCompletionBlock:nil];
}

#pragma mark - Private

- (void)setupLocalServices {
    self.coreDataStack = [[IRCoreDataStack alloc] initWithType:@"NSSQLiteStoreType"
                                                 modelFilename:@"GameOfThronesFeedReader"
                                                      inBundle:[NSBundle mainBundle]];
    [EntityProvider instance].managedObjectContext = self.coreDataStack.managedObjectContext;
    [EntityProvider instance].backgroundManagedObjectContext = self.coreDataStack.backgroundManagedObjectContext;
}

#pragma mark - Custom

- (void)deleteAllEntities:(NSString *)nameEntity withCompletionBlock:(IRCoreDataStackSaveCompletion)savedBlock
{
    NSManagedObjectContext *moc = self.coreDataStack.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects) {
        [moc deleteObject:object];
    }
    
    // Despite this method is called save, actually, from the previous operations, is going to delete the objects
    [self.coreDataStack saveDataIntoContext:moc usingBlock:^(BOOL saved, NSError *error) {
        if (saved && savedBlock) {
            savedBlock(saved, error);
        }
    }];
}

@end
