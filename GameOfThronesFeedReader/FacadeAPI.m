//
//  LocalServices.m
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "FacadeAPI.h"
#import "EntityProvider.h"
#import "IRCoreDataStack+Operations.h"

@interface FacadeAPI ()

@property (nonatomic, strong, readwrite) IRCoreDataStack *coreDataStack;
@property (nonatomic, strong, readwrite) EntityProvider *entityProvider;

@end

@implementation FacadeAPI

static FacadeAPI *instance = nil;

+ (FacadeAPI *)sharedInstance {
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
    self.entityProvider = [[EntityProvider alloc] initWithDataProvider:self.coreDataStack];
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
