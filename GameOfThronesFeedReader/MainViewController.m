//
//  MainViewController.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "MainViewController.h"
#import "UIColor+GameOfThronesFeedReader.h"
#import "ApiClient+Feed.h"
#import "MainViewControllerTableViewCell.h"
#import "FeedPostDetailedViewController.h"
#import "FeedPagedResultsMTL.h"
#import "PostCD.h"
#import "EntityProvider.h"
#import "FeedDataSource.h"

static NSString *const MainViewControllerTitle = @"Feed Reader";
static NSString *const MainViewControllerCellIdentifier = @"MainViewControllerCellIdentifier";

@interface MainViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *posts;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = MainViewControllerTitle;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // KittenNode has its own separator
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [FeedDataSource feedWithCompletionBlock:^(NSArray *products, NSError *error) {
        MainViewController *strongSelf = weakSelf;
        if (strongSelf) {
            // Save or update to core data
            [[EntityProvider instance] persistPostsFromPostMTLArray:products withSaveCompletionBlock:^(BOOL saved, NSError *error) {
                // Fetch them
                [[EntityProvider instance] fetchAllPostsWithCompletionBlock:^(NSArray *results) {
                    strongSelf.posts = results;
                    // Reload the table view with the new contacts
                    [strongSelf.tableView reloadData];
                }];
            }];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainViewControllerCellIdentifier];
    [cell updateWithPost:self.posts[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FeedPostDetailedViewController *vc = [[FeedPostDetailedViewController alloc] initWithNibName:NSStringFromClass([FeedPostDetailedViewController class]) bundle:nil];
    PostCD *post = self.posts[indexPath.row];
    vc.postId = post.objectID;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end