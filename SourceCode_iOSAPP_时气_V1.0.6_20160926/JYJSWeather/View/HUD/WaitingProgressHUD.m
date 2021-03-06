//
//  WaitingProgressHUD.m
//  JYJSWeather
//
//  Created by DEV-IOS-3 on 16/8/29.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "WaitingProgressHUD.h"
#define textAdditionSpace 30
#define textLabelGeneralHeight 80
#define textLabelGeneralWidth 85
@implementation WaitingProgressHUD

- (void)addIndicator {
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.indicatorView startAnimating];
}

- (void)addText {
    if (self.text.length > 0) {
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.text = self.text;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.textLabel sizeToFit];
        
        NSUInteger line = CGRectGetWidth(self.textLabel.frame) / (CGRectGetWidth([UIScreen mainScreen].bounds) - 130);
        if (line >= 1) {
            self.textLabel.numberOfLines = line + 1;
            self.textLabel.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds) - 130, CGRectGetHeight(self.textLabel.frame));
            CGSize size = [self.textLabel sizeThatFits:self.textLabel.frame.size];
            self.textLabel.frame = CGRectMake(0, 0, size.width, size.height);
        }
    }
}

- (void)compositeElements {
    if (self.textLabel) {
        CGFloat width = CGRectGetWidth(self.textLabel.frame) > 50 ? CGRectGetWidth(self.textLabel.frame) + textAdditionSpace : textLabelGeneralWidth;
        CGFloat height = CGRectGetHeight(self.textLabel.frame) + textLabelGeneralHeight;
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        
        self.indicatorView.center = CGPointMake(CGRectGetMidX(self.backView.bounds), CGRectGetMinY(self.backView.frame) + 35);
        self.textLabel.center = CGPointMake(CGRectGetMidX(self.backView.bounds), (CGRectGetMaxY(self.backView.bounds) + CGRectGetMaxY(self.indicatorView.bounds)) / 2 + 6);
        
        [self.backView addSubview:self.textLabel];
    }
    else {
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
        
        self.indicatorView.center = CGPointMake(CGRectGetMidX(self.backView.bounds), CGRectGetMidY(self.backView.bounds));
    }
    self.backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.78];
    self.backView.layer.cornerRadius = 10;
    self.backView.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [self.backView addSubview:self.indicatorView];
}

@end