//
//  BorkerAPILayer.h
//  Borker
//
//  Created by Neo on 9/17/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorkUserNetwork : NSObject
+ (NSArray *)fetchUsers;
+ (void)authenticateUser:(NSString *)username withPassword:(NSString *)password withCallback:(void (^)(BOOL authenticated))callback;
+ (void)addToken:(NSString *)token withUsername:(NSString *)username;
+ (NSArray *)getFavorites:(NSString *)username;
+ (void)fetchUserBorks:(NSUInteger)limit since:(NSString *)time withUser:(NSString *)username withCallback:(void (^)(NSArray *olderBorks))callback;
+ (void)fetchOlderUserBorks:(NSUInteger)limit before:(NSString *)time withUser:(NSString *)username withCallback:(void (^)(NSArray *olderBorks))callback;
+ (NSString *)getUserIDWithUsername:(NSString *)username;
@end
