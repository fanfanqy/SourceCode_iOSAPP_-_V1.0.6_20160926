//
//  IndexButton.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 天气内页界面下方,天气指数按钮
 */
@interface IndexButton : UIButton

@property (nonatomic , strong) UIImageView *iconImageView;
@property (nonatomic , strong) UILabel *title;//适宜
@property (nonatomic , strong) UILabel *index;//洗车


@end
