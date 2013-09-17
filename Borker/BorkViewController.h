//
//  BorkViewController.h
//  Borker
//
//  Created by Neo on 9/16/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorkViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *borks;
@end
