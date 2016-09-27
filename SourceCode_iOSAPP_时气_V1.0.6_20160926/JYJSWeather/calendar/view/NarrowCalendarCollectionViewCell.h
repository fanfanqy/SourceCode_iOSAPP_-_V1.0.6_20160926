//
//  NarrowCalendarCollectionViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/12.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NarrowCalendarCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *luckyImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet UILabel *lunarCalendarLabel;
@property (weak, nonatomic) IBOutlet UILabel *haircutLabel;

@property (weak, nonatomic) IBOutlet UILabel *hairCurStrLabel;
@property (weak, nonatomic) IBOutlet UILabel *hairWashLabel;

//宜图片
@property (weak, nonatomic) IBOutlet UIImageView *appropriteImageView;
@property (weak, nonatomic) IBOutlet UILabel *appropriteLabel;
//宜Label向下一个切换图片
@property (weak, nonatomic) IBOutlet UIImageView *YiImageView;
//忌
@property (weak, nonatomic) IBOutlet UIImageView *avoidImageView;
@property (weak, nonatomic) IBOutlet UILabel *avoidLabel;
@property (weak, nonatomic) IBOutlet UIImageView *JiImageView;

@property (weak, nonatomic) IBOutlet UILabel *memorialDayLabel;

@property (weak, nonatomic) IBOutlet UILabel *xingxiuFestival;

@property (weak, nonatomic) IBOutlet UILabel *goodtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *badtimeLabel;

@end
