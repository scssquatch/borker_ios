//
//  BorkNetwork.h
//  Borker
//
//  Created by Neo on 9/17/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorkNetwork : NSObject
- (NSArray *)fetchBorks;
- (BOOL)createBork:(NSString *)bork;
@end
