//
//  LoginViewController.m
//  Borker
//
//  Created by Neo on 9/18/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "BorkUserNetwork.h"
#import "BorkCredentials.h"

@interface LoginViewController ()
@property (strong, nonatomic) BorkUserNetwork *borkUserRequests;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageField;
@property (strong, nonatomic) BorkCredentials *credentials;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.usernameField setValue:[UIColor colorWithRed:151.0/255.0 green:150.0/255.0 blue:180.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordField setValue:[UIColor colorWithRed:151.0/255.0 green:150.0/255.0 blue:180.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 10)];
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 0)];
    self.usernameField.leftView = usernamePaddingView;
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.delegate = self;
    self.passwordField.leftView = passwordPaddingView;
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.credentials = [BorkCredentials sharedInstance];
    if (![[self.credentials username] isEqualToString:@""]) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)dismissKeyboard {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.borderColor = [UIColor colorWithRed:152.0/255.0 green:150.0/255.0 blue:180.0/255.0 alpha:1.0].CGColor;
    textField.layer.borderWidth = 1.0f;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [self logIn:self.loginButton];
    }
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.layer.borderWidth = 0.0f;
}
- (IBAction)logIn:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    [self runSpinAnimationOnView:self.logo duration:1 rotations:1 repeat:15];
    [BorkUserNetwork authenticateUser:username withPassword:password withCallback:^(BOOL authenticated) {
        if (authenticated) {
            [self.credentials setUsername:username];
            [self performSegueWithIdentifier:@"login" sender:self];
        } else {
            self.errorMessageField.text = @"Invalid Username or Password";
        }
        [self.logo.layer removeAllAnimations];
    }];
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    self.logo.layer.anchorPoint = CGPointMake(0.5f, 0.485f);
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
- (IBAction)didClickSignup:(id)sender {
    //nothing so far.. don't really want random people signing up :)
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
}

@end
