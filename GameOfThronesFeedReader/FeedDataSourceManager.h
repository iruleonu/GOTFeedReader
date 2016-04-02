//
//  DataSourceManager.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 29/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FeedDataSourceManagerDelegate <NSObject>

- (void)managerInsertSectionIndex:(NSUInteger)sectionIndex;
- (void)managerDeleteSectionIndex:(NSUInteger)sectionIndex;
- (void)managerInsertRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)managerDeleteRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)managerReloadRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)managerWillChangeContent;
- (void)managerDidChangeContent;

@end

@interface FeedDataSourceManager : NSObject

- (instancetype)initWithDataStore:(IRCoreDataStack *)dataStore delegate:(id<FeedDataSourceManagerDelegate>)delegate;

- (NSInteger)numberOfSections;
- (NSUInteger)numberOfRowsInSection:(NSInteger)section;
- (id)modelObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
