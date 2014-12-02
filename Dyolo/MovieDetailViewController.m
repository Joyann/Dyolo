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

@interface MovieDetailViewController ()

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
    
    [self updateUI];
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
    [self dismissPopupView];
}

- (void)dismissPopupView
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    [self.gradientView removeFromSuperview];
}

#pragma mark - PresentInParentViewController

- (void)presentInParentViewController:(DyoloSearchViewController *)parentViewController
{
    self.gradientView = [[GradientView alloc] initWithFrame:self.view.bounds];
    [parentViewController.view addSubview:self.gradientView];
    
    self.view.bounds = parentViewController.view.bounds;
    [parentViewController.view addSubview:self.view];
    [parentViewController addChildViewController:self];
    [self didMoveToParentViewController:parentViewController];
}


@end
