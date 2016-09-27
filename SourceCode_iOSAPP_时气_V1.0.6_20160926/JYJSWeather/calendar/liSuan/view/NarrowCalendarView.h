//
//  NarrowCalendarView.h
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/5/24.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "calendarDBModel.h"
@protocol NarrowCalendarViewDelegate <NSObject>
@optional  //可选实现
-(void)reloadNarrowCalendarDataWithYear:(int)newYear month:(int)newMonth day:(int)newDay andIsSelected:(BOOL)isSelected;

@end

@interface NarrowCalendarView : UIView
@property (nonatomic, assign) id <NarrowCalendarViewDelegate> delegate;
@property (nonatomic,strong)NSMutableArray * narrowCalendarArray;
@property (nonatomic, assign) int strYear;
@property (nonatomic, assign) int strMonth;
@property (nonatomic, assign) int strDay;
-(void)markDataWithYear:(int)year month:(int)month day:(int)day;
-(void)reloadDataWithDate:(int)date andMonth:(int)month andYear:(int)year andIsSelected:(BOOL)isSelected;
-(void)backTodayAction;
@end
