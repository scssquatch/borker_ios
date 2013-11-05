//
//  BorkerAPILayer.m
//  Borker
//
//  Created by Neo on 9/17/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkUserNetwork.h"

@implementation BorkUserNetwork
+ (NSArray *)fetchUsers
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"users?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@", authToken]];
    NSURL *url = [NSURL URLWithString:postString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError* error = nil;
    NSMutableArray *users = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return users;
}

+ (void)authenticateUser:(NSString *)username withPassword:(NSString *)password withCallback:(void (^)(BOOL authenticated))callback
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"authenticate?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@&username=%@&password=%@", authToken, username, password]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postString]];
    [request setHTTPMethod:@"POST"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSError* error = nil;
                               NSDictionary *auth_response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                               BOOL authenticated = [auth_response objectForKey:@"error"] ? false : true;
                               if (error) {
                                   NSLog(@"%@", error);
                               } else {
                                   callback(authenticated);
                               }
                           }];
}

+ (void)addToken:(NSString *)token withUsername:(NSString *)username
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"add_token?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@&username=%@&token=%@", authToken, username, token]];
    NSURL *url = [NSURL URLWithString:postString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    NSError *error = nil;
    NSURLResponse *response = [[NSURLResponse alloc] init];
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

+ (NSArray *)getFavorites:(NSString *)username
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"favorites?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@&username=%@", authToken, username]];
    NSURL *url = [NSURL URLWithString:postString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError* error = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}


+ (void)fetchUserBorks:(NSUInteger)limit since:(NSString *)time withUser:(NSString *)username withCallback:(void (^)(NSArray *olderBorks))callback
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"user_borks?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@&since=%@&limit=%i&username=%@", authToken, time, limit, username]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:postString]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSError* error = nil;
                               callback([NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]);
                           }];
}

+ (void)fetchOlderUserBorks:(NSUInteger)limit before:(NSString *)time withUser:(NSString *)username withCallback:(void (^)(NSArray *olderBorks))callback
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"user_borks?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@&older_than=%@&limit=%i&username=%@", authToken, time, limit, username]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:postString]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSError* error = nil;
                               callback([NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]);
                           }];
}
+ (NSString *)getUserIDWithUsername:(NSString *)username
{
    
    NSString *getString = [appRootPath stringByAppendingPathComponent:@"user_id?"];
    getString = [getString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@&username=%@", authToken, username]];
    NSURL *url = [NSURL URLWithString:getString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError* error = nil;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return [response objectForKey:@"user_id"];
}
@end