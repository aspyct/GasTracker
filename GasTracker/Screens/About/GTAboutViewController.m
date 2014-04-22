//
//  GTAboutViewController.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 22/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTAboutViewController.h"

@interface GTAboutViewController ()

@end

@implementation GTAboutViewController

- (IBAction)doShare:(id)sender {
    NSArray *sharedItems = @[@"GasTracker helps you track gas consumption and expenses",
                             [NSURL URLWithString:@"http://aspyct.org"]];
    UIActivityViewController *share = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];
    [self presentViewController:share animated:YES completion:nil];
}

- (IBAction)doOpenResume:(id)sender {
    [self openUrl:@"http://resume.aspyct.org"];
}

- (IBAction)doOpenGithub:(id)sender {
    [self openUrl:@"https://github.com/aspyct/gastracker"];
}

- (void)openUrl:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

@end
