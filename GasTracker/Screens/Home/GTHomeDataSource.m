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
    GTHomeDataSourceSubsectionLast = GTHomeDataSourceSubsectionPerMonth,
    GTHomeDataSourceSubsectionCount = GTHomeDataSourceSubsectionLast + 1
} GTHomeDataSourceSubsection;

@interface GTHomeDataSource ()

@property (strong, nonatomic) IBOutlet GTRefillStore *refillStore;
@property (strong, nonatomic) NSArray *recentRefills;

@end

@implementation GTHomeDataSource

- (void)setRefillStore:(GTDataStore *)coreDataProvider
{
    if (_refillStore != coreDataProvider) {
        [_refillStore removeDatabaseObserver:self];
        [coreDataProvider addDatabaseObserver:self];
        
        _refillStore = coreDataProvider;
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
            [cell setTitle:@"Average / 100km" andValue:@"4.52L"];
            break;
        case GTHomeDataSourceSubsectionPrice:
            [cell setTitle:@"Price / 100km" andValue:@"7.12€"];
            break;
        case GTHomeDataSourceSubsectionPerMonth:
            [cell setTitle:@"Per month" andValue:@"16.48€"];
            break;
    }
    
    return cell;
}


- (UITableViewCell *)latestRefillCellForRow:(NSInteger)row from:(UITableView *)tableView
{
    GTRecentRefillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refill"];
    cell.refill = [self.recentRefills objectAtIndex:row];
    
    return cell;
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
    } else {
        return self.recentRefills.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == GTHomeDataSourceSectionConsumption) {
        return @"Consumption summary";
    } else {
        return @"Recent refills";
    }
}

@end
