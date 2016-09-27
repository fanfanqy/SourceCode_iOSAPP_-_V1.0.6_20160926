//
//  IndexCollectionViewCell_down.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 天气指数界面下方的collectionView 的 cell
 */
@interface IndexCollectionViewCell_down : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *date; // 日期
@property (weak, nonatomic) IBOutlet UIImageView *downArrow; // 向下箭头

@end
