//
//  MovieDetailViewController.h
//  Dyolo
//
//  Created by joyann on 14/12/2.
//  Copyright (c) 2014年 Joyann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Movie;
@class DyoloSearchViewController;

typedef NS_ENUM(NSInteger, DetailViewControllerAnimationType) {
    DetailViewControllerAnimationTypeFade,
    DetailViewControllerAnimationTypeSlide
};

@interface MovieDetailViewController : UIViewController

@property (strong, nonatomic) Movie *movie;

- (void)presentInParentViewController:(DyoloSearchViewController *)parentViewController;

@end
