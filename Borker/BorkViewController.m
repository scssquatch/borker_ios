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
    UINib *nib = [UINib nibWithNibName:@"BorkCellView" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    [self.tableView.layer setBorderWidth:1.0];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BorkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSDictionary *borkDictionary = [self.borks objectAtIndex:[indexPath row]];
    NSString *user_id = [NSString stringWithFormat:@"%@", [borkDictionary objectForKey:@"user_id"]];
    BorkUser *user = [self.users objectForKey:user_id];
    cell.content.text = [borkDictionary objectForKey:@"content"];
    cell.username.text = user.username;
    cell.avatar.image = [self.avatars objectForKey:user_id];
    return cell;
}

@end
