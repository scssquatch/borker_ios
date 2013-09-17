//
//  BorkerAPILayer.m
//  Borker
//
//  Created by Neo on 9/17/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkUserNetwork.h"

static NSString * const appRootPath = @"https://borker.herokuapp.com";

@implementation BorkUserNetwork
- (NSArray *)fetchUsers
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[appRootPath stringByAppendingPathComponent:@"users.json"]]];
    __autoreleasing NSError* error = nil;
    NSMutableArray *users = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return users;
}
@end