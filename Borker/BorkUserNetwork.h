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
+ (BOOL)authenticateUser:(NSString *)username withPassword:(NSString *)password;
+ (void)addToken:(NSString *)token withUsername:(NSString *)username;
@end
