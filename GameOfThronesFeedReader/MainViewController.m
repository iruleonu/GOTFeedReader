//
//  MainViewController.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewControllerTableViewCell.h"
#import "FeedPostDetailedViewController.h"
#import "PostCD.h"
#import "PostMTL.h"
#import "EntityProvider.h"
#import "FeedDataSource.h"
#import "PostsDataSourceManager.h"

static NSString *const MainViewControllerTitle = @"GOT News Reader";
static NSString *const MainViewControllerCellIdentifier = @"MainViewControllerCellIdentifier";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, PostsDataSourceManagerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) PostsDataSourceManager *dataSourceManager;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourceManager = [[PostsDataSourceManager alloc] initWithDelegate:self];
    
    [self setupUI];
    
    [self fetchFeed];
}

- (void)setupUI {
    self.title = MainViewControllerTitle;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor darkGrayColor];
    self.refreshControl.tintColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(fetchFeed) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark - Network requests

- (void)fetchFeed {
    __unsafe_unretained typeof(self) weakSelf = self;
    [FeedDataSource feedWithCompletionBlock:^(NSArray *items, NSError *error) {
        MainViewController *strongSelf = weakSelf;
        if (strongSelf) {
            // Save or update to core data
            [[EntityProvider instance] persistEntityFromPostMTLArray:items withSaveCompletionBlock:^(BOOL saved, NSError *error) {
                [self.refreshControl endRefreshing];
            }];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceManager numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainViewControllerCellIdentifier];
    
    PostMTL *post = [self.dataSourceManager modelObjectAtIndexPath:indexPath];
    [cell updateWithPost:post];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PostMTL *post = [self.dataSourceManager modelObjectAtIndexPath:indexPath];
    FeedPostDetailedViewController *vc = [[FeedPostDetailedViewController alloc] initWithPost:post];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - PostsDataSourceManagerDelegate

- (void)managerInsertSectionIndex:(NSUInteger)sectionIndex {
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)managerDeleteSectionIndex:(NSUInteger)sectionIndex {
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)managerInsertRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)managerDeleteRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)managerReloadRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)managerWillChangeContent {
    [self.tableView beginUpdates];
}

- (void)managerDidChangeContent {
    [self.tableView endUpdates];
}

@end