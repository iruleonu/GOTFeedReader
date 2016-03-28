//
//  LocalServices.h
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IRCoreDataStack;

@interface LocalServices : NSObject

@property (nonatomic, strong, readonly) IRCoreDataStack *coreDataStack;

+ (LocalServices *)instance;

- (void)cleanInternalDB;

@end
