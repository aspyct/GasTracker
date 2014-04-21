//
//  GTRefillStore.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTRefillStore.h"
#import "GTRefill+Extension.h"

@interface GTRefillStore ()

// Computation of the average consumption is heavy. Let's cache it.
@property (strong, nonatomic) NSDecimalNumber *averageConsumption;

@end

@implementation GTRefillStore

- (void)dataModified
{
    [super dataModified];
    
    _averageConsumption = nil;
}

- (NSDecimalNumber *)averageConsumption
{
    if (_averageConsumption == nil) {
        NSFetchRequest *request = [self baseRequest];
        request.fetchLimit = 100;
        
        NSArray *results = [self fetch:request];
        
        _averageConsumption = [GTRefill averageConsumption:results];
    }
    
    return _averageConsumption;
}

- (NSDecimalNumber *)latestPrice
{
    NSFetchRequest *request = [self baseRequest];
    request.fetchLimit = 1;
    
    NSArray *result = [self fetch:request];
    if (result.count > 0) {
        GTRefill *latestRefill = result[0];
        return latestRefill.pricePerLiter;
    } else {
        return nil;
    }
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
    return [self baseRequestAscending:NO];
}

- (NSFetchRequest *)baseRequestAscending:(BOOL)ascending
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Refill"];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:ascending]]];
    
    return request;
}

@end
