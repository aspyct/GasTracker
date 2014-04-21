//
//  GTCoreDataManager.h
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GTDatabaseObserver <NSObject>

@optional
- (void)databaseModified;

@end

@interface GTDatabaseProvider : NSObject

- (id)fetch:(NSFetchRequest *)request;
- (void)addDatabaseObserver:(id<GTDatabaseObserver>)listener;
- (void)removeDatabaseObserver:(id<GTDatabaseObserver>)listener;

- (NSFetchRequest *)allRefills;

@end
