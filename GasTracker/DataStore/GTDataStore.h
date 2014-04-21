//
//  GTCoreDataManager.h
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GTDataObserver <NSObject>

@required
- (void)dataModified;

@end

@interface GTDataStore : NSObject <GTDataObserver>

@property (readonly) NSManagedObjectContext *managedObjectContext;
@property (readonly) NSManagedObjectModel *managedObjectModel;
@property (readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (id)fetch:(NSFetchRequest *)request;
- (void)addDatabaseObserver:(id<GTDataObserver>)listener;
- (void)removeDatabaseObserver:(id<GTDataObserver>)listener;

@end
