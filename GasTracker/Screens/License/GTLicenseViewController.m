//
//  GTLicenseViewController.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 22/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTLicenseViewController.h"

@interface GTLicenseViewController ()

/**
 * This property is set in the UI builder
 */
@property (strong, nonatomic) NSString *website;

@end

@implementation GTLicenseViewController

- (IBAction)doOpenInSafari:(id)sender {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"Open in Safari", nil];
    
    [as showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // Open in Safari
        NSURL *website = [NSURL URLWithString:self.website];
        [[UIApplication sharedApplication] openURL:website];
    }
}

@end
