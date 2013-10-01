//
//  BorkTabViewController.m
//  Borker
//
//  Created by Aaron Baker on 10/1/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkTabViewController.h"
#import "BorkUser.h"

@interface BorkTabViewController ()

@end

@implementation BorkTabViewController

- (IBAction)logoutUser:(id)sender {
       UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Leaving Confirmation"
                          message:@"Are you sure you want to log out?"
                          delegate:self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [BorkUser logoutCurrentUser];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
