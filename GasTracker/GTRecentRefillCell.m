//
//  GTRecentRefillCell.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTRecentRefillCell.h"
#import "TTTTimeIntervalFormatter.h"
#import "GTRefill+Extension.h"

@interface GTRecentRefillCell ()

@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) IBOutlet UILabel *day;

@end

@implementation GTRecentRefillCell

- (void)setRefill:(GTRefill *)refill
{
    if (_refill != refill) {
        _refill = refill;
        [self updateView:refill];
    }
}

- (void)updateView:(GTRefill *)refill
{
    TTTTimeIntervalFormatter *formatter = [[TTTTimeIntervalFormatter alloc] init];
    NSTimeInterval since = [refill.day timeIntervalSinceNow];
    self.day.text = [formatter stringForTimeInterval:since];
    self.value.text = [refill.liters.stringValue stringByAppendingString:@"L"];
}

@end
