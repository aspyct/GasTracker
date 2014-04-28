//
//  GTDataStore+Mock.h
//  GasTracker
//
//  Created by Antoine d'Otreppe on 28/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTDataStore.h"

@interface GTDataStore (Mock)

/**
 * Turn this datastore into a mock, by replacing the model object context
 * to an in-memory database.
 */
- (id)mockDataStore;

@end
