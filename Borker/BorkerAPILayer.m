//
//  BorkerAPILayer.m
//  Borker
//
//  Created by Neo on 9/17/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkerAPILayer.h"

static NSString * const appRootPath = @"https://borker.herokuapp.com";
static NSString * const defaultAvatarURL = @"/assets/default.jpg";
@implementation BorkerAPILayer
- (NSArray *)fetchUsers
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[appRootPath stringByAppendingPathComponent:@"users.json"]]];
    __autoreleasing NSError* error = nil;
    NSMutableArray *users = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableArray *userIDs = [[NSMutableArray alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *usersDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *user in users) {
        NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
        NSString *imageURL = [[[user objectForKey:@"avatar"] objectForKey:@"profile"]objectForKey:@"url"];
        NSURL *imageNSURL = [NSURL URLWithString:imageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageNSURL];
        if (imageData) {
            [userDictionary setObject:imageData forKey:@"avatar"];
        } else {
            NSURL *defaultNSURL = [NSURL URLWithString:[appRootPath stringByAppendingString:defaultAvatarURL]];
            NSData *imageData = [NSData dataWithContentsOfURL:defaultNSURL];
            [userDictionary setObject:imageData forKey:@"avatar"];
        }
        [userDictionary setObject:[user objectForKey:@"username"] forKey:@"username"];
        [userDictionary setObject:[user objectForKey:@"id"] forKey:@"id"];
        [userIDs addObject:[user objectForKey:@"id"]];

        [usersDictionary setObject:userDictionary forKey:[NSString stringWithFormat:@"%@",[user objectForKey:@"id"]]];
    }
    
    [defaults setObject:[NSDictionary dictionaryWithDictionary:usersDictionary]
                 forKey:@"users"];
    return userIDs;
}

- (NSArray *)fetchBorks
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[appRootPath stringByAppendingPathComponent:@"borks_for_app.json"]]];
    __autoreleasing NSError* error = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}
@end