//
//  WeatherTableViewCell.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface WeatherTableViewCell : BaseTableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic , strong) UIScrollView * topScrollView;

@end
