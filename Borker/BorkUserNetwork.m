//
//  BorkerAPILayer.m
//  Borker
//
//  Created by Neo on 9/17/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkUserNetwork.h"

@implementation BorkUserNetwork
- (NSArray *)fetchUsers
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"api/users?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@", authToken]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:postString]];
    __autoreleasing NSError* error = nil;
    NSMutableArray *users = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return users;
}
- (BOOL)authenticateUser:(NSString *)username withPassword:(NSString *)password
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"api/authenticate?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"username=%@", username]];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"&password=%@", password]];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"&api_key=%@", authToken]];
    NSURL *url = [NSURL URLWithString:postString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    __autoreleasing NSError *error = nil;
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *retVal = [[NSString alloc] init];
    if (!error)
    {
        retVal = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([retVal isEqualToString:@"true"]) {
            return true;
        }
    }
    return false;
}
@end