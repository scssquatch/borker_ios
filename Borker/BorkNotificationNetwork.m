//
//  BorkNotificationNetwork.m
//  Borker
//
//  Created by Aaron Baker on 10/1/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkNotificationNetwork.h"

@implementation BorkNotificationNetwork
+ (NSArray *)fetchNotifications:(NSString *)username withLimit:(NSUInteger)limit since:(NSString *)time
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"api/notifications?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@&username=%@&limit=%i&since=%@", authToken, username, limit, time]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:postString]];
    NSError* error = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}
+ (NSArray *)fetchOlderNotifications:(NSString *)username withLimit:(NSUInteger)limit before:(NSString *)time;
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"api/notifications?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@&username=%@&limit=%i&older_than=%@", authToken, username, limit, time]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:postString]];
    NSError* error = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}
@end
