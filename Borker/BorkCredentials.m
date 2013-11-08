//
//  BorkCredentials.m
//  Borker
//
//  Created by Aaron Baker on 9/27/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import "BorkCredentials.h"
#import "KeychainItemWrapper.h"

@interface BorkCredentials ()
@property (strong, nonatomic) KeychainItemWrapper *keychainWrapper;
@end
@implementation BorkCredentials
@synthesize username = _username;
- (id)init
{
    self = [super init];
    if (self) {
        self.keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"borkCredentials" accessGroup:nil];
    }
    return self;
}

- (NSString *)username
{
    if (!_username) {
        _username = [self.keychainWrapper objectForKey:(__bridge id)kSecAttrAccount];
    }
    return _username;
}

- (void)setUsername:(NSString *)username
{
    _username = nil;
    NSLog(@"set username to %@, 1: %@", username, [self.keychainWrapper objectForKey:(__bridge id)kSecAttrAccount]);
    [self.keychainWrapper setObject:username forKey:(__bridge id)(kSecAttrAccount)];
    NSLog(@"set username to %@, 2: %@", username, [self.keychainWrapper objectForKey:(__bridge id)kSecAttrAccount]);
}

- (void)logOut
{
    [self.keychainWrapper resetKeychainItem];
    NSLog(@"reset keychain: %@",[self.keychainWrapper objectForKey:(__bridge id)kSecAttrAccount]);
}

+ (id)sharedInstance
{
    static BorkCredentials *_creds;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _creds = [[BorkCredentials alloc] init];
    });
    return _creds;
}
@end
