//
//  BorkCredentials.h
//  Borker
//
//  Created by Aaron Baker on 9/27/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorkCredentials : NSObject
@property (strong, nonatomic) NSString *username;
- (void)logOut;
+ (id)sharedInstance;
@end
