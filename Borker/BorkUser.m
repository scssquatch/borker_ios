//
//  BorkUser.m
//  Borker
//
//  Created by Neo on 9/16/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkUser.h"
static NSString * const appRootPath = @"https://borker.herokuapp.com";
@implementation BorkUser
- (id)init
{
    self = [super init];
    if (self) {
        [self getUsers];
    }
    return self;
}

- (void)getUsers
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[appRootPath stringByAppendingPathComponent:@"users.json"]]];
    __autoreleasing NSError* error = nil;
    self.users = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
}

@end
