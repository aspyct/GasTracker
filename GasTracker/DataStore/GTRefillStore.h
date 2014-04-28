//
//  GTRefillStore.h
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTDataStore.h"
#import "GTRefill.h"

@interface GTRefillStore : GTDataStore

/**
 * The 5 most recent refills
 */
@property (readonly) NSArray *recentRefills;

/**
 * The price per liter, or nil if there's no known fillup
 */
@property (readonly) NSDecimalNumber *latestPrice;

/**
 * The average consumption, or nil if unknown
 *
 * It is expressed in liters / 100km.
 * Scans only the last 100 refills.
 * In these refills, it needs at least two with odometer record.
 */
@property (readonly) NSDecimalNumber *averageConsumption;

- (GTRefill *)buildRefill;
- (BOOL)saveRefill:(GTRefill *)refill;
- (BOOL)deleteRefill:(GTRefill *)refill;

@end
