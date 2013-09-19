//
//  NewBorkViewController.m
//  Borker
//
//  Created by Neo on 9/18/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "NewBorkViewController.h"
#import "BorkNetwork.h"

@interface NewBorkViewController ()
@property (weak, nonatomic) IBOutlet UITextView *borkContentField;
@property (strong, nonatomic) BorkNetwork *borkAPI;
@end

@implementation NewBorkViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Cancel";
    [self.borkContentField becomeFirstResponder];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)createNewBork:(UIBarButtonItem *)sender {
    NSString *bork = self.borkContentField.text;
    [self.borkAPI createBork:bork];
}

@end
