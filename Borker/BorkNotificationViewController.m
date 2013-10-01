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
    self.notifications = [BorkNotificationNetwork fetchOlderNotifications:[self.credentials username] withLimit:50 before:date];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *notification = [self.notifications objectAtIndex:[indexPath row]];
    cell.textLabel.text = [notification objectForKey:@"notification_content"];
    
    return cell;
}

@end
