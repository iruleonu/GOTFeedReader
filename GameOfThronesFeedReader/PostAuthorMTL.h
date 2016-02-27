//
//  PostAuthorMTL.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PostAuthorMTL : MTLModel <MTLJSONSerializing>

@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *displayName;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;

- (NSString * _Nonnull)getAuthorAvatar;
- (Class _Nonnull)coreDataCompanionClass;

@end
