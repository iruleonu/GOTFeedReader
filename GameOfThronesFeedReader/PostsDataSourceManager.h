//
//  DataSourceManager.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 29/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PostsDataSourceManagerDelegate <NSObject>

- (void)managerInsertSectionIndex:(NSUInteger)sectionIndex;
- (void)managerDeleteSectionIndex:(NSUInteger)sectionIndex;
- (void)managerInsertRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)managerDeleteRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)managerReloadRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)managerWillChangeContent;
- (void)managerDidChangeContent;

@end

@interface PostsDataSourceManager : NSObject

- (instancetype)initWithDelegate:(id<PostsDataSourceManagerDelegate>)delegate;

- (NSInteger)numberOfSections;
- (NSUInteger)numberOfRowsInSection:(NSInteger)section;
- (id)modelObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
