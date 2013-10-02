//
//  BorkUser.h
//  Borker
//
//  Created by Neo on 9/16/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorkUser : NSObject
+ (BorkUser *)findByID:(NSString *)userID;
+ (void)logoutCurrentUser;
- (void)requestUsers;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) NSArray *userIDs;
@end
