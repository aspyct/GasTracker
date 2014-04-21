//
//  GTRefillStore.h
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTDataStore.h"

@interface GTRefillStore : GTDataStore

- (NSArray *)recentRefills;
- (GTRefill *)buildRefill;
- (BOOL)saveRefill:(GTRefill *)refill;

/**
 * Get the price per liter of the latest fill up.
 *
 * @return the price per liter, or nil if there's no known fillup
 */
- (NSDecimalNumber *)latestPrice;


- (NSDecimalNumber *)averageConsumption;

@end
