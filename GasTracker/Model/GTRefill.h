//
//  GTRefill.h
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GTRefill : NSManagedObject

@property (nonatomic, retain) NSDate * day;
@property (nonatomic, retain) NSDecimalNumber * liters;
@property (nonatomic, retain) NSDecimalNumber * pricePerLiter;
@property (nonatomic, retain) NSDecimalNumber * odometer;

@end
