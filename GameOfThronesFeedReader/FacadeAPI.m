//
//  LocalServices.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "FacadeAPI.h"
#import "Networking.h"
#import "NetworkManager.h"
#import "ApiClient.h"
#import "EntityProvider.h"

@interface FacadeAPI ()

@property (nonatomic, strong, readwrite) NetworkManager *networkManager;
@property (nonatomic, strong, readwrite) ApiClient *apiClient;
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
    // Network
    self.networkManager = [[NetworkManager alloc] initWithBaseUrl:BASE_URL];
    self.apiClient = [[ApiClient alloc] initWithNetworkManager:self.networkManager];
    
    // Core data
    self.coreDataStack = [[IRCoreDataStack alloc] initWithType:NSSQLiteStoreType
                                                 modelFilename:@"GameOfThronesFeedReader"
                                                      inBundle:[NSBundle mainBundle]];
    self.entityProvider = [[EntityProvider alloc] initWithDataProvider:self.coreDataStack];
}

#pragma mark - Custom

- (void)deleteAllEntities:(NSString *)nameEntity withCompletionBlock:(IRCoreDataStackSaveCompletion)savedBlock {
    NSManagedObjectContext *bmoc = self.coreDataStack.backgroundManagedObjectContext;
    [self.coreDataStack deleteAllFromEntity:nameEntity inManagedObjectContext:bmoc];
    
    // Despite this method is called save, actually, from the previous operations, is going to delete the objects
    [self.coreDataStack saveIntoContext:bmoc usingBlock:^(BOOL saved, NSError *error) {
        if (savedBlock) {
            savedBlock(saved, error);
        }
    }];
}

@end
