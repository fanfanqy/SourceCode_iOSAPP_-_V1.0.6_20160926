//
//  WallpaperCVCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/3/4.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "WallpaperCVCell.h"
#import "CustomImageView.h"
@implementation WallpaperCVCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.wallpaper = [[CustomImageView alloc]init];
        self.wallpaper.contentMode = UIViewContentModeScaleAspectFill;
        self.wallpaper.clipsToBounds = YES;
        [self.contentView addSubview:self.wallpaper];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.wallpaper.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

@end
