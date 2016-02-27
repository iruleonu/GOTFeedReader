//
//  PostCD+CoreDataProperties.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PostCD.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCD (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *assetUrl;
@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) id categories;
@property (nullable, nonatomic, retain) NSNumber *commentCount;
@property (nullable, nonatomic, retain) NSNumber *dislikeCount;
@property (nullable, nonatomic, retain) NSString *excerpt;
@property (nullable, nonatomic, retain) NSString *fullUrl;
@property (nullable, nonatomic, retain) NSNumber *likeCount;
@property (nullable, nonatomic, retain) NSDate *publishOn;
@property (nullable, nonatomic, retain) id tags;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) PostAuthorCD *author;

@end

NS_ASSUME_NONNULL_END
