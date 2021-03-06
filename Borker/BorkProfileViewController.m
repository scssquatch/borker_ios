//
//  BorkProfileViewController.m
//  Borker
//
//  Created by Aaron Baker on 10/1/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "BorkProfileViewController.h"
#import "BorkCredentials.h"
#import "BorkNetwork.h"
#import "BorkUserNetwork.h"
#import "BorkUser.h"
#import "BorkCell.h"
#import "BorkUserCoreDataManager.h"

static NSString * const cellIdentifier = @"BorkCell";
static NSString * const defaultImageURL = @"https://borker.herokuapp.com/assets/default.jpg";

@interface BorkProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileUsernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BorkUserCoreDataManager *dataManager;
@property (strong, nonatomic) BorkCredentials *credentials;
@property (strong, nonatomic) BorkUser *borkUser;
@property (strong, nonatomic) NSArray *borks;
@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) NSTimer *deleteTimer;
@end

@implementation BorkProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.credentials = [BorkCredentials sharedInstance];
    self.borks = [[NSArray alloc] init];
    self.dataManager = [[BorkUserCoreDataManager alloc] init];
    
    //set up pull down to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    [self.tableView sendSubviewToBack:refresh];
    
    //register nibs for identifiers
    UINib *nib = [UINib nibWithNibName:@"BorkCellView" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    //set table display properties
    self.navigationItem.hidesBackButton = YES;
    self.tableView.allowsSelection=NO;
    
    [self.view bringSubviewToFront:self.tableView];
    [self populateBorks];
}
- (void)viewWillAppear:(BOOL)animated
{
    NSString *userID = [BorkUserNetwork getUserIDWithUsername:[self.credentials username]];
    NSString *userStringID = [NSString stringWithFormat:@"%@", userID];
    if (self.borkUser != [self.dataManager findByID:userStringID]) {
        self.borkUser = [self.dataManager findByID:userStringID];
        NSURL *avatarURL = [NSURL URLWithString:self.borkUser.avatarURL];
        NSData *imageData = [NSData dataWithContentsOfURL:avatarURL];
        NSURL *avatarThumbURL = [NSURL URLWithString:self.borkUser.avatarThumbURL];
        NSData *thumbImageData = [NSData dataWithContentsOfURL:avatarThumbURL];
        
        self.avatar = [UIImage imageWithData:thumbImageData];
        self.profileImageView.image = [UIImage imageWithData:imageData];
        self.profileUsernameLabel.text = [self.borkUser username];
        [self.profileImageView.layer setMasksToBounds:YES];
        [self.profileImageView.layer setCornerRadius:30.0f];
    }
}

- (void)populateBorks
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd-hh:mm:ssaZZZ"];
    NSString *date = [DateFormatter stringFromDate:[NSDate date]];
    [BorkUserNetwork fetchOlderUserBorks:25 before:date withUser:[self.credentials username] withCallback:^(NSArray *olderBorks) {
        self.borks = olderBorks;
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.borks.count - 5) {
        [self loadMoreBorks];
    }
    BorkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *bork = [self.borks objectAtIndex:[indexPath row]];
    //FAVORITES
    NSString *secondIconName = @"cross.png";
    [cell setDelegate:self];
    [cell setFirstStateIconName:nil
                     firstColor:nil
            secondStateIconName:secondIconName
                    secondColor:nil
                  thirdIconName:nil
                     thirdColor:nil
                 fourthIconName:nil
                    fourthColor:nil];
    
    cell.favoritedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    [cell setModeForState2:MCSwipeTableViewCellModeExit];
    
    NSString *text = [bork objectForKey:@"content"];
    NSArray *words = [text componentsSeparatedByString:@" "];
    if ([self longestWord:words] > 23) {
        [cell.content setLineBreakMode:NSLineBreakByCharWrapping];
    } else {
        [cell.content setLineBreakMode:NSLineBreakByWordWrapping];
    }
    cell.content.text = text;
    cell.timestamp.text = [self timeAgo:[bork objectForKey:@"created_at"]];
    cell.username.text = self.borkUser.username;
    cell.avatar.image = self.avatar;
    if (![[[bork objectForKey:@"attachment"] objectForKey:@"url"] isEqualToString:defaultImageURL])
        cell.hasAttachment.text = @"Attach";
    else
        cell.hasAttachment.text = @"";
    return cell;
}

#define FONT_SIZE 14.0f
#define LABEL_CONTENT_WIDTH 230.0f
#define CELL_CONTENT_HEIGHT_TOP_MARGIN 31.0f
#define CELL_CONTENT_WIDTH_LEFT_MARGIN 12.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_HEIGHT_BOTTOM_MARGIN 9.0f
- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    NSDictionary *bork = [self.borks objectAtIndex:[indexPath row]];
    NSString *text = [bork objectForKey:@"content"];
    
    CGSize maximumLabelSize = CGSizeMake(LABEL_CONTENT_WIDTH, FLT_MAX);
    CGRect expectedLabelRect = [text boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont fontWithDescriptor:[UIFontDescriptor fontDescriptorWithName:@"AvenirNext-Regular" size:14.0f] size:14.0f]} context:nil];
    CGFloat difference = expectedLabelRect.size.height - 17.0f;
    return 67.0f + difference;
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    // FETCH NEW BORKS HERE. newer than sef.borks.firstobject's
    // created at date
    NSString *createdAt = [self.borks.firstObject objectForKey:@"created_at"];
    [BorkUserNetwork fetchUserBorks:25 since:createdAt withUser:[self.credentials username] withCallback:^(NSArray *olderBorks) {
        NSMutableArray *newBorks = [olderBorks mutableCopy];
        [newBorks addObjectsFromArray:self.borks];
        self.borks = [[NSOrderedSet orderedSetWithArray:newBorks] array];
        [self.tableView reloadData];
    }];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}

- (void)loadMoreBorks
{
    NSString *createdAt = [self.borks.lastObject objectForKey:@"created_at"];
    NSMutableArray *oldArray = [self.borks mutableCopy];
    [BorkUserNetwork fetchOlderUserBorks:25 before:createdAt withUser:[self.credentials username] withCallback:^(NSArray *olderBorks) {
        if (olderBorks.count > 0) {
            [oldArray addObjectsFromArray:olderBorks];
            self.borks = [NSArray arrayWithArray:oldArray];
            [self.tableView reloadData];
        }
    }];
}

- (void)swipeTableViewCell:(BorkCell *)cell didEndSwipingSwipingWithState:(MCSwipeTableViewCellState)state mode:(MCSwipeTableViewCellMode)mode
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
    }
}

- (void)addUndoOption:(NSDictionary *)bork
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UndoView *undoView = [[UndoView alloc] initWithFrame:CGRectMake(screenWidth/2.0, screenHeight/2.0, 200, 40) withBork:bork];
    undoView.delegate = self;
    [undoView setCenter:CGPointMake(screenWidth/2, screenHeight-150.0)];
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


//HELPER METHODS
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

- (NSString *)timeAgo:(NSString *)time
{
    if ([time hasSuffix:@"Z"]) {
        time = [[time substringToIndex:(time.length-5)] stringByAppendingString:@"-0000"];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    NSDate *borkTime = [dateFormatter dateFromString:time];
    NSDate *currentTime = [NSDate date];
    double seconds = [currentTime timeIntervalSinceDate:borkTime];
    [dateFormatter setDateFormat:@"MMM d"];
    if (seconds < 60)
        return @"Just Now";
    else if (seconds < 3600)
        return [NSString stringWithFormat:@"%im", (int)seconds/60];
    else if (seconds < 86400)
        return [NSString stringWithFormat:@"%ih", (int)seconds/3600];
    else
        return (NSString *)[dateFormatter stringFromDate:borkTime];
}
@end
