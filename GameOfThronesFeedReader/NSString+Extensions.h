//
//  NSString+Extensions.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

- (NSString *)trim;
- (BOOL)isValidString;
- (NSString *)stringByStrippingHTML;

@end
