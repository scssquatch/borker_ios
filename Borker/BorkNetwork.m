//
//  BorkNetwork.m
//  Borker
//
//  Created by Neo on 9/17/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkNetwork.h"
#import "KeychainItemWrapper.h"

@interface BorkNetwork ()
@property (strong, nonatomic) KeychainItemWrapper *keychainWrapper;
@end

@implementation BorkNetwork
- (id)init
{
    self = [super init];
    if (self) {
        self.keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"borkCredentials" accessGroup:nil];
    }
    return self;
}
- (NSArray *)fetchBorks:(NSUInteger)limit since:(NSString *)time
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"api/nottweets?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@", authToken]];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"&since=%@", time]];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"&limit=%i", limit]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:postString]];
    __autoreleasing NSError* error = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

- (NSArray *)fetchOlderBorks:(NSUInteger)limit before:(NSString *)time
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"api/nottweets?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"api_key=%@&older_than=%@&limit=%i", authToken, time, limit]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:postString]];
    __autoreleasing NSError* error = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

- (BOOL)createBork:(NSString *)bork
{
    NSString *username = [self.keychainWrapper objectForKey:(__bridge id)kSecAttrAccount];
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"api/nottweets?"];
    NSString *strippedBork = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)bork, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8));
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"content=%@&username=%@&api_key=%@", strippedBork, username, authToken]];
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
