//
//  GTRefillTests.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 28/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "GTRefill.h"
#import "GTRefill+Extension.h"
#import "GTRefillStore.h"
#import "GTDataStore+Mock.h"

#define EXPECT_AVERAGE(message, expect, refills) \
    NSDecimalNumber *average = [self averageConsumption:(refills)]; \
    if ((expect) == nil) { \
        XCTAssertNil(average, message); \
    } else { \
        NSNumber *expected = [self decimal:(expect)]; \
        XCTAssertEqualObjects(average, expected, message); \
    }

@interface GTRefillTests : XCTestCase

@property (strong, nonatomic) GTRefillStore *refillStore;

@end

@implementation GTRefillTests

- (void)setUp
{
    [super setUp];
    
    self.refillStore = [[[GTRefillStore alloc] init] mockDataStore];
}

- (void)testCalculatesAverageConsumptionBetweenToMileages
{
    EXPECT_AVERAGE(@"Must compute average between two successive refills", @2.5, (@[@8, @100,
                                                                                  @5, @300]));
}

- (void)testNeedsTwoOdometerMarksForAverage
{
    EXPECT_AVERAGE(@"No average can be found out of nothing", nil, (@[]));
}

- (void)testNeedsTwoOdometerMarksForAverage2
{
    EXPECT_AVERAGE(@"Need at least two datapoints", nil, (@[@8, @100]));
}

- (void)testNeedsTwoOdometerMarksForAverage3
{
    EXPECT_AVERAGE(@"Need at least two datapoints", nil, (@[@8, [NSNull null]]));
}

- (void)testNeedsTwoOdometerMarksForAverage4
{
    EXPECT_AVERAGE(@"Need at least two odometer marks", nil, (@[@8, @100,
                                                                @5, [NSNull null]]));
}

- (void)testAcceptsGapsInRefillArray
{
    EXPECT_AVERAGE(@"Must be able to collapse gaps", @2.5, (@[@3, @100,
                                                              @2, [NSNull null],
                                                              @3, @300]));
}

#pragma mark - helpers

- (NSDecimalNumber *)averageConsumption:(NSArray *)dataPoints
{
    NSAssert((dataPoints.count & 1) == 0, @"Must be an even number");
    
    NSInteger i;
    NSMutableArray *refills = [NSMutableArray arrayWithCapacity:dataPoints.count / 2];
    
    // Must provide the refills in reverse order
    for (i = dataPoints.count; i > 0; i -= 2) {
        GTRefill *refill = [self.refillStore buildRefill];
        
        NSNumber *liters = dataPoints[i - 2];
        NSNumber *odometer = dataPoints[i - 1];
        
        refill.liters = [self decimal:liters];
        refill.odometer = [self decimal:odometer];
        
        [refills addObject:refill];
    }
    
    return [GTRefill averageConsumption:refills];
}

- (NSDecimalNumber *)decimal:(id)number
{
    if ([NSNull null] != number) {
        return [NSDecimalNumber decimalNumberWithDecimal:((NSNumber *)number).decimalValue];
    } else {
        return nil;
    }
}

@end
