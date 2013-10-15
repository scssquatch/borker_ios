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
    self.bubbleView.layer.shadowOffset = CGSizeMake(0, 1);
    self.bubbleView.layer.shadowOpacity = 0.75;
    self.bubbleView.layer.shadowRadius = 1.0;
    self.bubbleView.clipsToBounds = NO;
    [self layoutSubviews];
    // Configure the view for the selected state
}
#define FONT_SIZE 14.0f
#define LABEL_CONTENT_WIDTH 191.0f
#define CELL_CONTENT_HEIGHT_TOP_MARGIN 31.0f
#define CELL_CONTENT_WIDTH_LEFT_MARGIN 12.0f
-(void)layoutSubviews
{
    BorkAvatarCircleView *circleView = [[BorkAvatarCircleView alloc] initWithFrame:CGRectMake(10, 5, 37, 37)];
    [self addSubview: circleView];
    
    CGSize maximumLabelSize = CGSizeMake(LABEL_CONTENT_WIDTH, FLT_MAX);
    CGRect expectedLabelRect = [self.content.text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithDescriptor:[UIFontDescriptor fontDescriptorWithName:@"AvenirNext-Regular" size:14.0f] size:14.0f]} context:nil];
    CGFloat difference = expectedLabelRect.size.height - 17.0f;
    
    [self.content setFrame:CGRectMake(CELL_CONTENT_WIDTH_LEFT_MARGIN, CELL_CONTENT_HEIGHT_TOP_MARGIN, LABEL_CONTENT_WIDTH, expectedLabelRect.size.height)];
    NSLog(@"content height = %f", self.content.frame.size.height);
    NSLog(@"cell height = %f", self.contentView.frame.size.height);
    [self.contentView setFrame:CGRectMake(0, 0, 320, difference+62.0f)];
}

@end
