//
//  Movie.m
//  Dyolo
//
//  Created by joyann on 14/11/30.
//  Copyright (c) 2014年 Joyann. All rights reserved.
//

#import "Movie.h"

@implementation Movie

+ (instancetype)MovieWithMovieDic:(NSDictionary *)movieDic;
{
    return [[self alloc] initWithMovieDic:movieDic];
}

- (instancetype)initWithMovieDic:(NSDictionary *)movieDic
{
    self = [super init];
    
    if (self) {
        // Rating.
        double rating = [[movieDic valueForKeyPath:@"rating.average"] doubleValue];
        self.averageRating = [NSNumber numberWithFloat:[[NSString stringWithFormat:@"%.2f",rating] floatValue]];
        
        // Genres.
        NSArray *genres = movieDic[@"genres"];
        self.genres = [genres componentsJoinedByString:@", "];
        
        // CollectCount.
        self.collectCount = movieDic[@"collect_count"];
        
        // ActorNames.
        NSArray *casts = movieDic[@"casts"];
        NSMutableArray *castNames = [[NSMutableArray alloc] init];
        for (NSDictionary *cast in casts) {
            NSString *castName = cast[@"name"];
            [castNames addObject:castName];
        }
        self.actorName = [castNames componentsJoinedByString:@", "];
        
        // Title.
        self.title = movieDic[@"title"];
        
        // Subtype.
        self.subtype = movieDic[@"subtype"];
        
        // DirectorNames.
        NSArray *directors = movieDic[@"directors"];
        NSMutableArray *directorNames = [[NSMutableArray alloc] init];
        for (NSDictionary *director in directors) {
            NSString *directorName = director[@"name"];
            [directorNames addObject:directorName];
        }
        self.directorsName = [directorNames componentsJoinedByString:@", "];
        
        // Year.
        self.year = movieDic[@"year"];
        
        // SmallImageURL.
        self.smallImageURL = [movieDic valueForKeyPath:@"images.small"];
        
        // MediumImageURL.
        self.mediumImageURL = [movieDic valueForKeyPath:@"images.medium"];
        
        // LargeImageURL.
        self.largeImageURL = [movieDic valueForKeyPath:@"images.large"];
        
        // MovieURL.
        self.movieURL = movieDic[@"alt"];
    }
    return self;
}

#pragma mark - SortedByAverageRating

- (NSComparisonResult)sortedByAverageRating:(Movie *)otherMovie
{
    return [[otherMovie.averageRating stringValue] localizedStandardCompare:[self.averageRating stringValue]];
}

@end
