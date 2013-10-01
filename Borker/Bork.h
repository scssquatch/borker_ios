//
//  Bork.h
//  Borker
//
//  Created by Aaron Baker on 10/1/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bork : NSObject
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *timestamp;
@property (strong, nonatomic) UIImage *avatar;
@property (assign, nonatomic) BOOL favorited;
@end
