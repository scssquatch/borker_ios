//
//  BorkNotificationNetwork.h
//  Borker
//
//  Created by Aaron Baker on 10/1/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorkNotificationNetwork : NSObject
+ (NSArray *)fetchNotifications:(NSString *)username withLimit:(NSUInteger)limit since:(NSString *)time;
+ (NSArray *)fetchOlderNotifications:(NSString *)username withLimit:(NSUInteger)limit before:(NSString *)time;
@end
