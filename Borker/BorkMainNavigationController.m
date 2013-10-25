//
//  BorkMainNavigationController.m
//  Borker
//
//  Created by Aaron Baker on 10/25/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkMainNavigationController.h"

@interface BorkMainNavigationController ()

@end

@implementation BorkMainNavigationController

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
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.4 green:0.412 blue:0.588 alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"AvenirNext-Bold" size:21.0], NSFontAttributeName, nil]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
