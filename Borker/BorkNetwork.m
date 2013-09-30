//
//  BorkNetwork.m
//  Borker
//
//  Created by Neo on 9/17/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkNetwork.h"

@implementation BorkNetwork
+ (NSArray *)fetchBorks:(NSUInteger)limit since:(NSString *)time
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"api/borks?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@&since=%@&limit=%i", authToken, time, limit]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:postString]];
    NSError* error = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

+ (void)fetchOlderBorks:(NSUInteger)limit before:(NSString *)time withCallback:(void (^)(NSArray *parsedJSON))callback
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"api/borks?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@&older_than=%@&limit=%i", authToken, time, limit]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:postString]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError* error = nil;
        callback([NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]);
    }];
    
}

+ (BOOL)createBork:(NSString *)bork user:(NSString *)username
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"api/borks?"];
    NSString *strippedBork = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)bork, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"content=%@&username=%@&api_key=%@", strippedBork, username, authToken]];
    NSURL *url = [NSURL URLWithString:postString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    NSError *error = nil;
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

+ (BOOL)deleteBork:(NSString *)bork_id user:(NSString *)username
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"api/borks?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"bork_id=%@&username=%@&api_key=%@", bork_id, username, authToken]];
    NSURL *url = [NSURL URLWithString:postString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"DELETE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    NSError *error = nil;
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

+ (void)toggleBorkFavorite:(NSString *)bork_id user:(NSString *)username favorited:(BOOL)favorited withCallback:(void (^)(NSArray *parsedJSON))callback
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"api/favorites?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@&bork_id=%@&username=%@", authToken, bork_id, username]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postString]];
    if (favorited) {
        [request setHTTPMethod:@"DELETE"];
    } else {
        [request setHTTPMethod:@"POST"];
    }
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSError* error = nil;
                               callback([NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]);
                           }];
}
@end
