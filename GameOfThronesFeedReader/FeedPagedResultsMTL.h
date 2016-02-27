//
//  ContactMTL.h
//  babylonhealth
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Mantle/Mantle.h>

@class FeedPaginationMTL, PostMTL;

@interface FeedPagedResultsMTL : MTLModel <MTLJSONSerializing>

@property (nullable, nonatomic, retain) FeedPaginationMTL *pagination;
@property (nullable, nonatomic, retain) NSArray<PostMTL *> *items;

@end
