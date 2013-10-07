//
//  BorkDetailViewController.m
//  Borker
//
//  Created by Aaron Baker on 10/4/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkDetailViewController.h"
#import "BorkCell.h"

@interface BorkDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *borkAvatar;
@property (weak, nonatomic) IBOutlet UILabel *borkUsername;
@property (weak, nonatomic) IBOutlet UILabel *borkContent;

@end

@implementation BorkDetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.borkContent.text = [self.bork objectForKey:@"content"];
    self.borkAvatar.image = self.avatar;
    self.borkUsername.text = self.username;
    [self determineContentHeight];
	// Do any additional setup after loading the view.
    
}
- (void)determineContentHeight
{
    NSLog(@"incoming label height = %f", self.borkContent.frame.size.height);
    NSString *text = self.borkContent.text;
    CGSize maximumLabelSize = CGSizeMake(self.borkContent.frame.size.width, FLT_MAX);
    CGRect expectedLabelRect = [text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.borkContent.font} context:nil];
    NSLog(@"width = %f, height = %f", expectedLabelRect.size.width, expectedLabelRect.size.height);
    
    CGRect newFrame = self.borkContent.frame;
    newFrame.size = expectedLabelRect.size;
    self.borkContent.frame = newFrame;
    NSLog(@"outgoing label height = %f", self.borkContent.frame.size.height);
}
- (IBAction)didClickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setBork:(NSDictionary *)bork
{
    _bork = bork;
}
@end
