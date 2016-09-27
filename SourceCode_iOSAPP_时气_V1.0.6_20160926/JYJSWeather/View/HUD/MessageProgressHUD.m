//
//  MessageProgressHUD.m
//  JYJSWeather
//
//  Created by DEV-IOS-3 on 16/8/29.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "MessageProgressHUD.h"
#define textAdditionSpace 30
#define backViewColor [UIColor colorWithWhite:0 alpha:0.78]
#define backViewPadding 130
@implementation MessageProgressHUD

- (void)addText {
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.text = self.text;
    self.textLabel.textColor = [UIColor whiteColor];
    
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.textLabel sizeToFit];
    
    NSUInteger line = CGRectGetWidth(self.textLabel.frame) / (CGRectGetWidth([UIScreen mainScreen].bounds) - backViewPadding);
    if (line >= 1) {
        self.textLabel.numberOfLines = line + 1;
        self.textLabel.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - backViewPadding, CGRectGetHeight(self.textLabel.frame));
        CGSize size = [self.textLabel sizeThatFits:self.textLabel.frame.size];
        self.textLabel.frame = CGRectMake(0, 0, size.width, size.height);
    }
}

- (void)compositeElements {
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.textLabel.frame) + textAdditionSpace, CGRectGetHeight(self.textLabel.frame) + textAdditionSpace)];
    self.backView.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    self.backView.backgroundColor = backViewColor;
    self.backView.layer.cornerRadius = 10;
    self.textLabel.center = CGPointMake(CGRectGetMidX(self.backView.bounds), CGRectGetMidY(self.backView.bounds));
    [self.backView addSubview:self.textLabel];
}

@end
