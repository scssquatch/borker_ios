//
//  BorkAvatarCircleView.m
//  Borker
//
//  Created by Neo on 10/15/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkAvatarCircleView.h"

@interface BorkAvatarCircleView()
@property (assign, nonatomic)CGFloat strokeWidth;
@property (strong, nonatomic)UIColor *strokeColor;
@end

@implementation BorkAvatarCircleView

- (id)initWithFrame:(CGRect)frame withStrokeWidth:(CGFloat)width withColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.strokeWidth = width;
        self.strokeColor = color;
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetAlpha(context, 1.0);
    CGContextFillEllipseInRect(context, CGRectMake(rect.origin.x, rect.origin.y, rect.size.width+self.strokeWidth, rect.size.height+self.strokeWidth));
    CGContextSetLineWidth(context, self.strokeWidth);
    
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    CGContextStrokeEllipseInRect(context, rect);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
