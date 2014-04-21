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
- (NSArray *)lastHundredRefills;
- (GTRefill *)buildRefill;
- (BOOL)saveRefill:(GTRefill *)refill;

@end
