//
//  MTLModel+Extensions.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MTLModel (Extensions)

+ (NSDictionary *)dictionaryMapping:(NSDictionary *)dictionaryMapping;
+ (NSDictionary *)dictionaryIgnoringParameters:(NSArray<NSString *> *)parameterNames dictionary:(NSDictionary *)dictionaryMapping;

#pragma mark - Transformers

+ (NSDateFormatter *)dateFormatter;
+ (MTLValueTransformer *)unixTimestampToDateTransformer;
+ (NSValueTransformer *)timestampToDateTransformer;

@end
