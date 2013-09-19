//
//  BorkNetwork.m
//  Borker
//
//  Created by Neo on 9/17/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkNetwork.h"

static NSString * const appRootPath = @"https://borker.herokuapp.com";

@implementation BorkNetwork

- (NSArray *)fetchBorks
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[appRootPath stringByAppendingPathComponent:@"borks_for_app.json"]]];
    __autoreleasing NSError* error = nil;
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

- (BOOL)createBork:(NSString *)bork
{
    
}
@end
