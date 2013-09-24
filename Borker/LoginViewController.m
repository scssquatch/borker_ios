//
//  LoginViewController.m
//  Borker
//
//  Created by Neo on 9/18/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "LoginViewController.h"
#import "BorkUserNetwork.h"
#import "KeychainItemWrapper.h"

@interface LoginViewController ()
@property (strong, nonatomic) BorkUserNetwork *borkUserRequests;
@property (strong, nonatomic) KeychainItemWrapper *keychainWrapper;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageField;
@end

@implementation LoginViewController


- (KeychainItemWrapper *)keychainWrapper
{
    if (!_keychainWrapper) {
        _keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"borkCredentials" accessGroup:nil];
    }
    return _keychainWrapper;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"gradient-background.png"]];
    if (![[self.keychainWrapper objectForKey:(__bridge id)kSecAttrAccount] isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"login"]) {
        NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        if ([BorkUserNetwork authenticateUser:username withPassword:password]) {
            [self.keychainWrapper setObject:username forKey:(__bridge id)(kSecAttrAccount)];
            return YES;
        } else {
            self.errorMessageField.text = @"Invalid Username or Password";
        }
    }
    return NO;
}
@end
