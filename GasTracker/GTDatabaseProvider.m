//
//  GTCoreDataManager.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTDatabaseProvider.h"
#import "GTAppDelegate.h"

@interface GTDatabaseProvider ()

@property (readonly) GTAppDelegate *appDelegate;
@property (readonly) NSManagedObjectContext *managedObjectContext;
@property (readonly) NSManagedObjectModel *managedObjectModel;
@property (readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSMutableSet *databaseObservers;

@end

@implementation GTDatabaseProvider

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
    for (id<GTDatabaseObserver> observer in self.databaseObservers) {
        [observer databaseModified];
    }
}

- (void)addDatabaseObserver:(id<GTDatabaseObserver>)observer
{
    if (self.databaseObservers == nil) {
        self.databaseObservers = [[NSMutableSet alloc] initWithCapacity:5];
    }
    
    [self.databaseObservers addObject:observer];
}

- (void)removeDatabaseObserver:(id<GTDatabaseObserver>)observer
{
    [self.databaseObservers removeObject:observer];
}

- (NSFetchRequest *)allRefills
{
    return [self.managedObjectModel fetchRequestTemplateForName:@"AllRefills"];
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
