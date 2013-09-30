//
//  UndoView.h
//  Borker
//
//  Created by Aaron Baker on 9/30/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UndoView;

@protocol UndoViewDelegate
- (void)undoView:(UndoView *)view;
@end

@interface UndoView : UIView
@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSDictionary *bork;
- (id)initWithFrame:(CGRect)frame withBork:(NSDictionary *)bork;
@end
