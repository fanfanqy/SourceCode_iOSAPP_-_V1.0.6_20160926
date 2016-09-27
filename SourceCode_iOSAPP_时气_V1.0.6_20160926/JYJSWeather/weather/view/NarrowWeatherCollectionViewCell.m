//
//  NarrowWeatherCollectionViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/12.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "NarrowWeatherCollectionViewCell.h"

@implementation NarrowWeatherCollectionViewCell
{
    double scale;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    scale =0.2087*ScreenWidth/ModuleNarrowWeatherHeight;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(-28*scale, 0, ScreenWidth+28*scale, 85)];
    UIImage *image = [UIImage imageNamed:@"weatherNarrowLine"];
    imageView.image = image;
    [self.contentView addSubview:imageView];
    [self.contentView insertSubview:imageView belowSubview:_nowtemp];
}

- (IBAction)changeCityAction:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeRootCityNotification" object:nil userInfo:nil];
}

@end
