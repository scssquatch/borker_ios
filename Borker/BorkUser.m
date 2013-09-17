//
//  BorkUser.m
//  Borker
//
//  Created by Neo on 9/16/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkUser.h"
#import "BorkUserNetwork.h"

static NSString * const appRootPath = @"https://borker.herokuapp.com";

@interface BorkUser ()
@property (strong, nonatomic) BorkUserNetwork *borkerRequests;
@end

@implementation BorkUser

- (id)init
{
    self = [super init];
    if (self) {
        self.borkerRequests = [[BorkUserNetwork alloc] init];
        [self requestUsers];
    }
    return self;
}

- (void)requestUsers
{
    NSArray *users = [self.borkerRequests fetchUsers];
    NSMutableArray *userIDs = [[NSMutableArray alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *usersDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *user in users) {
        NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
        NSString *imageURL = [[[user objectForKey:@"avatar"] objectForKey:@"thumb"]objectForKey:@"url"];
        [userDictionary setObject:imageURL forKey:@"avatar"];
        [userDictionary setObject:[user objectForKey:@"username"] forKey:@"username"];
        [userDictionary setObject:[user objectForKey:@"id"] forKey:@"id"];
        [userIDs addObject:[user objectForKey:@"id"]];
        
        [usersDictionary setObject:userDictionary forKey:[NSString stringWithFormat:@"%@",[user objectForKey:@"id"]]];
    }
    
    [defaults setObject:[NSDictionary dictionaryWithDictionary:usersDictionary]
                 forKey:@"users"];
    self.userIDs = userIDs;
}

+ (BorkUser *)findByID:(NSString *)user_id
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *borkUser = [[defaults dictionaryForKey:@"users"] objectForKey:user_id];
    BorkUser *user = [[BorkUser alloc] init];
    user.username = [borkUser objectForKey:@"username"];
    user.id = [borkUser objectForKey:@"id"];
    user.avatarURL = [NSURL URLWithString:[borkUser objectForKey:@"avatar"]];
    return user;
}
@end
