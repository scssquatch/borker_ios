//
//  BorkDetailViewController.h
//  Borker
//
//  Created by Aaron Baker on 10/4/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorkDetailViewController : UIViewController
@property (strong, nonatomic) NSDictionary *bork;
@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) NSString *username;
- (void)setBork:(NSDictionary *)bork;
@end
