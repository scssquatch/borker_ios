//
//  BorkViewController.m
//  Borker
//
//  Created by Neo on 9/16/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkViewController.h"
#import "BorkCell.h"
#import "BorkUser.h"
#import "BorkerAPILayer.h"

static NSString * const cellIdentifier = @"BorkCell";

@interface BorkViewController ()
@property (strong, nonatomic) BorkUser *borkUser;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) BorkerAPILayer *borkerRequests;
@end

@implementation BorkViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.borkerRequests = [[BorkerAPILayer alloc] init];
    self.borkUser = [[BorkUser alloc] init];
    self.users = [[NSMutableArray alloc] init];
    self.borks = [[NSArray alloc] init];
    UINib *nib = [UINib nibWithNibName:@"BorkCellView" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    [self populateUsers];
    [self populateBorks];
}

- (void)populateUsers
{
    for (NSString *userID in self.borkUser.userIDs) {
        [self.users addObject:[BorkUser findByID:userID]];
    }
}

- (void)populateBorks
{
    self.borks = [self.borkerRequests fetchBorks];
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
    BorkUser *user = [BorkUser findByID:user_id];
    cell.content.text = [borkDictionary objectForKey:@"content"];
    cell.username.text = user.username;
    cell.avatar.image = user.avatar;
    return cell;
}

@end
