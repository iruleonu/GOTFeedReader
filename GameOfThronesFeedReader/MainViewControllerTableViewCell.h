//
//  MainViewControllerTableViewCell.h
//  babylonhealth
//
//  Created by Nuno Salvador on 10/02/2016.
//  Copyright © 2016 Nuno Salvador. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostCD;

@interface MainViewControllerTableViewCell : UITableViewCell

- (void)updateWithPost:(PostCD *)post;

@end
