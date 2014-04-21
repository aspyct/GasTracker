//
//  GTRefillStore.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTRefillStore.h"

@implementation GTRefillStore

- (NSArray *)lastHundredRefills
{
    NSFetchRequest *request = [self baseRequest];
    request.fetchLimit = 100;
    
    return [self fetch:request];
}

- (NSArray *)recentRefills
{
    NSFetchRequest *request = [self baseRequest];
    request.fetchLimit = 5;
    
    return [self fetch:request];
}

- (GTRefill *)buildRefill
{
    NSEntityDescription *refillDescription = [NSEntityDescription entityForName:@"Refill"
                                                         inManagedObjectContext:self.managedObjectContext];
    
    return [[GTRefill alloc] initWithEntity:refillDescription
             insertIntoManagedObjectContext:self.managedObjectContext];
}

- (BOOL)saveRefill:(GTRefill *)refill
{
    [self.managedObjectContext insertObject:refill];
    [self.managedObjectContext save:nil];
    return YES;
}

#pragma mark - Private stuff

- (NSFetchRequest *)baseRequest
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Refill"];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:NO]]];
    
    return request;
}

@end
