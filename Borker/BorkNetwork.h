//
//  BorkNetwork.h
//  Borker
//
//  Created by Neo on 9/17/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorkNetwork : NSObject
- (BOOL)createBork:(NSString *)bork;
- (NSArray *)fetchBorks:(NSUInteger)limit since:(NSString *)time;
- (NSArray *)fetchOlderBorks:(NSUInteger)limit before:(NSString *)time;
@end
