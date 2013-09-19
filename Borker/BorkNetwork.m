//
//  BorkNetwork.m
//  Borker
//
//  Created by Neo on 9/17/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkNetwork.h"
@implementation BorkNetwork
- (NSArray *)fetchBorks
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[appRootPath stringByAppendingPathComponent:@"borks_for_app.json"]]];
    __autoreleasing NSError* error = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

- (BOOL)createBork:(NSString *)bork
{
    NSString *postString = [appRootPath stringByAppendingPathComponent:@"authenticate?"];
    postString = [postString stringByAppendingString:[NSString stringWithFormat:@"content=%@", bork]];
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
