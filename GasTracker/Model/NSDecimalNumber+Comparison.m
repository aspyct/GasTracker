//
//  NSDecimalNumber+Comparison.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "NSDecimalNumber+Comparison.h"

@implementation NSDecimalNumber (Comparison)

- (BOOL)isNonZero
{
    return [self compare:[NSDecimalNumber zero]] != NSOrderedSame;
}

@end
