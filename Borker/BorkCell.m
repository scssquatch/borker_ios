    //
//  BorkCell.m
//  Borker
//
//  Created by Neo on 9/16/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkCell.h"
@implementation BorkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self layoutSubviews];
    // Configure the view for the selected state
}
#define FONT_SIZE 14.0f
#define LABEL_CONTENT_WIDTH 195.0f
#define CELL_CONTENT_HEIGHT_TOP_MARGIN 27.0f
#define CELL_CONTENT_WIDTH_LEFT_MARGIN 78.0f
-(void)layoutSubviews
{
    CGSize constraint = CGSizeMake(LABEL_CONTENT_WIDTH, 20000.0f);
    CGSize size = [self.content.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    [self.content setFrame:CGRectMake(CELL_CONTENT_WIDTH_LEFT_MARGIN, CELL_CONTENT_HEIGHT_TOP_MARGIN, LABEL_CONTENT_WIDTH, MAX(size.height, 38.0f))];
}

@end
