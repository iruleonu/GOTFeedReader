//
//  MantleToCoreDataProtocol.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 29/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MantleToCoreDataProtocol <NSObject>

- (NSString * _Nonnull)uuid;

// Name of the CD entity that the class is going to represent
- (Class _Nonnull)CDCompanionClass;

// Name of the properties that are represented has another CD companion class
- (NSArray<NSString *> * _Nonnull)CDCompanionClassRelationshipPropertyNames;

// Dictionary without CD relationships, to import insert to CD without conflicts
- (NSDictionary * _Nonnull)dictionaryWithoutCDRelationships;

// Dictionary representation of the relationships
- (NSDictionary * _Nullable)dictionaryForCDRelationshipPropertyNamed:(NSString * _Nonnull)property;

@end
