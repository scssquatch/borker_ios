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
@end

@implementation LoginViewController


- (KeychainItemWrapper *)keychainWrapper
{
    if (!_keychainWrapper) {
        _keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"borkCredentials" accessGroup:nil];
    }
    return _keychainWrapper;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.borkUserRequests = [[BorkUserNetwork alloc] init];
    if ([self.keychainWrapper objectForKey:(__bridge id)kSecAttrCreator]) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"login"]) {
        NSString *username = self.usernameField.text;
        NSString *password = self.passwordField.text;
        if ([self.borkUserRequests authenticateUser:username withPassword:password]) {
            [self.keychainWrapper setObject:username forKey:(__bridge id)(kSecAttrCreator)];
            return YES;
        }
    }
    return NO;
}
@end
