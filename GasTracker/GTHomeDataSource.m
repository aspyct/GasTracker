//
//  GTHomeDataSource.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTHomeDataSource.h"
#import "GTKeyValueTableViewCell.h"

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

@property (strong, nonatomic) NSArray *recentRefills;

@end

@implementation GTHomeDataSource

- (void)setCoreDataProvider:(GTDatabaseProvider *)coreDataProvider
{
    if (_coreDataProvider != coreDataProvider) {
        [_coreDataProvider removeDatabaseObserver:self];
        [coreDataProvider addDatabaseObserver:self];
        
        _coreDataProvider = coreDataProvider;
    }
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
    GTKeyValueTableViewCell *cell = [self aKeyValueCellFrom:tableView];
    
    switch (row) {
        case GTHomeDataSourceSubsectionAverage:
            [cell setKey:@"Average / 100km" andValue:@"4.52L"];
            break;
        case GTHomeDataSourceSubsectionPrice:
            [cell setKey:@"Price / 100km" andValue:@"7.12€"];
            break;
        case GTHomeDataSourceSubsectionPerMonth:
            [cell setKey:@"Per month" andValue:@"16.48L"];
            break;
    }
    
    return cell;
}


- (UITableViewCell *)latestRefillCellForRow:(NSInteger)row from:(UITableView *)tableView
{
    GTKeyValueTableViewCell *cell = [self aKeyValueCellFrom:tableView];
    
    
    [cell setKey:@"Relative date" andValue:@"4.57L / 10€"];
    
    return cell;
}


- (GTKeyValueTableViewCell *)aKeyValueCellFrom:(UITableView *)tableView
{
    return [tableView dequeueReusableCellWithIdentifier:@"keyvalue"];
}


- (NSArray *)recentRefills
{
    if (_recentRefills == nil) {
        NSFetchRequest *allRefills = [self.coreDataProvider allRefills];
        allRefills.fetchLimit = 5;
        
        _recentRefills = [self.coreDataProvider fetch:allRefills];
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
