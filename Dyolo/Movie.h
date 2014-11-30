//
//  Movie.h
//  Dyolo
//
//  Created by joyann on 14/11/30.
//  Copyright (c) 2014年 Joyann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSNumber *averageRating;
@property (copy, nonatomic) NSString *genres;
@property (copy, nonatomic) NSString *actorName;
@property (copy, nonatomic) NSString *directorsName;
@property (copy, nonatomic) NSString *subtype;
@property (copy, nonatomic) NSString *year;
@property (copy, nonatomic) NSNumber *collectCount;
@property (copy, nonatomic) NSString *smallImageURL;
@property (copy, nonatomic) NSString *mediumImageURL;
@property (copy, nonatomic) NSString *largeImageURL;
@property (copy, nonatomic) NSString *movieURL;

+ (instancetype)MovieWithMovieDic:(NSDictionary *)movieDic;
- (instancetype)initWithMovieDic:(NSDictionary *)movieDic;

@end
