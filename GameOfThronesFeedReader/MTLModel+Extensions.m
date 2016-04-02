//
//  MTLModel+Extensions.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 03/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "MTLModel+Extensions.h"

@implementation MTLModel (Extensions)

+ (NSDictionary *)dictionaryMapping:(NSDictionary *)dictionaryMapping {
    return [self dictionaryIgnoringParameters:@[] dictionary:dictionaryMapping];
}

+ (NSDictionary *)dictionaryIgnoringParameters:(NSArray<NSString *> *)parameterNames dictionary:(NSDictionary *)dictionaryMapping {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary mtl_identityPropertyMapWithModel:[self class]]];
    
    for (NSString *parameterName in parameterNames) {
        [dict removeObjectForKey:parameterName];
    }
    
    if (dictionaryMapping) {
        [dict addEntriesFromDictionary:dictionaryMapping];
    }
    
    return dict;
}

#pragma mark - Transformers

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    return dateFormatter;
}

+ (MTLValueTransformer *)unixTimestampToDateTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id date, BOOL *success, NSError *__autoreleasing *error) {
        if ([date isKindOfClass:NSNumber.class]) {
            NSNumber *dateNumber = (NSNumber *)date;
            return [NSDate dateWithTimeIntervalSince1970:([dateNumber doubleValue] / 1000)];
        }
        return [NSDate date];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:[date timeIntervalSince1970] * 1000];
    }];
}

+ (NSValueTransformer *)timestampToDateTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSObject *date, BOOL *success, NSError *__autoreleasing *error) {
        if ([date isKindOfClass:NSNumber.class]) {
            NSNumber *dateNumber = (NSNumber *)date;
            return [NSDate dateWithTimeIntervalSince1970:([dateNumber doubleValue] / 1000)];
        }
        else if ([date isKindOfClass:NSString.class]) {
            NSString *dateString = (NSString *)date;
            return [[self dateFormatter] dateFromString:dateString];
        }
        return [NSDate date];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[self dateFormatter] stringFromDate:date];
    }];
}

@end
