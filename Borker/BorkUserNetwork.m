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
- (BOOL)authenticateUser:(NSString *)username withPassword:(NSString *)password
{
    NSURL *url = [NSURL URLWithString:[appRootPath stringByAppendingPathComponent:@"authenticate.json"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    __autoreleasing NSError *error = nil;
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                            username, @"username",
                            password, @"password",
                            nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:&error];
    [request setHTTPBody:postData];
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error)
    {
        
    }else{
        NSString *retVal = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", retVal);
    }
    return true;
}
@end