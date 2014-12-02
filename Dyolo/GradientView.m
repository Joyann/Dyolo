//
//  GradientView.m
//  Dyolo
//
//  Created by joyann on 14/12/2.
//  Copyright (c) 2014年 Joyann. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    const CGFloat components[8] = { 0.0f, 0.0f, 0.0f, 0.3f,
                                    0.0f, 0.0f, 0.0f, 0.7f};
    const CGFloat locations[2] = { 0.0f, 1.0f };
    
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, locations, 2);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat startCenterX = CGRectGetMidX(self.bounds);
    CGFloat startCenterY = CGRectGetMidY(self.bounds);
    
    CGFloat endRadius = MAX(startCenterX, startCenterY);
    
    CGPoint drawCenter = CGPointMake(startCenterX, startCenterY);
    
    CGContextDrawRadialGradient(context, gradientRef, drawCenter, 0.0f, drawCenter, endRadius, kCGGradientDrawsAfterEndLocation);
}

@end
