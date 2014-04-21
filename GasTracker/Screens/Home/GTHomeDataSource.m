//
//  GTHomeDataSource.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTHomeDataSource.h"
#import "GTConsumptionCell.h"
#import "GTRecentRefillCell.h"

typedef enum {
    GTHomeDataSourceSectionConsumption,
    GTHomeDataSourceSectionRecent,
    
    GTHomeDataSourceSectionFirst = GTHomeDataSourceSectionConsumption,
    GTHomeDataSourceSectionLast = GTHomeDataSourceSectionRecent,
    GTHomeDataSourceSectionCount = GTHomeDataSourceSectionLast + 1
} GTHomeDataSourceSection;

typedef enum {
    GTHomeDataSourceSubsectionAverage,
    GTHomeDataSourceSubsectionPrice,
    GTHomeDataSourceSubsectionPerMonth,
    
    GTHomeDataSourceSubsectionFirst = GTHomeDataSourceSubsectionAverage,
    GTHomeDataSourceSubsectionLast = GTHomeDataSourceSubsectionPrice,
    GTHomeDataSourceSubsectionCount = GTHomeDataSourceSubsectionLast + 1
} GTHomeDataSourceSubsection;

@interface GTHomeDataSource ()

@property (strong, nonatomic) IBOutlet GTRefillStore *refillStore;
@property (strong, nonatomic) NSArray *recentRefills;

@end

@implementation GTHomeDataSource

- (void)setRefillStore:(GTRefillStore *)refillStore
{
    if (_refillStore != refillStore) {
        [_refillStore removeDatabaseObserver:self];
        [refillStore addDatabaseObserver:self];
        
        _refillStore = refillStore;
    }
}

- (void)dataModified
{
    _recentRefills = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == GTHomeDataSourceSectionConsumption) {
        return [self consumptionSummaryCellForRow:indexPath.row from:tableView];
    } else {
        return [self latestRefillCellForRow:indexPath.row from:tableView];
    }
}


- (UITableViewCell *)consumptionSummaryCellForRow:(NSInteger)row from:(UITableView *)tableView
{
    GTConsumptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"consumption"];
    
    switch (row) {
        case GTHomeDataSourceSubsectionAverage:
        {
            NSDecimalNumber *avg = [self.refillStore averageConsumption];
            [cell setTitle:@"L/100km" andValue:avg.stringValue];
            break;
        }
        case GTHomeDataSourceSubsectionPrice:
        {
            NSDecimalNumber *avg = [self.refillStore averageConsumption];
            NSDecimalNumber *price = [avg decimalNumberByMultiplyingBy:[self.refillStore latestPrice]];
            [cell setTitle:@"€/100km" andValue:price.stringValue];
            break;
        }
        case GTHomeDataSourceSubsectionPerMonth:
            [cell setTitle:@"€/month" andValue:@"16.48€"];
            break;
    }
    
    return cell;
}


- (UITableViewCell *)latestRefillCellForRow:(NSInteger)row from:(UITableView *)tableView
{
    if (self.recentRefills.count > 0) {
        GTRecentRefillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refill"];
        cell.refill = [self.recentRefills objectAtIndex:row];
        
        return cell;
    } else {
        return [tableView dequeueReusableCellWithIdentifier:@"no-refill"];
    }
}


- (GTConsumptionCell *)aKeyValueCellFrom:(UITableView *)tableView
{
    return [tableView dequeueReusableCellWithIdentifier:@"consumption"];
}


- (NSArray *)recentRefills
{
    if (_recentRefills == nil) {
        _recentRefills = [self.refillStore recentRefills];
    }
    
    return _recentRefills;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // two sections:
    // - consumption summary
    // - latest refills
    return GTHomeDataSourceSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == GTHomeDataSourceSectionConsumption) {
        return GTHomeDataSourceSubsectionCount;
    } else if (self.recentRefills.count > 0) {
        return self.recentRefills.count;
    } else {
        // Display default cell
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == GTHomeDataSourceSectionConsumption) {
        return @"Summary";
    } else {
        return @"Recent refills";
    }
}

@end
