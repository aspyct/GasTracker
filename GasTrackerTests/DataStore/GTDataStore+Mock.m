//
//  GTDataStore+Mock.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 28/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import <OCMock/OCMock.h>

#import "GTDataStore+Mock.h"

@implementation GTDataStore (Mock)

- (id)mockDataStore
{
    // Create an in-memory database
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    
    // Get the model
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GasTracker" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // Create the persistent store coordinator
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    // Create the context
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];

    // Mock the object
    id mock = [OCMockObject partialMockForObject:self];
    [(GTDataStore *)[[mock stub] andReturn:managedObjectModel] managedObjectModel];
    [(GTDataStore *)[[mock stub] andReturn:managedObjectContext] managedObjectContext];
    [(GTDataStore *)[[mock stub] andReturn:persistentStoreCoordinator] persistentStoreCoordinator];
    
    // And Voilà !
    return mock;
}

@end
