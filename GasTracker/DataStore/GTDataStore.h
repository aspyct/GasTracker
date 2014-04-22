//
//  GTCoreDataManager.h
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTDataStore : NSObject

@property (readonly) NSManagedObjectContext *managedObjectContext;
@property (readonly) NSManagedObjectModel *managedObjectModel;
@property (readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (id)fetch:(NSFetchRequest *)request;

/**
 * This method is called whenever the data store is modified.
 * 
 * Override it in subclasses to watch for the save event.
 * You may want to use this to invalidate caches.
 */
- (void)dataModified;

@end
