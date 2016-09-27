//
//  WeekCollectionCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/11.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "WeekCollectionCell.h"

@implementation WeekCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderWidth = 0.3;
    self.layer.borderColor = UIColorFromRGB(0xF0F0F0).CGColor;
    self.backgroundColor = [UIColor clearColor];
}

@end
