//
//  CityTitleCollectionViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/20.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "CityTitleCollectionViewCell.h"

@implementation CityTitleCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.textLabel];
        self.textLabel.font = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERTHREE];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

@end
