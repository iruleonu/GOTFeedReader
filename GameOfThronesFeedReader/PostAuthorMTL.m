//
//  PostAuthorMTL.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "PostAuthorMTL.h"
#import "MTLModel+Extensions.h"
#import "NSString+Extensions.h"
#import "PostAuthorCD.h"

@implementation PostAuthorMTL

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [self dictionaryMapping:@{ @"uuid" : @"id" }];
}

+ (NSValueTransformer *)emailJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *email, BOOL *success, NSError *__autoreleasing *error) {
        NSString *aux = (![email isValidString] || [email isKindOfClass:[NSNull class]]) ? @"" : email;
        return aux;
    } reverseBlock:^id(NSString *email, BOOL *success, NSError *__autoreleasing *error) {
        return email;
    }];
}

#pragma mark - Custom

- (NSString *)getAuthorAvatar {
    NSString *avatarImage;
    NSString *userEmail = (self.firstName) ? self.firstName : @"userhasnofirstname";
    
    avatarImage = [NSString stringWithFormat:@"http://api.adorable.io/avatars/285/%@.png", userEmail];
    
    return avatarImage;
}

- (Class)coreDataCompanionClass {
    return [PostAuthorCD class];
}

@end
