//
//  BorkNotificationViewController.m
//  Borker
//
//  Created by Aaron Baker on 10/1/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkNotificationViewController.h"
#import "BorkNotificationNetwork.h"
#import "BorkCredentials.h"
#import "NotificationCell.h"

@interface BorkNotificationViewController ()
@property (strong, nonatomic) NSArray *notifications;
@property (strong, nonatomic) BorkCredentials *credentials;
@end

static NSString *const CellIdentifier = @"Cell";
@implementation BorkNotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.notifications = [[NSArray alloc] init];
    self.credentials = [[BorkCredentials alloc] init];
    
    //set up pull down to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refresh];
    
    //register nibs for identifiers
    UINib *nib = [UINib nibWithNibName:@"NotificationCellView" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    [self populateNotifications];
}

- (void)populateNotifications
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd-hh:mm:ssaZZZ"];
    NSString *date = [DateFormatter stringFromDate:[NSDate date]];
    [BorkNotificationNetwork fetchOlderNotifications:[self.credentials username] withLimit:25 before:date withCallback:^(NSArray *olderNotifications) {
        self.notifications = olderNotifications;
        [self.tableView reloadData];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.notifications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.notifications.count - 5) {
        [self loadMoreNotifications];
    }
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *notification = [self.notifications objectAtIndex:[indexPath row]];
    cell.content.text = [notification objectForKey:@"notification_content"];
    
    return cell;
}

#define FONT_SIZE 14.0f
#define LABEL_CONTENT_WIDTH 310.0f
#define CELL_CONTENT_HEIGHT_TOP_MARGIN 5.0f
#define CELL_CONTENT_HEIGHT_BOTTOM_MARGIN 5.0f
- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    NSDictionary *notification = [self.notifications objectAtIndex:[indexPath row]];
    NSString *text = [notification objectForKey:@"notification_content"];
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
    NSString *createdAt = [self.notifications.firstObject objectForKey:@"created_at"];
    NSMutableArray *newBorks = [[BorkNotificationNetwork fetchNotifications:[self.credentials username] withLimit:25 since:createdAt] mutableCopy];
    [newBorks addObjectsFromArray:self.notifications];
    self.notifications = [[NSOrderedSet orderedSetWithArray:newBorks] array];
    [self.tableView reloadData];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}

- (void)loadMoreNotifications
{
    NSString *createdAt = [self.notifications.lastObject objectForKey:@"created_at"];
    NSMutableArray *oldArray = [self.notifications mutableCopy];
    [BorkNotificationNetwork fetchOlderNotifications:[self.credentials username] withLimit:25 before:createdAt withCallback:^(NSArray *olderNotifications) {
        if (olderNotifications.count > 0) {
            [oldArray addObjectsFromArray:olderNotifications];
            self.notifications = oldArray;
            [self.tableView reloadData];
        }
    }];

}

@end
