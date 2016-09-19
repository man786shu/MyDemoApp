//
//  SMGradientView.m
//  SMTestRoposo
//
//  Created by Shubham Mandal on 19/09/16.
//  Copyright © 2016 Shubham Mandal. All rights reserved.
//

#import "SMGradientView.h"

@interface SMGradientView ()

@property (nonatomic, assign) BOOL isNav;

@end
@implementation SMGradientView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat loc2 = 0.5;
    CGFloat location[3] = {0.0, loc2, 1.0};
    if (_isNav)
    {
        CGFloat color[12] = {0.0, 0.0, 0.0,
            0.7,0.0, 0.0, 0.0, 0.4,
            0.0, 0.0, 0.0, 0.0};
        
        CGColorSpaceRef colorSpc = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpc, color, location, 3);
        
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextDrawLinearGradient(c, gradient, (CGPoint) {0.0, 0.0}, (CGPoint) {0.0, rect.size.height}, 0);
        
        CGColorSpaceRelease(colorSpc);
        CGGradientRelease(gradient);
    }
    else
    {
        CGFloat color[12] = {0.0, 0.0, 0.0,
            0.0,0.0, 0.0, 0.0, 0.4,
            0.0, 0.0, 0.0, 0.7};
        CGColorSpaceRef colorSpc = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpc, color, location, 3);
        
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextDrawLinearGradient(c, gradient, (CGPoint) {0.0, 0.0}, (CGPoint) {0.0, rect.size.height}, 0);
        
        CGColorSpaceRelease(colorSpc);
        CGGradientRelease(gradient);
    }
}

- (void)updateDisplay
{
    _isNav = YES;
    [self setNeedsDisplay];
}
@end
