//
//  GTPreludeArray.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTPreludeArray.h"

typedef enum {
    GTPreludeArrayDirectionNormal = 1,
    GTPreludeArrayDirectionInverted = -1
} GTPreludeArrayDirection;

@interface GTPreludeArray ()

/**
 * The original array
 */
@property (strong, nonatomic) NSArray *items;

/**
 * The lower limit index, inclusive
 */
@property (nonatomic) NSInteger lowerLimit;

/**
 * The upper limit, non inclusive
 */
@property (nonatomic) NSInteger upperLimit;

/**
 * The progression step. Indicates whether we are reverse
 */
@property (nonatomic) GTPreludeArrayDirection direction;

@end

@implementation GTPreludeArray

+ (GTPreludeArray *)arrayWithArray:(NSArray *)array
{
    GTPreludeArray *prelude = [[GTPreludeArray alloc] init];
    prelude.items = array;
    prelude.lowerLimit = 0;
    prelude.upperLimit = array.count;
    prelude.direction = GTPreludeArrayDirectionNormal;
    
    return prelude;
}

- (id)head
{
    if (self.upperLimit == self.lowerLimit) {
        return nil;
    } else if (self.direction == GTPreludeArrayDirectionNormal) {
        return [self.items objectAtIndex:self.lowerLimit];
    } else {
        return [self.items objectAtIndex:self.upperLimit - 1];
    }
}

- (GTPreludeArray *)tail
{
    NSUInteger lowerLimit = self.lowerLimit;
    NSUInteger upperLimit = self.upperLimit;
    
    if (self.direction == GTPreludeArrayDirectionNormal) {
        lowerLimit += 1;
    } else {
        upperLimit -= 1;
    }
    
    if (lowerLimit < upperLimit) {
        GTPreludeArray *prelude = [[GTPreludeArray alloc] init];
        prelude.items = self.items;
        prelude.lowerLimit = lowerLimit;
        prelude.upperLimit = upperLimit;
        prelude.direction = self.direction;
        
        return prelude;
    } else {
        return nil;
    }
}

- (GTPreludeArray *)inverted
{
    GTPreludeArray *prelude = [[GTPreludeArray alloc] init];
    prelude.items = self.items;
    prelude.lowerLimit = self.lowerLimit;
    prelude.upperLimit = self.upperLimit;
    prelude.direction = self.direction * -1;
    
    return prelude;
}

@end
