//
//  NewBorkViewController.m
//  Borker
//
//  Created by Neo on 9/18/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "NewBorkViewController.h"

@interface NewBorkViewController ()
@property (weak, nonatomic) IBOutlet UITextView *borkContentField;

@end

@implementation NewBorkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.borkContentField becomeFirstResponder];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)createNewBork:(UIBarButtonItem *)sender {
    
}

@end
