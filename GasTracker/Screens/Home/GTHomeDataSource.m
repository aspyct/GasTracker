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

@end

@implementation GTHomeDataSource

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
            [cell setTitle:@"L/100km" andValue:[self formatVolume:avg]];
            break;
        }
        case GTHomeDataSourceSubsectionPrice:
        {
            NSDecimalNumber *avg = [self.refillStore averageConsumption];
            NSDecimalNumber *price = [avg decimalNumberByMultiplyingBy:[self.refillStore latestPrice]];
            [cell setTitle:@"€/100km" andValue:[self formatPrice:price]];
            break;
        }
        case GTHomeDataSourceSubsectionPerMonth:
            [cell setTitle:@"€/month" andValue:@"16.48€"];
            break;
    }
    
    return cell;
}


- (NSString *)formatVolume:(NSDecimalNumber *)volume
{
    return [[self formatDecimal:volume] stringByAppendingString:@"L"];
}


- (NSString *)formatPrice:(NSDecimalNumber *)price
{
    return [[self formatDecimal:price] stringByAppendingString:@"€"];
}


- (NSString *)formatDecimal:(NSDecimalNumber *)decimal
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.maximumFractionDigits = 2;
    
    return [formatter stringFromNumber:decimal];
}


- (UITableViewCell *)latestRefillCellForRow:(NSInteger)row from:(UITableView *)tableView
{
    if (self.refillStore.recentRefills.count > 0) {
        GTRecentRefillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"refill"];
        cell.refill = [self refillForRow:row];
        
        return cell;
    } else {
        return [tableView dequeueReusableCellWithIdentifier:@"no-refill"];
    }
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
    } else if (self.refillStore.recentRefills.count > 0) {
        return self.refillStore.recentRefills.count;
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

#pragma mark - Getting the refills

- (GTRefill *)refillForRow:(NSInteger)row
{
    return [self.refillStore.recentRefills objectAtIndex:row];
}

#pragma mark - Recent refills editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section == GTHomeDataSourceSectionRecent;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the refill
        GTRefill *toBeDeleted = [self refillForRow:indexPath.row];
        [self.refillStore deleteRefill:toBeDeleted];
        
        // Update the table
        if (self.refillStore.recentRefills.count > 0) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            // The above would assert-crash because the default row will be displayed
            [tableView reloadData];
        }
    }
}

@end
