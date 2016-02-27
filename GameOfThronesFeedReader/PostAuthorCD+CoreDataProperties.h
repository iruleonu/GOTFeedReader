//
//  PostAuthorCD+CoreDataProperties.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PostAuthorCD.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostAuthorCD (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *displayName;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSSet<PostCD *> *posts;

@end

@interface PostAuthorCD (CoreDataGeneratedAccessors)

- (void)addPostsObject:(PostCD *)value;
- (void)removePostsObject:(PostCD *)value;
- (void)addPosts:(NSSet<PostCD *> *)values;
- (void)removePosts:(NSSet<PostCD *> *)values;

@end

NS_ASSUME_NONNULL_END
