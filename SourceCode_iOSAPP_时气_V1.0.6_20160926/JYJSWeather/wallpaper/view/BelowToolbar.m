//
//  BelowToolbar.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/3/9.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "BelowToolbar.h"

@implementation BelowToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.collectionButton];
        [_collectionButton addTarget:self.delegate action:@selector(collectionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_collectionButton setImage:[UIImage imageNamed:@"iconfont-xiai-2.png"] forState:UIControlStateNormal];
        [_collectionButton setImage:[UIImage imageNamed:@"iconfont-xiai.png"] forState:UIControlStateSelected];
        [_collectionButton setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectionButton setTitle:@"收藏成功" forState:UIControlStateSelected];
        
        self.previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.previewButton];
        [_previewButton addTarget:self.delegate action:@selector(previewAction) forControlEvents:UIControlEventTouchUpInside];
        [_previewButton setImage:[UIImage imageNamed:@"iconfont-yulan.png"] forState:UIControlStateNormal];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        
        self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.downloadButton];
        [_downloadButton addTarget:self.delegate action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
        [_downloadButton setImage:[UIImage imageNamed:@"iconfont-xiazai.png"] forState:UIControlStateNormal];
        [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [_downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width / 3;
    CGFloat height = self.frame.size.height;
    _downloadButton.frame = CGRectMake(width, 0, width, height);
    _previewButton.frame =  CGRectMake(0, 0, width, height);
    _collectionButton.frame = CGRectMake(width * 2, 0, width, height);
}

@end
