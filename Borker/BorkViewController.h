//
//  BorkViewController.h
//  Borker
//
//  Created by Neo on 9/16/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"
#import "UndoView.h"

@interface BorkViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, MCSwipeTableViewCellDelegate, UndoViewDelegate>
@property (strong, nonatomic) NSArray *borks;
@end
