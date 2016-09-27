//
//  BelowToolbar.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/3/9.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BelowToolbarDelegate;

@interface BelowToolbar : UIView
@property (nonatomic , strong) UIButton *collectionButton;
@property (nonatomic , strong) UIButton *previewButton;
@property (nonatomic , strong) UIButton *downloadButton;

@property (nonatomic , weak) id <BelowToolbarDelegate> delegate;

@end

@protocol BelowToolbarDelegate <NSObject>

- (void)collectionAction:(UIButton *)button;
- (void)previewAction;
- (void)downloadAction;

@end