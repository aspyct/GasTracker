//
//  GTHomeDataSource.h
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTDatabaseProvider.h"

@interface GTHomeDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, GTDatabaseObserver>

@property (strong, nonatomic) IBOutlet GTDatabaseProvider *coreDataProvider;

@end
