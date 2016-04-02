//
//  LocalServices.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetworkManager, ApiClient, IRCoreDataStack, EntityProvider;

@interface FacadeAPI : NSObject

@property (nonatomic, readonly) NetworkManager *networkManager;
@property (nonatomic, readonly) ApiClient *apiClient;
@property (nonatomic, strong, readonly) IRCoreDataStack *coreDataStack;
@property (nonatomic, strong, readonly) EntityProvider *entityProvider;

+ (FacadeAPI *)sharedInstance;

- (void)cleanInternalDB;

@end
