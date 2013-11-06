//
//  BorkCoreDataManager.h
//  Borker
//
//  Created by Aaron Baker on 11/5/13.
//  Copyright (c) 2013 Borker Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BorkCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (NSManagedObjectContext *)getManagedObjectContext;
- (void)populateUsers;
@end
