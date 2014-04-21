//
//  GTRefill+Extension.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTRefill+Extension.h"
#import "GTPreludeArray.h"
#import "NSDecimalNumber+Comparison.h"

@implementation GTRefill (Extension)

- (NSDecimalNumber *)totalPrice
{
    return [self.liters decimalNumberByMultiplyingBy:self.pricePerLiter];
}

+ (NSDecimalNumber *)averageConsumption:(NSArray *)refills
{
    GTPreludeArray *array = [[GTPreludeArray arrayWithArray:refills] inverted];
    return [self averageConsumption:array
                        odometerMin:nil
                        odometerMax:nil
                   totalConsumption:[NSDecimalNumber zero]
                      sinceLastMark:[NSDecimalNumber zero]];
}

+ (NSDecimalNumber *)averageConsumption:(GTPreludeArray *)refills
                            odometerMin:(NSDecimalNumber *)odometerMin
                            odometerMax:(NSDecimalNumber *)odometerMax
                       totalConsumption:(NSDecimalNumber *)totalConsumption
                          sinceLastMark:(NSDecimalNumber *)stagedConsumption
{
    GTRefill *head = refills.head;
    
    if (head == nil) {
        // We reached the end of the array. Finish him!
        NSDecimalNumber *hundred = [NSDecimalNumber decimalNumberWithMantissa:1 exponent:2 isNegative:NO];
        NSDecimalNumber *totalDistance = [odometerMax decimalNumberBySubtracting:odometerMin];
        NSDecimalNumber *hundredKilometers = [totalDistance decimalNumberByDividingBy:hundred];
        
        if (hundredKilometers != nil) {
            NSDecimalNumber *averageConsumption = [totalConsumption decimalNumberByDividingBy:hundredKilometers];
            
            // EXIT POINT
            return averageConsumption;
        } else {
            // EXIT POINT
            return nil;
        }
    } else if (odometerMin == nil) {
        odometerMin = [head.odometer isNonZero] ? head.odometer : nil;
    } else {
        stagedConsumption = [stagedConsumption decimalNumberByAdding:head.liters];
        
        if ([head.odometer isNonZero]) {
            odometerMax = head.odometer;
            totalConsumption = [totalConsumption decimalNumberByAdding:stagedConsumption];
            stagedConsumption = [NSDecimalNumber zero];
        }
    }
    
    // tail recursive :)
    return [self averageConsumption:refills.tail
                        odometerMin:odometerMin
                        odometerMax:odometerMax
                   totalConsumption:totalConsumption
                      sinceLastMark:stagedConsumption];
}

@end
