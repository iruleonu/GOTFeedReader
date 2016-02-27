//
//  FeedPostDetailedViewController.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "FeedPostDetailedViewController.h"
#import "EntityProvider.h"
#import "PostCD.h"
#import "PostAuthorCD.h"
#import "UIImageView+AFNetworking.h"

static NSString * const FeedPostDetailedViewControllerEmptyPlaceholder = @"placeholder1";

@interface FeedPostDetailedViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet UILabel *updatedAt;

@end

@implementation FeedPostDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[EntityProvider instance] fetchPostWithManagedObjectID:self.postId withCompletionBlock:^(NSArray *results) {
        [self updateWithPost:[results firstObject]];
    }];
}

#pragma mark - Setup

- (void)showAndStartNetworkIndicator {
    [self.activityIndicatorView startAnimating];
    self.activityIndicatorView.alpha = 1.0f;
}

- (void)hideAndStopNetworkIndicator {
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.alpha = 0.0f;
}

- (void)updateWithPost:(PostCD *)post {
    if (post) {
//        self.fullNameLabel.text = [NSString stringWithFormat:@"%@ %@", [contact firstName], [contact surname]];
//        self.addressLabel.text = [NSString stringWithFormat:@"%@", [contact address]];
//        self.emailLabel.text = [NSString stringWithFormat:@"%@", [contact email]];
//        self.phoneNumberLabel.text = [NSString stringWithFormat:@"%@", [contact phoneNumber]];
//        self.createdAt.text = [NSString stringWithFormat:@"%@", [contact createdAt]];
//        self.updatedAt.text = [NSString stringWithFormat:@"%@", [contact updatedAt]];
        
        // Do the request using AFNetworking category on top of the UIImageView
        NSString *avatarImage = [post.author getAuthorAvatar];
        [self.avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:avatarImage]]
                                    placeholderImage:[UIImage imageNamed:FeedPostDetailedViewControllerEmptyPlaceholder]
                                             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                 self.avatarImageView.image = image;
                                                 [self hideAndStopNetworkIndicator];
                                             }
                                             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                 //TODO: set a error image
                                                 [self hideAndStopNetworkIndicator];
                                             }];
        
        [self.view setNeedsLayout];
    }
}

@end
