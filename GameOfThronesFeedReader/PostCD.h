//
//  PostCD.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PostAuthorCD;

NS_ASSUME_NONNULL_BEGIN

@interface PostCD : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (NSString *)getPostAvatar;

@end

NS_ASSUME_NONNULL_END

#import "PostCD+CoreDataProperties.h"
