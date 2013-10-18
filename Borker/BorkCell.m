//
//  BorkCell.m
//  Borker
//
//  Created by Neo on 9/16/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkCell.h"
#import "BorkAvatarCircleView.h"
@implementation BorkCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self layoutSubviews];
    // Configure the view for the selected state
}
#define FONT_SIZE 14.0f
#define LABEL_CONTENT_WIDTH 191.0f
#define CELL_CONTENT_HEIGHT_TOP_MARGIN 31.0f
#define CELL_CONTENT_WIDTH_LEFT_MARGIN 12.0f
-(void)layoutSubviews
{
//    [self addShadow:self.bubbleView.frame];
    CGFloat radius = 18.0f;
    CGFloat xCenter = 27.0f;
    CGFloat yCenter = 22.0f;
    
    CGRect circle;
    circle.origin.x = xCenter - radius;
    circle.origin.y = yCenter - radius;
    circle.size.width = 2*radius;
    circle.size.height = 2*radius;
    
    BorkAvatarCircleView *circleView = [[BorkAvatarCircleView alloc] initWithFrame:circle withStrokeWidth:6.0f withColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
    BorkAvatarCircleView *secondCircleView = [[BorkAvatarCircleView alloc] initWithFrame:circle withStrokeWidth:2.0f withColor:[UIColor colorWithRed:0.89f green:0.90f blue:0.91f alpha:1.00f]];
    [self addSubview: circleView];
    [self addSubview: secondCircleView];
    
    [self bringSubviewToFront:circleView];
    [self bringSubviewToFront:secondCircleView];
    
    CGSize maximumLabelSize = CGSizeMake(LABEL_CONTENT_WIDTH, FLT_MAX);
    CGRect expectedLabelRect = [self.content.text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithDescriptor:[UIFontDescriptor fontDescriptorWithName:@"AvenirNext-Regular" size:14.0f] size:14.0f]} context:nil];
    CGFloat difference = expectedLabelRect.size.height - 17.0f;
    
    [self.content setFrame:CGRectMake(CELL_CONTENT_WIDTH_LEFT_MARGIN, CELL_CONTENT_HEIGHT_TOP_MARGIN, LABEL_CONTENT_WIDTH, expectedLabelRect.size.height)];
    NSLog(@"content height = %f", self.content.frame.size.height);
    NSLog(@"cell height = %f", self.contentView.frame.size.height);
    [self.contentView setFrame:CGRectMake(0, 0, 320, difference+62.0f)];
}

//- (void)addShadow:(CGRect)rect
//{
//    CGPathRef path = [UIBezierPath bezierPathWithRect:rect].CGPath;
//    [self.bubbleView.layer setShadowPath:path];
//    self.bubbleView.layer.shadowOpacity = 0.5;
////    self.bubbleView.layer.shadowRadius = 1.0;
////    self.bubbleView.clipsToBounds = NO;
//}

@end
