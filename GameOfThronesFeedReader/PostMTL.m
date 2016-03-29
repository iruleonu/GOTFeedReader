//
//  PostMTL.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "PostMTL.h"
#import "MTLModel+Extensions.h"
#import "PostCD.h"
#import "PostAuthorMTL.h"

static NSString *const PostMTLFallBackPostAvatar = @"http://api.adorable.io/avatars/285/%posthasnoasset.png/";

@implementation PostMTL

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [self dictionaryMapping:@{ @"uuid" : @"id" }];
}

+ (NSValueTransformer *)authorJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:PostAuthorMTL.class];
}

+ (NSValueTransformer *)publishOnJSONTransformer {
    return [self timestampToDateTransformer];
}

#pragma mark - MantleToCoreDataProtocol

+ (instancetype _Nullable)mantleObjectFromCDObject:(NSManagedObject * _Nullable)cdObject error:(NSError * _Nullable)error {
    if (![cdObject isKindOfClass:[self CDCompanionClass]]) {
        return nil;
    }
    
    NSArray *keys = cdObject.entity.attributesByName.allKeys;
    NSDictionary *dict = [cdObject dictionaryWithValuesForKeys:keys];
    NSError *parseError;
    
    return [MTLJSONAdapter modelOfClass:[self class]
                     fromJSONDictionary:dict
                                  error:&parseError];
}

+ (Class)CDCompanionClass {
    return [PostCD class];
}

- (Class)CDCompanionClass {
    return [PostCD class];
}

- (NSArray<NSString *> * _Nonnull)CDCompanionClassRelationshipPropertyNames {
    return @[@"author"];
}

- (NSDictionary * _Nonnull)dictionaryWithoutCDRelationships {
    NSMutableDictionary *aux = [NSMutableDictionary dictionaryWithDictionary:[self dictionaryValue]];
    
    for (NSString *relationshipName in [self CDCompanionClassRelationshipPropertyNames]) {
        [aux removeObjectForKey:relationshipName];
    }
    
    return [aux mutableCopy];
}

- (NSDictionary * _Nullable)dictionaryForCDRelationshipPropertyNamed:(NSString * _Nonnull)property {
    NSDictionary *aux = nil;
    NSDictionary *dictionaryRepresentation = [self dictionaryValue];
    
    // Try to find the property
    if ([dictionaryRepresentation objectForKey:property]) {
        NSObject *mantleProperty = [dictionaryRepresentation objectForKey:property];
        
        // Introspection
        if ([mantleProperty isKindOfClass:[MTLModel class]]) {
            MTLModel *cast = (MTLModel *)mantleProperty;
            
            // Try to grab the dictionaryWithoutCDRelationships version.
            // If not, use the normal dictionaryValue method
            if ([cast conformsToProtocol:@protocol(MantleToCoreDataProtocol)]) {
                aux = [cast performSelector:@selector(dictionaryWithoutCDRelationships)];
            }
            else {
                aux = [cast dictionaryValue];
            }
        }
    }
    
    return [aux mutableCopy];
}

#pragma mark - Custom

- (NSString *)getPostAvatar {
    NSString *assetUrl = (self.assetUrl) ? self.assetUrl : PostMTLFallBackPostAvatar;
    return assetUrl;
}

@end
