//
//  WeatherCollectionViewCell.m
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/8/1.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "WeatherCollectionViewCell.h"


@implementation WeatherCollectionViewCell
{
    float scale;
}

//PSPDF_NOT_DESIGNATED_INITIALIZER_CUSTOM(initWithFrame:(CGRect)frame)

-(instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    self.backgroundView.backgroundColor =  UIColorFromRGB(0xcccccc);
    UIWebView *backgroundWebView = [[UIWebView alloc]init];
    backgroundWebView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    backgroundWebView.scrollView.scrollEnabled = NO;
    backgroundWebView.userInteractionEnabled = NO;
    self.backgroundWebView = backgroundWebView;

    scale =1.4625*ScreenWidth/ModuleWeatherHeight;
    NSLog(@"%f,%f",ScreenWidth,ModuleWeatherHeight);

    UIImageView *mirror = [[UIImageView alloc]initWithFrame:CGRectMake(0.0483*self.frame.size.width, scale*0.1254*self.frame.size.height, 0.4700*self.frame.size.width,  0.4700*self.frame.size.width)];
    self.mirror = mirror;

    UILabel *nowTemp = [[UILabel alloc]init];
    //iOS10以后字体变大一点,更准确说是:自适应宽度计算的精确度更高了,因此把自适应的宽度给调小点
    if (SYSTEM_VERSION>=10.0){
        nowTemp.frame = CGRectMake(0, 0, 0.35*mirror.frame.size.width-3, 0.35*mirror.frame.size.width-3);
    }else{
         nowTemp.frame = CGRectMake(0, 0, 0.35*mirror.frame.size.width, 0.35*mirror.frame.size.width);
    }
    if (IS_IPHONE4 || IS_IPHONE5) {
        nowTemp.center = CGPointMake(mirror.center.x+4, mirror.center.y);
    }else if (IS_IPHONE6_PLUS || IS_IPHONE6){
        nowTemp.center = CGPointMake(mirror.center.x+6, mirror.center.y);
    }
    else{
        nowTemp.center = CGPointMake(mirror.center.x+4+4*scale, mirror.center.y);
    }

    nowTemp.font = [UIFont fontWithName:@"Arial" size:80];//实际算出来是70左右,大一点是因为iPad字体80小点的的
    nowTemp.adjustsFontSizeToFitWidth = YES;
    nowTemp.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    nowTemp.textColor = [UIColor whiteColor];
    self.nowtemp = nowTemp;
    UILabel *date = [[UILabel alloc]init];
    UILabel *week = [[UILabel alloc]init];
    UILabel *max_mintemp = [[UILabel alloc]init];
    UILabel *weather_txt = [[UILabel alloc]init];
    date.font = [UIFont fontWithName:CALENDARFONTHEITI size:scale*TEXTNUMBERTHREE];
    week.font = [UIFont fontWithName:CALENDARFONTHEITI size:scale*TEXTNUMBERTHREE];
    max_mintemp.font = [UIFont fontWithName:CALENDARFONTHEITI size:scale*TEXTNUMBERTHREE];
    weather_txt.font = [UIFont fontWithName:CALENDARFONTHEITI size:scale*TEXTNUMBERTHREE];
    date.textColor = [UIColor whiteColor];
    week.textColor = [UIColor whiteColor];
    max_mintemp.textColor = [UIColor whiteColor];
    weather_txt.textColor = [UIColor whiteColor];
    date.textAlignment = NSTextAlignmentLeft;
    week.textAlignment = NSTextAlignmentLeft;
    max_mintemp.textAlignment = NSTextAlignmentLeft;
    weather_txt.textAlignment = NSTextAlignmentLeft;
    NSLog(@"scale:%f",scale);
    date.frame = CGRectMake(22*scale, self.frame.size.height-26*scale-29*scale-33*scale-20, scale*90, 20*scale);
    week.frame = CGRectMake(22*scale+70*scale+10*scale, self.frame.size.height-26*scale-29*scale-33*scale-20, scale*60, 20*scale);
    max_mintemp.frame = CGRectMake(22*scale, self.frame.size.height-26*scale-29*scale-20, scale*130, 20*scale);
    
    weather_txt.frame = CGRectMake(22*scale, self.frame.size.height-26*scale-20, scale*90, 20*scale);
    self.date = date;
    self.week = week;
    self.max_mintemp = max_mintemp;
    self.weather_txt = weather_txt;
    UIImageView *pollution = [[UIImageView alloc]initWithFrame:CGRectMake(weather_txt.frame.origin.x+weather_txt.frame.size.width+3, self.frame.size.height-26*scale-18, 32*scale, 17*scale)];
    pollution.contentMode = UIViewContentModeScaleToFill;
    UIImageView *person = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-0.4*ScreenWidth-10, self.frame.size.height - 1.35*0.4*ScreenWidth-10, 0.4*ScreenWidth, 1.35*0.4*ScreenWidth)];
    person.contentMode = UIViewContentModeScaleAspectFit;
    self.pollution = pollution;
    self.person = person;
    //     UILabel *nowtemp; // 当前温度
    //     UILabel *date; // 日期
    //     UILabel *week;
    //
    //     UILabel *max_mintemp; // 最大最小温度
    //     UILabel *weather_txt; // 天气描述
    //     UIImageView *pollution; // 污染
    //     UIImageView *person; // 人物
    
    [self.contentView addSubview:_backgroundWebView];
    [self.contentView addSubview:_mirror];
    [self.contentView addSubview:_nowtemp];
    [self.contentView addSubview:_date];
    [self.contentView addSubview:_week];
    [self.contentView addSubview:_max_mintemp];
    [self.contentView addSubview:_weather_txt];
    [self.contentView addSubview:_pollution];
    [self.contentView addSubview:_person];
    [self.contentView bringSubviewToFront:self.nowtemp];
    [self.contentView sendSubviewToBack:self.backgroundWebView];
}


@end
