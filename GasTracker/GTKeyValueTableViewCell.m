//
//  GTKeyValueTableViewCell.m
//  GasTracker
//
//  Created by Antoine d'Otreppe on 21/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GTKeyValueTableViewCell.h"

@interface GTKeyValueTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *value;

@end

@implementation GTKeyValueTableViewCell

- (void)setKey:(NSString *)key andValue:(NSString *)value
{
    self.title.text = key;
    self.value.text = value;
}

@end
