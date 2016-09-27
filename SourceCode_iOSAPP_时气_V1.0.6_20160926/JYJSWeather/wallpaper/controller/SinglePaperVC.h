//
//  SinglePaperVC.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/3/4.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinglePaperVC : UIViewController
@property (nonatomic , strong) NSMutableArray * array;
@property (nonatomic , assign) CGFloat  index; // 记录第一张显示的图片位置
@end
