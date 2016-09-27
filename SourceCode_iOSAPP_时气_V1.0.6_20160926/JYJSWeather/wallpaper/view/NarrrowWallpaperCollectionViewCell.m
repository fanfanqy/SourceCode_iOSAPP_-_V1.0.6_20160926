//
//  NarrrowWallpaperCollectionViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "NarrrowWallpaperCollectionViewCell.h"
#import "CustomImageView.h"
@implementation NarrrowWallpaperCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageview.userInteractionEnabled = YES;
    self.imageview.contentMode = UIViewContentModeScaleAspectFill;
    self.imageview.clipsToBounds = YES;
}
@end
