//
//  PostAuthorCD.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "PostAuthorCD.h"

@implementation PostAuthorCD

// Insert code here to add functionality to your managed object subclass
- (NSString *)getAuthorAvatar {
    NSString *avatarImage;
    NSString *userEmail = (self.firstName) ? self.firstName : @"userhasnofirstname";
    
    avatarImage = [NSString stringWithFormat:@"http://api.adorable.io/avatars/285/%@.png", userEmail];
    
    return avatarImage;
}

@end
