//
//  BorkUser.m
//  Borker
//
//  Created by Neo on 9/16/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkUser.h"
#import "BorkUserNetwork.h"
#import "KeychainItemWrapper.h"

@interface BorkUser ()
@property (strong, nonatomic) BorkUserNetwork *borkerRequests;
@end

@implementation BorkUser
- (void)requestUsers
{
    NSArray *users = [BorkUserNetwork fetchUsers];
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

+ (void)logoutCurrentUser
{
    KeychainItemWrapper *keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"borkCredentials" accessGroup:nil];
    [keychainWrapper setObject:@"" forKey:(__bridge id)kSecAttrAccount];
}
@end
