//
//  PostCD.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "PostCD.h"
#import "PostAuthorCD.h"

static NSString *const PostCDFallBackPostAvatar = @"http://api.adorable.io/avatars/285/%posthasnoasset.png/";

@implementation PostCD

// Insert code here to add functionality to your managed object subclass
- (NSString *)getPostAvatar {
    NSString *assetUrl = (self.assetUrl) ? self.assetUrl : PostCDFallBackPostAvatar;
    return assetUrl;
}

@end
