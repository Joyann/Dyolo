//
//  MovieCell.h
//  Dyolo
//
//  Created by joyann on 14/12/1.
//  Copyright (c) 2014年 Joyann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Movie;

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

- (void)configurateCellWithMovie:(Movie *)movie;

@end
