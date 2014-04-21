//
//  GTRefillStore.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTRefillStore.h"

@implementation GTRefillStore

- (NSDecimalNumber *)averageConsumption
{
    NSFetchRequest *request = [self baseRequestAscending:YES];
    request.fetchLimit = 100;
    NSArray *lastHundred = [self fetch:request];
    
    // The total consumption between odometerMin and odometerMax
    NSDecimalNumber *totalConsumption = [NSDecimalNumber zero];
    
    // The accumulator to use until the next odometer mark
    NSDecimalNumber *stagedTotalConsumption = [NSDecimalNumber zero];
    
    // The first odometer mark found
    NSDecimalNumber *odometerMin = nil;
    
    // The last odometer mark found
    NSDecimalNumber *odometerMax = nil;
    
    for (GTRefill *refill in lastHundred) {
        if ([refill.odometer compare:[NSDecimalNumber zero]] != NSOrderedSame) {
            // If we have an odometer mark
            if (odometerMin == nil) {
                // The first mark is the minimum we'll use
                odometerMin = refill.odometer;
            } else {
                // All subsequent marks must "flush" the staged consumption
                // and update the odometerMax
                odometerMax = refill.odometer;
                totalConsumption = [totalConsumption decimalNumberByAdding:stagedTotalConsumption];
            }
            
            if (odometerMin != nil) {
                // We started counting, so count on
                stagedTotalConsumption = [stagedTotalConsumption decimalNumberByAdding:refill.liters];
            }
        }
    }
    
    if (odometerMax != nil) {
        // 100, as a NSDecimalNumber
        NSDecimalNumber *hundred = [NSDecimalNumber decimalNumberWithMantissa:1 exponent:2 isNegative:NO];
        
        // How many times we ran 100km
        NSDecimalNumber *hundredKilometers = [[odometerMax decimalNumberBySubtracting:odometerMin] decimalNumberByDividingBy:hundred];
        
        // L/100km
        return [totalConsumption decimalNumberByDividingBy:hundredKilometers];
    } else {
        // We don't have enough data
        return nil;
    }
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
