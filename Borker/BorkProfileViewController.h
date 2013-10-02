//
//  BorkProfileViewController.h
//  Borker
//
//  Created by Aaron Baker on 10/1/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCSwipeTableViewCell.h"
#import "UndoView.h"

@interface BorkProfileViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, MCSwipeTableViewCellDelegate, UndoViewDelegate>
@end
