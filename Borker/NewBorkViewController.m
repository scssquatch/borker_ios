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
    NSString *bork = self.borkContentView.text;
    if ([BorkNetwork createBork:bork]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        self.characterCountLabel.text = [NSString stringWithFormat:@"%i/160", textView.text.length+1];
    } else if (textView.text.length == 0) {
        self.characterCountLabel.text = [NSString stringWithFormat:@"%i/160", textView.text.length];
    } else {
        self.characterCountLabel.text = [NSString stringWithFormat:@"%i/160", textView.text.length-1];
    }
    return YES;
}
@end
