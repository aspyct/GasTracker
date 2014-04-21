//
//  GTPreludeArray.h
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GTPreludeArray : NSObject

@property (readonly) id head;
@property (readonly) GTPreludeArray *tail;
@property (readonly) NSUInteger count;

+ (GTPreludeArray *)arrayWithArray:(NSArray *)array;

- (GTPreludeArray *)inverted;

@end
