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
}

- (IBAction)doSave:(id)sender {
    GTRefill *refill = [self.refillStore buildRefill];
    refill.liters = [NSDecimalNumber decimalNumberWithString:self.volume.text];
    refill.pricePerLiter = [NSDecimalNumber decimalNumberWithString:self.price.text];
    
    if (self.odometer.text.length > 0) {
        refill.odometer = [NSDecimalNumber decimalNumberWithString:self.odometer.text];
    }
    
    refill.day = [NSDate date];
    
    [self.refillStore saveRefill:refill];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
