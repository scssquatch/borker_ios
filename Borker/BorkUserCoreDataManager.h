//
//  BorkCoreDataManager.h
//  Borker
//
//  Created by Aaron Baker on 11/5/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BorkUserNetwork.h"
#import "BorkUser.h"

@interface BorkUserCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)populateUsers;
- (NSURL *)applicationDocumentsDirectory;
- (NSManagedObjectContext *)getManagedObjectContext;
- (BorkUser *)findByID:(NSString *)user_id;
@end
