//
//  NotificationCell.m
//  Borker
//
//  Created by Aaron Baker on 10/1/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self layoutSubviews];
}

#define FONT_SIZE 14.0f
#define LABEL_CONTENT_WIDTH 310.0f
#define CELL_CONTENT_HEIGHT_TOP_MARGIN 5.0f
#define CELL_CONTENT_WIDTH_LEFT_MARGIN 5.0f
- (void)layoutSubviews
{
    CGSize constraint = CGSizeMake(LABEL_CONTENT_WIDTH, 20000.0f);
    CGSize size = [self.content.text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    [self.content setFrame:CGRectMake(CELL_CONTENT_WIDTH_LEFT_MARGIN, CELL_CONTENT_HEIGHT_TOP_MARGIN, LABEL_CONTENT_WIDTH, MAX(size.height, 38.0f))];
}

@end
