//
//  WeekCollectionCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/11.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLabel.h"
//内页天气信息
@interface WeekCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel        *week;
@property (weak, nonatomic) IBOutlet UILabel        *date;

@property (weak, nonatomic) IBOutlet UIImageView    *weather_image; // 天气图标
 // 天气描述文字
@property (weak, nonatomic) IBOutlet MyLabel        *weather_txt;

@property (weak, nonatomic) IBOutlet UILabel        *maxtemp; // 最高温度
@property (weak, nonatomic) IBOutlet UIImageView    *link_image; // 链接符
@property (weak, nonatomic) IBOutlet UILabel        *mintemp; // 最低温度
@property (weak, nonatomic) IBOutlet UILabel        *directionOfwind; // 风向
@property (weak, nonatomic) IBOutlet UILabel        *sizeOfwind; //风力
@property (weak, nonatomic) IBOutlet UIImageView    *pollution; // 污染

@end
