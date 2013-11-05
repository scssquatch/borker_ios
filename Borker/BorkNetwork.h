//
//  BorkNetwork.h
//  Borker
//
//  Created by Neo on 9/17/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorkNetwork : NSObject
+ (BOOL)createBork:(NSString *)bork user:(NSString *)username;
+ (BOOL)deleteBork:(NSString *)bork_id user:(NSString *)username;
+ (void)toggleBorkFavorite:(NSString *)bork_id user:(NSString *)username favorited:(BOOL)favorited withCallback:(void (^)(NSArray *parsedJSON))callback;
+ (NSArray *)fetchBorks:(NSUInteger)limit since:(NSString *)time;
+ (void)getBorkFavorites:(NSString *)bork_id withCallback:(void (^)(NSArray *parsedJSON))callback;
+ (void)fetchOlderBorks:(NSUInteger)limit before:(NSString *)time withCallback:(void (^)(NSArray *olderBorks))callback;
@end
