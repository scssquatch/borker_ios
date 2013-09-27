//
//  LoginViewController.m
//  Borker
//
//  Created by Neo on 9/18/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "LoginViewController.h"
#import "BorkUserNetwork.h"
#import "BorkCredentials.h"

@interface LoginViewController ()
@property (strong, nonatomic) BorkUserNetwork *borkUserRequests;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageField;
@property (strong, nonatomic) BorkCredentials *credentials;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"gradient-background.png"]];
    self.credentials = [[BorkCredentials alloc] init];
    if (![[self.credentials username] isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"login"]) {
        NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        if ([BorkUserNetwork authenticateUser:username withPassword:password]) {
            [self.credentials setUsername:username];
            return YES;
        } else {
            self.errorMessageField.text = @"Invalid Username or Password";
        }
    }
    return NO;
}
@end
