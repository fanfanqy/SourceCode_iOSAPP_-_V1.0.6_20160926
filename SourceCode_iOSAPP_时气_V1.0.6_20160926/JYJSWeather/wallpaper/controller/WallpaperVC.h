//
//  WallpaperVC.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/2/25.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallpaperVC : UIViewController
@property (nonatomic , strong) NSMutableArray *pictureArray; // 缩略图片数组
@property (nonatomic , retain) NSMutableArray * array; //
@property (nonatomic , assign) int pages; //页数
@property (nonatomic , assign) int Index;//滚动到第几个
@end
