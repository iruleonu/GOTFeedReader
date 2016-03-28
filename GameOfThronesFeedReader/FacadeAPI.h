//
//  LocalServices.h
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRCoreDataStack, EntityProvider;

@interface FacadeAPI : NSObject

@property (nonatomic, strong, readonly) IRCoreDataStack *coreDataStack;
@property (nonatomic, strong, readonly) EntityProvider *entityProvider;

+ (FacadeAPI *)sharedInstance;

- (void)cleanInternalDB;

@end
