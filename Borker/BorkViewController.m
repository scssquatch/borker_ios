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
#import "BorkUserNetwork.h"
#import "BorkNetwork.h"
#import "BorkCredentials.h"
#import "BorkDetailViewController.h"
#import "BorkUser.h"
#import "BorkCoreDataManager.h"

static NSString * const cellIdentifier = @"BorkCell";
static NSString * const defaultImageURL = @"https://borker.herokuapp.com/assets/default.jpg";



@interface BorkViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *avatars;
@property (strong, nonatomic) NSMutableDictionary *avatarThumbs;
@property (strong, nonatomic) NSArray *favorites;
@property (strong, nonatomic) BorkCredentials *credentials;
@property (strong, nonatomic) NSTimer *deleteTimer;
@property (strong, nonatomic) BorkCoreDataManager *coreDataManager;
@end

@implementation BorkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.avatars = [[NSMutableDictionary alloc] init];
    self.avatarThumbs = [[NSMutableDictionary alloc] init];
    self.borks = [[NSArray alloc] init];
    self.credentials = [[BorkCredentials alloc] init];
    self.coreDataManager = [[BorkCoreDataManager alloc] init];
    self.managedObjectContext = [self.coreDataManager getManagedObjectContext];
    
    //set up pull down to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    [self.view sendSubviewToBack:refresh];
    
    UIView* strip = [[UIView alloc]initWithFrame:CGRectMake(24, -300, 6, CGFLOAT_MAX)];
    strip.backgroundColor = [UIColor colorWithRed:0.89f green:0.90f blue:0.91f alpha:1.00f];
    [self.view addSubview:strip];
    [self.view sendSubviewToBack:strip];
    
    self.favorites = [BorkUserNetwork getFavorites:[self.credentials username]];
    
    //register nibs for identifiers
    UINib *nib = [UINib nibWithNibName:@"BorkCellView" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    //set table display properties
    self.navigationItem.hidesBackButton = YES;
    
    //ask user for ability to send push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    [self populateUsers];
    [self populateBorks];
}

- (void)populateUsers
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BorkUser" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    self.users = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (BorkUser *user in self.users) {
        NSURL *avatarURL = [NSURL URLWithString:user.avatarURL];
        [self.avatars setObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:avatarURL]] forKey:user.user_id];
        NSURL *avatarThumbURL = [NSURL URLWithString:user.avatarURL];
        [self.avatarThumbs setObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:avatarThumbURL]] forKey:user.user_id];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.borks.count - 5) {
        [self loadMoreBorks];
    }
    BorkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *bork = [self.borks objectAtIndex:[indexPath row]];
    NSString *user_id = [NSString stringWithFormat:@"%@", [bork objectForKey:@"user_id"]];
    BorkUser *user = [self findUserByID:user_id];
    
    //FAVORITES
    NSString *secondIconName = nil;
    UIColor *secondColor = [UIColor clearColor];
    NSString *leftIconName = @"star-gray.png";
    UIColor *leftColor = [UIColor clearColor];
    if ([[self.credentials username] isEqualToString:user.username]) {
        secondIconName = @"cross.png";
    }
    if ([self.favorites containsObject:(NSString *)[bork objectForKey:@"id"]]) {
        cell.favoritedView.transform = CGAffineTransformIdentity;
    } else {
        cell.favoritedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }
    [cell setDelegate:self];
    [cell setFirstStateIconName:nil
                     firstColor:nil
            secondStateIconName:secondIconName
                    secondColor:secondColor
                  thirdIconName:leftIconName
                     thirdColor:leftColor
                 fourthIconName:leftIconName
                    fourthColor:leftColor];
    if ([[self.credentials username] isEqualToString:user.username]) {
        [cell setModeForState2:MCSwipeTableViewCellModeExit];
    }
    [cell setModeForState3:MCSwipeTableViewCellModeSwitch];
//    cell.shouldAnimatesIcons = NO;
    
    
    NSString *text = [bork objectForKey:@"content"];
    NSArray *words = [text componentsSeparatedByString:@" "];
    if ([self longestWord:words] > 23) {
        [cell.content setLineBreakMode:NSLineBreakByCharWrapping];
    } else {
        [cell.content setLineBreakMode:NSLineBreakByWordWrapping];
    }
    
    cell.content.text = text;
    cell.timestamp.text = [self timeAgo:[bork objectForKey:@"created_at"]];
    cell.username.text = user.username;
    cell.avatar.image = [self.avatarThumbs objectForKey:user.user_id];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"didClickBork" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"didClickBork"]) {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        BorkDetailViewController *detailController = [segue destinationViewController];
        
        NSDictionary *bork = [self.borks objectAtIndex:[selectedRowIndex row]];
        
        [detailController setBork:bork];
        
        NSString *user_id = [NSString stringWithFormat:@"%@", [bork objectForKey:@"user_id"]];
        BorkUser *user = [self findUserByID:user_id];
        detailController.avatar = [self.avatars objectForKey:user.user_id];
        detailController.username = user.username;
    }
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
    } else {
        NSString *bork_id = [bork objectForKey:@"id"];
        BOOL favorited = [self.favorites containsObject:(NSString *)bork_id];
        [BorkNetwork toggleBorkFavorite:[bork objectForKey:@"id"] user:[self.credentials username] favorited:favorited withCallback:^(NSArray *parsedJSON) {
            self.favorites = [BorkUserNetwork getFavorites:[self.credentials username]];
            [self.tableView reloadData];
        }];
        if (favorited) {
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut
                             animations:^{ cell.favoritedView.transform = CGAffineTransformMakeScale(0.01, 0.01);}
                             completion:^(BOOL finished){}];
        } else {
            cell.favoritedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut
                             animations:^{ cell.favoritedView.transform = CGAffineTransformIdentity;}
                             completion:^(BOOL finished){}];
        }
    }
}

- (void)addUndoOption:(NSDictionary *)bork
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UndoView *undoView = [[UndoView alloc] initWithFrame:CGRectMake(screenWidth/2.0, screenHeight-200, 200, 40) withBork:bork];
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

- (BorkUser *)findUserByID:(NSString *)user_id
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BorkUser" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id = %@", user_id];
    [request setPredicate:predicate];
    NSError *error;
    return [[self.managedObjectContext executeFetchRequest:request error:&error] firstObject];
}
@end
