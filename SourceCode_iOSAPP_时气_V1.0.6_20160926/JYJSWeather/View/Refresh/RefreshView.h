//
//  FQTRefreshView.h
//  FQYRefreshView
//
//  Created by DEVP-IOS-03 on 16/1/26.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQYRefreshViewCommon.h"

@protocol RefreshViewDelegate;
@interface RefreshView : UIView

{
    id __weak               _delegate;

    RefreshPosition         _position;
    UILabel                 *_lastUpdatedLabel;//上次更新时间
    UILabel                 *_statusLabel;//刷新状态
    CALayer                 *_arrowImage;//箭头
    UIActivityIndicatorView *_activityView;
}

@property(nonatomic,weak) id <RefreshViewDelegate> delegate;
@property(nonatomic,assign)RefreshState  state;
- (void)refreshLastUpdatedDate;
- (void)refreshViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView;
- (void)refreshViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;


@end
