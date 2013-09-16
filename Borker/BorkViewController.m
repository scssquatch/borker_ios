//
//  BorkViewController.m
//  Borker
//
//  Created by Neo on 9/16/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkViewController.h"
#import "BorkCell.h"

static NSString * const appRootPath = @"https://borker.herokuapp.com";

@interface BorkViewController ()
@end

@implementation BorkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.borks = [[NSArray alloc] init];
    [self getBorks];
}

- (void)getBorks
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[appRootPath stringByAppendingPathComponent:@"borks_for_app.json"]]];
    __autoreleasing NSError* error = nil;
    self.borks = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
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
    static NSString *CellIdentifier = @"BorkCell";
    BorkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BorkCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *tempDictionary = [self.borks objectAtIndex:[indexPath row]];
    [cell.content sizeToFit];
    cell.content.text = [tempDictionary objectForKey:@"content"];
    cell.username.text = [NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"user_id"]];
    return cell;
}

@end
