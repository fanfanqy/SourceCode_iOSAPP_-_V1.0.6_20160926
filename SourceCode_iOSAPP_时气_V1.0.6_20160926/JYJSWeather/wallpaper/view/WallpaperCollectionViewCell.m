//
//  WallpaperCollectionViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "WallpaperCollectionViewCell.h"
#import "CustomImageView.h"
@implementation WallpaperCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageview = [[CustomImageView alloc]init];
        [self.contentView addSubview:self.imageview];
        self.imageview.userInteractionEnabled = YES;
        self.imageview.contentMode = UIViewContentModeScaleAspectFill;
        self.imageview.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    self.imageview.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

@end
