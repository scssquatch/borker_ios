//
//  BorkUser.m
//  Borker
//
//  Created by Neo on 9/16/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkUser.h"
#import "BorkerAPILayer.h"

static NSString * const appRootPath = @"https://borker.herokuapp.com";

@interface BorkUser ()
@property (strong, nonatomic) BorkerAPILayer *borkerRequests;
@end

@implementation BorkUser

- (id)init
{
    self = [super init];
    if (self) {
        self.borkerRequests = [[BorkerAPILayer alloc] init];
        [self requestUsers];
    }
    return self;
}

- (void)requestUsers
{
    self.userIDs = [self.borkerRequests fetchUsers];
}

+ (BorkUser *)findByID:(NSString *)user_id
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *borkUser = [[defaults dictionaryForKey:@"users"] objectForKey:user_id];
    BorkUser *user = [[BorkUser alloc] init];
    user.username = [borkUser objectForKey:@"username"];
    user.avatar = [UIImage imageWithData:[borkUser objectForKey:@"avatar"]];
    return user;
}
@end
