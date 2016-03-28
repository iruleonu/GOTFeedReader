//
//  FeedPostDetailedViewController.m
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import "FeedPostDetailedViewController.h"
#import "EntityProvider.h"
#import "PostMTL.h"
#import "UIImageView+AFNetworking.h"

static NSString * const FeedPostDetailedViewControllerEmptyPlaceholder = @"placeholder1";

@interface FeedPostDetailedViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property (nonatomic, strong) PostMTL *post;

@end

@implementation FeedPostDetailedViewController

- (instancetype)initWithPost:(PostMTL *)post {
    if (self = [self initWithNibName:NSStringFromClass([FeedPostDetailedViewController class]) bundle:nil]) {
        self.post = post;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self updateWithPost:self.post];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

- (void)updateWithPost:(PostMTL *)post {
    if (post) {
        self.titleLabel.text = [post title];
        self.bodyTextView.text = [[[post body] stringByStrippingHTML] trim];
        
        NSMutableString *tags = [NSMutableString string];
        for (NSString *tag in [post tags]) {
            [tags appendString:[NSString stringWithFormat:@" %@", tag]];
        }
        self.tagsLabel.text = tags;
        
        // Do the request using AFNetworking category on top of the UIImageView
        NSString *avatarImage = [post getPostAvatar];
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
