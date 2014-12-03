//
//  MovieDetailViewController.m
//  Dyolo
//
//  Created by joyann on 14/12/2.
//  Copyright (c) 2014年 Joyann. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "DyoloSearchViewController.h"
#import "Movie.h"
#import "GradientView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MovieDetailViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieAverageRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieActorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieCollectCountLabel;

@property (strong, nonatomic) GradientView *gradientView;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.popupView.layer.cornerRadius = 10.0f;
    
    // Add tap gesture.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClosed)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    // Update UI.
    [self updateUI];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.view) {
        return YES;
    }
    return NO;
}

#pragma mark - UpdateUI

- (void)updateUI
{
    self.movieTitleLabel.text = self.movie.title;
    self.movieActorsLabel.text = self.movie.actorName;
    self.movieAverageRatingLabel.text = [NSString stringWithFormat:@"%@",self.movie.averageRating];
    self.movieYearLabel.text = [NSString stringWithFormat:@"%@",self.movie.year];
    self.movieCollectCountLabel.text = [NSString stringWithFormat:@"%@",self.movie.collectCount];
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:self.movie.mediumImageURL] placeholderImage:nil];
}

#pragma mark - Action

- (IBAction)buttonClosed:(UIButton *)sender
{
    [self dismissPopupViewWithAnimationType:DetailViewControllerAnimationTypeFade];
}

- (void)tapClosed
{
    [self dismissPopupViewWithAnimationType:DetailViewControllerAnimationTypeSlide];
}

- (void)dismissPopupViewWithAnimationType:(DetailViewControllerAnimationType)animationType
{
    [self willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         if (animationType == DetailViewControllerAnimationTypeSlide) {
                             self.gradientView.alpha = 0.0f;
                             CGRect rect = self.view.frame;
                             rect.origin.y += self.view.bounds.size.height;
                             self.view.frame = rect;
                         } else if (animationType == DetailViewControllerAnimationTypeFade) {
                             self.view.alpha = 0.0f;
                             self.gradientView.alpha = 0.0f;
                         }
                     } completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                         [self.gradientView removeFromSuperview];
                     }];
    
}

#pragma mark - PresentInParentViewController

- (void)presentInParentViewController:(DyoloSearchViewController *)parentViewController
{
    self.gradientView = [[GradientView alloc] initWithFrame:self.view.bounds];
    [parentViewController.view addSubview:self.gradientView];
    
    self.view.bounds = parentViewController.view.bounds;
    
    [parentViewController.view addSubview:self.view];
    [parentViewController addChildViewController:self];
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = @[@0.7, @1.4, @0.4, @1.0];
    bounceAnimation.keyTimes = @[@0.0, @0.334, @0.667, @1.0];
    bounceAnimation.duration = 0.4f;
    bounceAnimation.delegate = self;
    bounceAnimation.timingFunctions = @[
       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
       [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.duration = 0.4f;
    fadeAnimation.fromValue = @0.0f;
    fadeAnimation.toValue = @1.0f;
    
    [self.gradientView.layer addAnimation:fadeAnimation forKey:@"FadeAnimation"];
    [self.view.layer addAnimation:bounceAnimation forKey:@"BounceAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self didMoveToParentViewController:self.parentViewController];
}


@end
