//
//  MainViewControllerTableViewCell.m
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "MainViewControllerTableViewCell.h"
#import "FeedPagedResultsMTL.h"
#import "PostCD.h"
#import "PostAuthorCD.h"
#import "UIImageView+AFNetworking.h"

static NSString * const MainViewControllerTableViewCellEmptyPlaceholder = @"placeholder1";

@interface MainViewControllerTableViewCell ()
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastNameLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end

@implementation MainViewControllerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Add a corner radius to the image view
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2.0f;
    // Apply the mask to the new layer corners
    self.avatarImageView.layer.masksToBounds = YES;
    
    // Keep the aspect ratio of the soon to be added image
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
    self.firstNameLabel.text = [post.author firstName];
    self.lastNameLabel.text = [post.author lastName];
    
    // Start animating and wait for the completion blocks to switch it off
    [self showAndStartNetworkIndicator];
    
    // Do the request using AFNetworking category on top of the UIImageView
    NSString *avatarImage = [post.author getAuthorAvatar];
    [self.avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:avatarImage]]
                              placeholderImage:[UIImage imageNamed:MainViewControllerTableViewCellEmptyPlaceholder]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           self.avatarImageView.image = image;
                                           [self hideAndStopNetworkIndicator];
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           //TODO: set a error image
                                           [self hideAndStopNetworkIndicator];
                                       }];
}

@end
