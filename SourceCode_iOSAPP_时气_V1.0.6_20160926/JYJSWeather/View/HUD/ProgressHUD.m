//
//  ProgressHUD.m
//  JYJSWeather
//
//  Created by DEV-IOS-3 on 16/8/29.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "ProgressHUD.h"
#import "MessageProgressHUD.h"
#import "WaitingProgressHUD.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define backgroundColor   UIColorFromRGB(0x5F5F5F)
#define animationDuration 0.3
static NSMutableArray *HUDs;

@interface ProgressHUD ()

@end

@implementation ProgressHUD

+ (void)load {
    HUDs = [NSMutableArray array];
}

+ (instancetype)showInView:(UIView *)view withText:(NSString *)text animated:(BOOL)animated {
    ProgressHUD *HUD = [[WaitingProgressHUD alloc] initWithFrame:view.bounds];
    HUD.view = view;
    HUD.text = text;
     
    [HUD addIndicator];
    [HUD addText];
    [HUD compositeElements];
    
    [HUD show:animated withDuration:0 completion:nil];
    
    return HUD;
}

+ (instancetype)popMessage:(NSString *)text inView:(UIView *)view duration:(NSTimeInterval)duration animated:(BOOL)animated {
    ProgressHUD *HUD = [[MessageProgressHUD alloc] initWithFrame:view.bounds];
    HUD.view = view;
    HUD.text = text;
    
    [HUD addText];
    [HUD compositeElements];
    
    [HUD show:animated withDuration:duration completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD dismiss:animated];
        });
    }];
    
    return HUD;
}

+ (void)dismissInView:(UIView *)view animated:(BOOL)animated {
    for (ProgressHUD *HUD in HUDs) {
        if ([HUD.view isEqual:view]) {
            [HUD dismiss:animated];
        }
    }
}

+ (void)dismissAll:(BOOL)animated {
    for (ProgressHUD *HUD in HUDs) {
        [HUD dismiss:animated];
    }
}

- (void)dismiss:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            for (UIView *view in self.subviews) {
                view.alpha = 0;
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [HUDs removeObject:self];
        }];
    }
    else {
        [self removeFromSuperview];
        [HUDs removeObject:self];
    }
}

- (void)show:(BOOL)animated withDuration:(NSTimeInterval)duration completion:(void (^)())completion {
    [self addSubview:self.backView];
    [HUDs addObject:self];
    
    if (animated) {
        self.alpha = 0;
        [self.view addSubview:self];

        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            if (completion != NULL) {
                completion();
            }
        }];
    }
    else {
        [self.view addSubview:self];
    }
}

- (void)layoutSubviews {

    self.backView.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2 - CGRectGetMinY(self.view.frame));
}

- (void)addIndicator {
    
}

- (void)addText {
    
}

- (void)compositeElements {
    
}

@end
