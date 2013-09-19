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

static NSString * const cellIdentifier = @"BorkCell";

@interface BorkViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) BorkUser *borkUser;
@property (strong, nonatomic) NSMutableDictionary *users;
@property (strong, nonatomic) NSMutableDictionary *avatars;
@property (strong, nonatomic) BorkUserNetwork *borkUserRequests;
@property (strong, nonatomic) BorkNetwork *borkRequests;
@end

@implementation BorkViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.borkUserRequests = [[BorkUserNetwork alloc] init];
    self.borkRequests = [[BorkNetwork alloc] init];
    self.borkUser = [[BorkUser alloc] init];
    self.avatars = [[NSMutableDictionary alloc] init];
    self.users = [[NSMutableDictionary alloc] init];
    self.borks = [[NSArray alloc] init];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient-background.png"]];
    self.navigationItem.hidesBackButton = YES;
    UINib *nib = [UINib nibWithNibName:@"BorkCellView" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    [self.tableView.layer setBorderWidth:1.0];
    [self.tableView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self populateUsers];
    [self populateBorks];
}

- (void)populateUsers
{
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
    self.borks = [self.borkRequests fetchBorks];
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
    self.borks = [self.borkRequests fetchBorks];
    [self.tableView reloadData];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
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
