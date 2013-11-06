//
//  BorkUser.h
//  Borker
//
//  Created by Aaron Baker on 11/5/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BorkUser : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString *avatarURL;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString *avatarThumbURL;

@end
