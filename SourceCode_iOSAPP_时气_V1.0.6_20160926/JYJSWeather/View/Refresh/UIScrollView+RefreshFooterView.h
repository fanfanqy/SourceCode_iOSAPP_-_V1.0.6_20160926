//
//  UIScrollView+RefreshFooterView.h
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/7/14.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InfiniteScrollingView;

@interface UIScrollView (RefreshFooterView)

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler;
- (void)triggerInfiniteScrolling;

@property (nonatomic, strong, readonly) InfiniteScrollingView *infiniteScrollingView;
@property (nonatomic, assign) BOOL showsInfiniteScrolling;

@end

enum {
    SVInfiniteScrollingStateStopped = 0,
    SVInfiniteScrollingStateTriggered,
    SVInfiniteScrollingStateLoading,
    SVInfiniteScrollingStateAll = 10
};

typedef NSUInteger FooterScrollingState;


@interface InfiniteScrollingView : UIView
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSString *textLabelString;
@property (nonatomic, readonly) FooterScrollingState state;
@property (nonatomic, readwrite) BOOL enabled;

- (void)setCustomView:(UIView *)view forState:(FooterScrollingState)state;

- (void)startAnimating;
- (void)stopAnimating;

@end
