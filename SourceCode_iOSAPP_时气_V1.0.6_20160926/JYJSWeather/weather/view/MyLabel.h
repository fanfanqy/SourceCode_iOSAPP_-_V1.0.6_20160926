//
//  MyLabel.h
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/6/20.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface MyLabel : UILabel
@property (nonatomic) VerticalAlignment verticalAlignment;
@end
