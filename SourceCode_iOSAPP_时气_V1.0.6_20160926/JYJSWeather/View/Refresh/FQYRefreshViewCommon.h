//
//  FQYRefreshViewCommon.h
//  FQYRefreshView
//
//  Created by DEVP-IOS-03 on 16/1/26.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#ifndef FQYRefreshViewCommon_h
#define FQYRefreshViewCommon_h

//#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define TEXT_COLOR	 [UIColor blackColor]
#define FLIP_ANIMATION_DURATION 0.18f

#define  REFRESH_MAX_HEIGHT 65.0f
#define RefreshFastAnimationDuration 0.3
//刷新状态
typedef enum{
    RefreshTrigger = 0,//触发就可以进行刷新的状态
    RefreshNormal,//普通状态
    RefreshLoading,//正在刷新中的状态
    RefreshSuccess,
} RefreshState;

//刷新控件添加的位置
typedef enum{
    RefreshHeader = 1,
    RefreshFooter = -1,
} RefreshPosition;

@protocol RefreshViewDelegate <NSObject>
- (void)refreshViewDidTriggerRefresh:(RefreshPosition)refreshPosition;
- (BOOL)refreshViewDataIsLoading:(UIView*)view;
-(void)setNavigationBarShow;
@optional
- (NSDate*)refreshViewDataLastUpdated;
@end
#endif 
