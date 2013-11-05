//
//  BorkCell.m
//  Borker
//
//  Created by Neo on 9/16/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkCell.h"
#import "BorkAvatarCircleView.h"
@interface BorkCell()

@end
@implementation BorkCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self layoutSubviews];
    // Configure the view for the selected state
}
#define FONT_SIZE 14.0f
#define LABEL_CONTENT_WIDTH 230.0f
#define CELL_CONTENT_HEIGHT_TOP_MARGIN 31.0f
#define CELL_CONTENT_WIDTH_LEFT_MARGIN 12.0f
-(void)layoutSubviews
{
    [self.avatar.layer setMasksToBounds:YES];
    [self.avatar.layer setCornerRadius:15.0f];
    CGSize maximumLabelSize = CGSizeMake(LABEL_CONTENT_WIDTH, FLT_MAX);
    CGRect expectedLabelRect = [self.content.text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithDescriptor:[UIFontDescriptor fontDescriptorWithName:@"AvenirNext-Regular" size:14.0f] size:14.0f]} context:nil];
    CGFloat difference = expectedLabelRect.size.height - 17.0f;

    [self.content setFrame:CGRectMake(CELL_CONTENT_WIDTH_LEFT_MARGIN, CELL_CONTENT_HEIGHT_TOP_MARGIN, LABEL_CONTENT_WIDTH, expectedLabelRect.size.height)];
    [self.contentView setFrame:CGRectMake(0, 0, 320, difference+66.0f)];
}
@end
