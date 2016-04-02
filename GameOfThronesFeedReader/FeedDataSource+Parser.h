//
//  ContactsDataSource+Parser.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "FeedDataSource.h"

@interface FeedDataSource (Parser)

+ (void)parseFeedData:(id)response withCompletion:(FeedDataSourceCompletion)completion;

@end
