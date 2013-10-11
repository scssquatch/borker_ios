//
//  BorkDetailViewController.m
//  Borker
//
//  Created by Aaron Baker on 10/4/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkDetailViewController.h"
#import "BorkCell.h"

static NSString * const defaultImageURL = @"https://borker.herokuapp.com/assets/default.jpg";

@interface BorkDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *borkAvatar;
@property (weak, nonatomic) IBOutlet UILabel *borkUsername;
@property (weak, nonatomic) IBOutlet UILabel *borkContent;
@property (weak, nonatomic) IBOutlet UIImageView *borkAttachment;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundViewConstraint;

@end

@implementation BorkDetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setImage];
    self.borkContent.text = [self.bork objectForKey:@"content"];
    self.borkAvatar.image = self.avatar;
    self.borkUsername.text = self.username;
    [self determineContentHeight];
	// Do any additional setup after loading the view.
    
}
- (void)determineContentHeight
{
    NSString *text = self.borkContent.text;
    CGSize maximumLabelSize = CGSizeMake(self.borkContent.frame.size.width, FLT_MAX);
    CGRect expectedLabelRect = [text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.borkContent.font} context:nil];
    
    CGFloat difference = expectedLabelRect.size.height - self.contentHeightConstraint.constant;
    self.contentHeightConstraint.constant = expectedLabelRect.size.height + 10.0f;
    self.backgroundViewConstraint.constant += difference;
}
- (void)setImage
{
    NSString *attachmentURLString = [[self.bork objectForKey:@"attachment"] objectForKey:@"url"];
    if (![attachmentURLString isEqualToString:defaultImageURL])
    {
        NSURL *attachmentURL = [NSURL URLWithString:attachmentURLString];
        self.borkAttachment.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:attachmentURL]];
    }
}
- (IBAction)didClickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//- (IBAction)didClickReply:(id)sender {
//    [self performSegueWithIdentifier:@"didClickReply" sender:self];
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"didClickReply"]) {
//        NewBorkViewController *newBorkController = [segue destinationViewController];
//        newBorkController.borkContentView.text = [NSString stringWithFormat:@"@%@", self.username];
//    }
//}

- (void)setBork:(NSDictionary *)bork
{
    _bork = bork;
}
@end
