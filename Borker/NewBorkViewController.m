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
@property (weak, nonatomic) IBOutlet UITextView *borkContentField;
@property (strong, nonatomic) BorkNetwork *borkAPI;
@property (strong, nonatomic) KeychainItemWrapper *keychainWrapper;
@end

@implementation NewBorkViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.borkAPI = [[BorkNetwork alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.borkContentField becomeFirstResponder];
    [super viewWillAppear:animated];
}

- (IBAction)createNewBork:(UIBarButtonItem *)sender {
    NSString *bork = self.borkContentField.text;
    if ([self.borkAPI createBork:bork]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        
    }
}

@end
