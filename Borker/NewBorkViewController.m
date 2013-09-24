//
//  NewBorkViewController.m
//  Borker
//
//  Created by Neo on 9/18/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "NewBorkViewController.h"
#import "BorkNetwork.h"
#import "KeychainItemWrapper.h"

@interface NewBorkViewController ()
@property (weak, nonatomic) IBOutlet UITextField *borkContentField;
@property (weak, nonatomic) IBOutlet UITextView *borkContentView;
@property (strong, nonatomic) BorkNetwork *borkAPI;
@property (strong, nonatomic) KeychainItemWrapper *keychainWrapper;
@end

@implementation NewBorkViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.borkContentView becomeFirstResponder];
    [super viewWillAppear:animated];
}

- (IBAction)createNewBork:(UIBarButtonItem *)sender {
    NSString *bork = self.borkContentField.text;
    if ([BorkNetwork createBork:bork]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)textFieldDidUpdate:(id)sender
{
    self.characterCountLabel.text = [NSString stringWithFormat:@"%i/160", self.borkContentField.text.length];
}

@end
