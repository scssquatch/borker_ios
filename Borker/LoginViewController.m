//
//  LoginViewController.m
//  Borker
//
//  Created by Neo on 9/18/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "LoginViewController.h"
#import "BorkUserNetwork.h"
@interface LoginViewController ()
@property (strong, nonatomic) BorkUserNetwork *borkUserRequests;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.borkUserRequests = [[BorkUserNetwork alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"login"]) {
        NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        if ([self.borkUserRequests authenticateUser:username withPassword:password]) {
            return YES;
        }
    }
    return NO;
}
@end
