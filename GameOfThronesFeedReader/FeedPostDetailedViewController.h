//
//  FeedPostDetailedViewController.h
//  GameOfThronesFeedReader
//
//  Created by Nuno Salvador on 27/02/16.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostMTL;

@interface FeedPostDetailedViewController : UIViewController

- (instancetype)initWithPost:(PostMTL *)post;

@end
