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
#import "BorkUser.h"
#import "BorkUserNetwork.h"
#import "BorkNetwork.h"
#import "BorkCredentials.h"

static NSString * const cellIdentifier = @"BorkCell";
static NSString * const actionCellIdentifier = @"BorkActionCell";

@interface BorkViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BorkUser *borkUser;
@property (strong, nonatomic) NSMutableDictionary *users;
@property (strong, nonatomic) NSMutableDictionary *avatars;
@property (strong, nonatomic) NSIndexPath *actionPath;
@property (strong, nonatomic) NSArray *favorites;
@property (strong, nonatomic) BorkCredentials *credentials;
@property (strong, nonatomic) NSTimer *deleteTimer;
@end

@implementation BorkViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.borkUser = [[BorkUser alloc] init];
    self.avatars = [[NSMutableDictionary alloc] init];
    self.users = [[NSMutableDictionary alloc] init];
    self.borks = [[NSArray alloc] init];
    self.credentials = [[BorkCredentials alloc] init];
    
    //set up pull down to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    
    self.favorites = [BorkUserNetwork getFavorites:[self.credentials username]];
    
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
    
    //ask user for ability to send push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    //clear notifications
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
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
    [BorkNetwork fetchOlderBorks:20 before:date withCallback:^(NSArray *parsedJSON) {
        self.borks = parsedJSON;
        [self.tableView reloadData];
    }];
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
    if (indexPath.row == self.borks.count - 5) {
        [self loadMoreBorks];
    }
    BorkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *borkDictionary = [self.borks objectAtIndex:[indexPath row]];
    NSString *text = [borkDictionary objectForKey:@"content"];
    NSString *user_id = [NSString stringWithFormat:@"%@", [borkDictionary objectForKey:@"user_id"]];
    BorkUser *user = [self.users objectForKey:user_id];
    NSArray *words = [text componentsSeparatedByString:@" "];
    NSString *username = [self.credentials username];
    //FAVORITES
    NSString *secondIconName = nil;
    UIColor *secondColor = nil;
    NSString *fourthIconName = @"star.png";
    UIColor *fourthColor = nil;
    if ([username isEqualToString:user.username]) {
        secondIconName = @"cross.png";
        secondColor = [UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:14.0/255.0 alpha:1.0];
    } else {
        if ([self.favorites containsObject:(NSString *)[borkDictionary objectForKey:@"id"]]) {
            fourthColor = [UIColor colorWithRed:183.0/255.0 green:48.0/255.0 blue:45.0/255.0 alpha:1.0];
        } else {
            fourthColor = [UIColor colorWithRed:83.0/255.0 green:148.0/255.0 blue:245.0/255.0 alpha:1.0];
        }
    }
    [cell setDelegate:self];
    [cell setFirstStateIconName:nil
                     firstColor:nil
            secondStateIconName:secondIconName
                    secondColor:secondColor
                  thirdIconName:nil
                     thirdColor:nil
                 fourthIconName:fourthIconName
                    fourthColor:fourthColor];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    if ([username isEqualToString:user.username]) {
        [cell setModeForState2:MCSwipeTableViewCellModeExit];
    }
    [cell setModeForState3:MCSwipeTableViewCellModeSwitch];

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
- (void)loadMoreBorks
{
    NSString *createdAt = [self.borks.lastObject objectForKey:@"created_at"];
    NSMutableArray *oldArray = [self.borks mutableCopy];
    [BorkNetwork fetchOlderBorks:20 before:createdAt withCallback:^(NSArray *olderBorks) {
        if (olderBorks.count > 0) {
            [oldArray addObjectsFromArray:olderBorks];
            self.borks = oldArray;
            [self.tableView reloadData];
        }
    }];
}

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didEndSwipingSwipingWithState:(MCSwipeTableViewCellState)state mode:(MCSwipeTableViewCellMode)mode
{
    NSDictionary *bork = [self.borks objectAtIndex:[[self.tableView indexPathForCell:cell] row]];
    if (mode == MCSwipeTableViewCellModeExit)
    {
        NSMutableArray *mutableBorks = [NSMutableArray arrayWithArray:self.borks];
        [mutableBorks removeObject:bork];
        self.borks = [NSArray arrayWithArray:mutableBorks];
        [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self addUndoOption:bork];
        //change to 3 seconds
        self.deleteTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(deleteBork:) userInfo:bork repeats:NO];
    } else {
        NSString *bork_id = [bork objectForKey:@"id"];
        BOOL favorited = [self.favorites containsObject:(NSString *)bork_id];
        [BorkNetwork toggleBorkFavorite:[bork objectForKey:@"id"] user:[self.credentials username] favorited:favorited];
        self.favorites = [BorkUserNetwork getFavorites:[self.credentials username]];
        [self.tableView reloadData];
    }
}

- (void)addUndoOption:(NSDictionary *)bork
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UndoView *undoView = [[UndoView alloc] initWithFrame:CGRectMake(screenWidth/2.0, screenHeight/2.0, 200, 40) withBork:bork];
    undoView.delegate = self;
    [undoView setCenter:CGPointMake(screenWidth/2, screenHeight-100.0)];
    [self.view addSubview:undoView];
    [self.view bringSubviewToFront:undoView];
}

- (void)deleteBork:(NSTimer *)timer
{
    NSDictionary *bork = timer.userInfo;
    [BorkNetwork deleteBork:[bork objectForKey:@"id"] user:[self.credentials username]];
    [self.view.subviews.lastObject removeFromSuperview];
}

- (void)undoView:(UndoView *)view;
{
    [self.deleteTimer invalidate];
    [self.view.subviews.lastObject removeFromSuperview];
    NSMutableArray *mutableBorks = [NSMutableArray arrayWithArray:self.borks];
    [mutableBorks addObject:view.bork];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    self.borks = [mutableBorks sortedArrayUsingDescriptors:descriptors];
    [self.tableView reloadData];
}
@end
