//
//  UndoView.m
//  Borker
//
//  Created by Aaron Baker on 9/30/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "UndoView.h"
@interface UndoView ()
@property (weak, nonatomic) IBOutlet UILabel *undoLabel;
@end
@implementation UndoView

- (id)initWithFrame:(CGRect)frame withBork:(NSDictionary *)bork
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bork = bork;
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"UndoView" owner:self options:nil];
        UIView *mainView = [subviewArray objectAtIndex:0];
        [self addSubview:mainView];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickUndo:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)didClickUndo:(UITapGestureRecognizer *)tapGesture {
    [self.delegate undoView:self];
}
@end
