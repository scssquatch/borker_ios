//
//  BorkViewController.m
//  Borker
//
//  Created by Neo on 9/16/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BorkViewController.h"
#import "BorkCell.h"
#import "BorkActionCell.h"
#import "BorkUser.h"
#import "BorkUserNetwork.h"
#import "BorkNetwork.h"

static NSString * const cellIdentifier = @"BorkCell";
static NSString * const actionCellIdentifier = @"BorkActionCell";

@interface BorkViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BorkUser *borkUser;
@property (strong, nonatomic) NSMutableDictionary *users;
@property (strong, nonatomic) NSMutableDictionary *avatars;
@property (strong, nonatomic) NSIndexPath *actionPath;
@end

@implementation BorkViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.borkUser = [[BorkUser alloc] init];
    self.avatars = [[NSMutableDictionary alloc] init];
    self.users = [[NSMutableDictionary alloc] init];
    self.borks = [[NSArray alloc] init];
    
    //set up pull down to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    
    
    //register nibs for identifiers
    UINib *nib = [UINib nibWithNibName:@"BorkCellView" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    UINib *actionNib = [UINib nibWithNibName:@"BorkActionCellView" bundle:nil];
    [self.tableView registerNib:actionNib forCellReuseIdentifier:actionCellIdentifier];
    
    //set table display properties
    [self.tableView.layer setBorderWidth:1.0];
    [self.tableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient-background.png"]];
    self.navigationItem.hidesBackButton = YES;
    
    //add long press for favorite/delete
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //seconds
    [self.tableView addGestureRecognizer:lpgr];
    
    //short press for dismissing favorite/delete
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(dismissActionCell:)];
    
    [self.tableView addGestureRecognizer:tap];
    
    //ask user for ability to send push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    [self populateUsers];
    [self populateBorks];
}

- (void)populateUsers
{
    [self.borkUser requestUsers];
    for (NSString *userID in self.borkUser.userIDs) {
        NSString *userStringID = [NSString stringWithFormat:@"%@", userID];
        BorkUser *tempUser = [BorkUser findByID:userStringID];
        NSData *imageData = [NSData dataWithContentsOfURL:tempUser.avatarURL];
        [self.avatars setObject:[UIImage imageWithData:imageData] forKey:userStringID];
        [self.users setObject:tempUser forKey:userStringID];
    }
}

- (void)populateBorks
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd-hh:mm:ssaZZZ"];
    NSString *date = [DateFormatter stringFromDate:[NSDate date]];
    self.borks = [BorkNetwork fetchOlderBorks:20 before:date];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.borks count];
}

#define FONT_SIZE 14.0f
#define LABEL_CONTENT_WIDTH 195.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_HEIGHT_TOP_MARGIN 27.0f
#define CELL_CONTENT_HEIGHT_BOTTOM_MARGIN 10.0f
#define CELL_CONTENT_WIDTH_RIGHT_MARGIN 47.0f
#define CELL_CONTENT_WIDTH_LEFT_MARGIN 78.0f

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BorkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.row == self.borks.count - 1) {
        NSString *createdAt = [self.borks.lastObject objectForKey:@"created_at"];
        NSMutableArray *oldArray = [self.borks mutableCopy];
        NSArray *olderBorks =[BorkNetwork fetchOlderBorks:20 before:createdAt];
        if (olderBorks.count > 0) {
            [oldArray addObjectsFromArray:olderBorks];
            self.borks = oldArray;
            [self.tableView reloadData];
        }
    }
    NSDictionary *borkDictionary = [self.borks objectAtIndex:[indexPath row]];
    NSString *text = [borkDictionary objectForKey:@"content"];
    NSString *user_id = [NSString stringWithFormat:@"%@", [borkDictionary objectForKey:@"user_id"]];
    BorkUser *user = [self.users objectForKey:user_id];
    NSArray *words = [text componentsSeparatedByString:@" "];
    if ([self longestWord:words] > 23) {
        [cell.content setLineBreakMode:NSLineBreakByCharWrapping];
    } else {
        [cell.content setLineBreakMode:NSLineBreakByWordWrapping];
    }
    cell.content.text = text;
    
    cell.username.text = user.username;
    cell.avatar.image = [self.avatars objectForKey:user_id];
    return cell;
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    NSDictionary *borkDictionary = [self.borks objectAtIndex:[indexPath row]];
    NSString *text = [borkDictionary objectForKey:@"content"];
    CGSize constraint = CGSizeMake(LABEL_CONTENT_WIDTH, 20000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = MAX(size.height, 38.0f);
    return height + (CELL_CONTENT_HEIGHT_TOP_MARGIN + CELL_CONTENT_HEIGHT_BOTTOM_MARGIN);
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    // FETCH NEW BORKS HERE. newer than sef.borks.firstobject's
    // created at date
    NSString *createdAt = [self.borks.firstObject objectForKey:@"created_at"];
    NSMutableArray *newBorks = [[BorkNetwork fetchBorks:25 since:createdAt] mutableCopy];
    [newBorks addObjectsFromArray:self.borks];
    self.borks = [[NSOrderedSet orderedSetWithArray:newBorks] array];
    [self.tableView reloadData];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}

- (IBAction)logoutUser:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Leaving Confirmation"
                          message:@"Are you sure you want to log out?"
                          delegate:self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [BorkUser logoutCurrentUser];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
//    CGPoint p = [gestureRecognizer locationInView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
//    
//    if (indexPath != nil) {
//        self.actionPath = indexPath;
//        [self.tableView dequeueReusableCellWithIdentifier:actionCellIdentifier forIndexPath:indexPath];
//    }
}

- (void)dismissActionCell:(UITapGestureRecognizer *)tapRecognizer
{
//    CGPoint p = [tapRecognizer locationInView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
//    if (![indexPath isEqual:self.actionPath]) {
//        //reset cell at self.actionPath to normal cell contents
//    }
}
- (NSInteger)longestWord:(NSArray *)wordArray
{
    int max = 0;
    for (NSString *word in wordArray) {
        if (word.length > max) {
            max = word.length;
        }
    }
    return max;
}
@end
