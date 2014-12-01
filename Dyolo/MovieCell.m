//
//  MovieCell.m
//  Dyolo
//
//  Created by joyann on 14/12/1.
//  Copyright (c) 2014年 Joyann. All rights reserved.
//

#import "MovieCell.h"
#import "Movie.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation MovieCell

- (void)awakeFromNib
{
    // Initialization code
}


- (void)configurateCellWithMovie:(Movie *)movie
{
    self.titleLabel.text = movie.title;
    self.ratingLabel.text = [NSString stringWithFormat:@"评分:%@",movie.averageRating];
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:movie.smallImageURL] placeholderImage:nil];
}


@end
