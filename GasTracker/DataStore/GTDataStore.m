//
//  GTCoreDataManager.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTDataStore.h"
#import "GTAppDelegate.h"

@interface GTDataStore ()

@property (readonly) GTAppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableSet *databaseObservers;

@end

@implementation GTDataStore

- (id)init
{
    self = [super init];
    
    if (self) {
        [self registerForSaveEvents];
    }
    
    return self;
}

- (void)dealloc
{
    [self unregisterForSaveEvents];
}

- (void)dataModified
{
    // Override me
}

- (void)registerForSaveEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(databaseModified:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
}

- (void)unregisterForSaveEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSManagedObjectContextDidSaveNotification
                                                  object:nil];
}

- (void)databaseModified:(NSNotification *)notification
{
    [self dataModified];
    
    for (id<GTDataObserver> observer in self.databaseObservers) {
        [observer dataModified];
    }
}

- (void)addDatabaseObserver:(id<GTDataObserver>)observer
{
    if (self.databaseObservers == nil) {
        self.databaseObservers = [[NSMutableSet alloc] initWithCapacity:5];
    }
    
    [self.databaseObservers addObject:observer];
}

- (void)removeDatabaseObserver:(id<GTDataObserver>)observer
{
    [self.databaseObservers removeObject:observer];
}

- (NSArray *)fetch:(NSFetchRequest *)request
{
    return [self.managedObjectContext executeFetchRequest:request error:nil];
}

- (NSManagedObjectContext *)managedObjectContext
{
    return self.appDelegate.managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel
{
    return self.appDelegate.managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    return self.appDelegate.persistentStoreCoordinator;
}


- (GTAppDelegate *)appDelegate
{
    return [UIApplication sharedApplication].delegate;
}

@end
