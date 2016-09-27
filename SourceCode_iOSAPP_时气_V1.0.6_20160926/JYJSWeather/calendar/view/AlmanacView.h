//
//  CalendarDateView.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/18.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "calendarDBModel.h"
#import "ZangLiModel.h"
#import "MyLabel.h"
#import "AppDelegate.h"
/**
 *  万年历内页
 */
@interface AlmanacView : UIView
/**
 *  吉凶平
 */
@property (weak, nonatomic) IBOutlet UIImageView *LuckyImageView;
//阳历日子
@property (weak, nonatomic) IBOutlet UILabel *SolarLabel;
/**
 *  农历日子
 */
@property (weak, nonatomic) IBOutlet UILabel *LunarLabel;
/**
 *  星期四
 */
@property (weak, nonatomic) IBOutlet UILabel *WeekLabel;
/**
 *  节气或节日
 */
@property (weak, nonatomic) IBOutlet MyLabel *FestivalLabel;
//@property (weak, nonatomic) IBOutlet UILabel *FestivalLabel;
/**
 *  纪年
 */
@property (weak, nonatomic) IBOutlet UILabel *JiNianLabel;
/**
 *  理发
 */
@property (weak, nonatomic) IBOutlet UILabel *HaircutLabel;
/**
 *  宜
 */

@property (weak, nonatomic) IBOutlet UILabel *YiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *YiImageView;

/**
 *  忌
 */


@property (weak, nonatomic) IBOutlet UILabel *JiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *JiImageView;

/**
 *  宗教节日
 */
@property (weak, nonatomic) IBOutlet UILabel *ReligionFestivalLabel;
/**
 *  冲的动物
 */
@property (weak, nonatomic) IBOutlet UILabel *ChongAnimalLabel;
/**
 *  吉时
 */
@property (weak, nonatomic) IBOutlet UILabel *LuckyhourLabel;
/**
 *  凶时
 */
@property (weak, nonatomic) IBOutlet UILabel *BadhourLabel;
@property (nonatomic,strong) NSDictionary *jianFa;
-(void)reloadDataOfYiJiView:(calendarDBModel *)model andZangLiModel:(ZangLiModel *)zangliModel year:(int)strYear month:(int)strMonth day:(int)strDay;
@end
