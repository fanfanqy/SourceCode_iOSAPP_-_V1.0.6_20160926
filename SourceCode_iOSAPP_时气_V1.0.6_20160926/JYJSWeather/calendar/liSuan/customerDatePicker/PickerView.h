//
//  PickerView.h
//  naviel
//
//  Created by mac on 14-6-11.
//  Copyright (c) 2014年 chris. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerView;

@protocol pickerViewDelegate <NSObject>

-(void)pickerViewDelegateWithDateString:(NSString *)dateString;

@end


enum{
    PickerViewCount3 = 3,
    PickerViewCount5 = 5,
    
    CalendarTypeSolar = 0,
    CalendarTypeLunar = 1,
};

@interface PickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong ,nonatomic)UIPickerView * pickerView;
@property (assign ,nonatomic) NSInteger pickerViewCount;
@property (assign ,nonatomic) BOOL hideSolOrLunSeg;
@property (strong ,nonatomic) UIView * bgPickView;

@property(nonatomic, retain)UIButton *yinBtn;

@property(nonatomic, retain)UIButton *yangBtn;

@property(nonatomic, copy)NSString *selectedDateString;
@property (nonatomic,assign) int year;
-(void)initDate:(NSDate*)date calendarType:(NSInteger)calendarType;

-(void)onYinYangBtnClick:(UIButton *)sender;

@property(nonatomic, assign)id<pickerViewDelegate> delegate;

//AS_SIGNAL( SELDATE )
//AS_SIGNAL( SELDATE5 )
@end


