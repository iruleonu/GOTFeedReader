//
//  DataSourceManager.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 29/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "PostsDataSourceManager.h"
#import "PostCD.h"
#import "PostMTL.h"
#import "NSManagedObject+IRCoreDataStack.h"

@interface PostsDataSourceManager () <NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) id <PostsDataSourceManagerDelegate> delegate;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation PostsDataSourceManager

- (instancetype)initWithDelegate:(id<PostsDataSourceManagerDelegate>)delegate {
    if (self = [super init]) {
        self.delegate = delegate;
        self.fetchedResultsController = [PostCD fetchAllSortedBy:@[@"uuid"]
                                                       ascending:YES
                                                       predicate:nil
                                                      fetchLimit:0
                                                  fetchBatchSize:10
                                                         groupBy:nil
                                                        delegate:self];
        
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
    }
    return self;
}

#pragma mark - Custom

- (NSInteger)numberOfSections {
    return 1;
}

- (NSUInteger)numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if ([self.fetchedResultsController sections] > 0) {
        NSArray *sections = [self.fetchedResultsController sections];
        id<NSFetchedResultsSectionInfo> sectionInfo = [sections firstObject];
        rows = [sectionInfo numberOfObjects];
    }
    return rows;
}

- (id)modelObjectAtIndexPath:(NSIndexPath *)indexPath {
    PostCD *postCD = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSError *parseError;
    PostMTL *postMTL = [PostMTL mantleObjectFromCDObject:postCD error:parseError];
    return postMTL;
}

#pragma mark - NSFetchedResultsControllerProtocol

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            if ([self.delegate respondsToSelector:@selector(managerInsertRowAtIndexPath:)]) {
                [self.delegate managerInsertRowAtIndexPath:newIndexPath];
            }
            break;
        case NSFetchedResultsChangeDelete:
            if ([self.delegate respondsToSelector:@selector(managerDeleteRowAtIndexPath:)]) {
                [self.delegate managerDeleteRowAtIndexPath:newIndexPath];
            }
            break;
        case NSFetchedResultsChangeMove:
            if ([self.delegate respondsToSelector:@selector(managerDeleteRowAtIndexPath:)]) {
                [self.delegate managerDeleteRowAtIndexPath:indexPath];
            }
            if ([self.delegate respondsToSelector:@selector(managerInsertRowAtIndexPath:)]) {
                [self.delegate managerInsertRowAtIndexPath:newIndexPath];
            }
            break;
        case NSFetchedResultsChangeUpdate:
            if ([self.delegate respondsToSelector:@selector(managerReloadRowAtIndexPath:)]) {
                [self.delegate managerReloadRowAtIndexPath:indexPath];
            }
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            if ([self.delegate respondsToSelector:@selector(managerInsertSectionIndex:)]) {
                [self.delegate managerInsertSectionIndex:sectionIndex];
            }
            break;
        case NSFetchedResultsChangeDelete:
            if ([self.delegate respondsToSelector:@selector(managerDeleteSectionIndex:)]) {
                [self.delegate managerDeleteSectionIndex:sectionIndex];
            }
            break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
        default:
            break;
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if ([self.delegate respondsToSelector:@selector(managerWillChangeContent)]) {
        [self.delegate managerWillChangeContent];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if ([self.delegate respondsToSelector:@selector(managerDidChangeContent)]) {
        [self.delegate managerDidChangeContent];
    }
}

@end
