//
//  GTRefillViewController.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTRefillViewController.h"
#import "GTRefillStore.h"
#import "GTRefill.h"

@interface GTRefillViewController ()

@property (weak, nonatomic) IBOutlet UITextField *volume;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *day;
@property (weak, nonatomic) IBOutlet UITextField *odometer;
@property (strong, nonatomic) IBOutlet GTRefillStore *refillStore;

@end

@implementation GTRefillViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.volume becomeFirstResponder];
    
    NSDecimalNumber *latestPrice = [self.refillStore latestPrice];
    if (latestPrice != nil) {
        self.price.placeholder = latestPrice.stringValue;
    }
}

- (IBAction)doSave:(id)sender {
    GTRefill *refill = [self.refillStore buildRefill];
    refill.liters = [self decimalFromString:self.volume.text];
    
    // The price per liter is either specified by user, or the last known value
    if (self.price.text.length > 0) {
        refill.pricePerLiter = [self decimalFromString:self.price.text];
    } else {
        refill.pricePerLiter = self.refillStore.latestPrice;
    }

    if (self.odometer.text.length > 0) {
        refill.odometer = [self decimalFromString:self.odometer.text];
    }
    
    refill.day = [NSDate date];
    
    [self.refillStore saveRefill:refill];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Conversion

- (NSDecimalNumber *)decimalFromString:(NSString *)string
{
    if (string.length > 0) {
        return [NSDecimalNumber decimalNumberWithString:string locale:[NSLocale currentLocale]];
    } else {
        return nil;
    }
}

@end
