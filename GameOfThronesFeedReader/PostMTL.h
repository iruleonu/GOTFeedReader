//
//  PostMTL.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MantleToCoreDataProtocol.h"

@class PostAuthorMTL;

@interface PostMTL : MTLModel <MTLJSONSerializing, MantleToCoreDataProtocol>

@property (nonnull, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) PostAuthorMTL *author;
@property (nullable, nonatomic, retain) NSDate *publishOn;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSArray *categories;
@property (nullable, nonatomic, retain) NSArray *tags;
@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSString *excerpt;
@property (nullable, nonatomic, retain) NSNumber *likeCount;
@property (nullable, nonatomic, retain) NSNumber *dislikeCount;
@property (nullable, nonatomic, retain) NSNumber *commentCount;
@property (nullable, nonatomic, retain) NSString *fullUrl;
@property (nullable, nonatomic, retain) NSString *assetUrl;

@end
