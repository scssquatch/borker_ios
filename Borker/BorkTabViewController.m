//
//  BorkTabViewController.m
//  Borker
//
//  Created by Aaron Baker on 10/1/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkTabViewController.h"
#import "BorkUser.h"
#import "BorkCredentials.h"

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
        [self.class logoutCurrentUser];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"constructionNav.png"]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.4 green:0.412 blue:0.588 alpha:1]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor whiteColor]];
    
    [[UITabBarItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
    self.navigationController.navigationBar.hidden = NO;
}

+ (void)logoutCurrentUser
{
    BorkCredentials *creds = [BorkCredentials sharedInstance];
    [creds logOut];
    
}

@end
