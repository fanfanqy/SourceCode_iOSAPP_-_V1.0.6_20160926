//
//  IndexTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "IndexTableViewCell.h"
#import "IndexViewController.h"
#import "LimitNumberVC.h"
#import "WashCar.h"
#import "Datetime.h"
#import "WeatherModel.h"
#import "DBModel.h"
#import "AppDelegate.h"
@interface IndexTableViewCell ()
{
    NSString * dressStr;
    NSString * washCarStr;
    NSString * limitNumberStr;
    NSString * ultravioletStr;
    FMDatabase *limitNumberDB;
}
@property (nonatomic , strong) NSMutableArray * washcarArray;//洗车
@property (nonatomic , strong) NSMutableArray * clothersArray;//穿衣,第一天体感温度,第二天,公式计算
//限号不需要 array
@property (nonatomic , strong) NSMutableArray * xrayArray;//紫外线
@end

@implementation IndexTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
// 打开限号数据库
        NSString * path = [[NSBundle mainBundle] pathForResource:@"LimitNumber" ofType:@"db"];
        limitNumberDB = [FMDatabase databaseWithPath:path];
        [limitNumberDB open];

        dressStr = @"穿衣";
        washCarStr = @"洗车";
        limitNumberStr = @"限号车牌";
        ultravioletStr = @"紫外线";
        
        self.dress = [[IndexButton alloc]init];
        [self.contentView addSubview:self.dress];
        self.dress.iconImageView.image = [UIImage imageNamed:@"ipw_dress_"];
        self.dress.index.text = @"穿衣";

        [self.dress addTarget:self action:@selector(index:) forControlEvents:UIControlEventTouchUpInside];
        
        self.washCar = [[IndexButton alloc]init];
        [self.contentView addSubview:self.washCar];
        self.washCar.iconImageView.image = [UIImage imageNamed:@"ipw_washCar"];
        self.washCar.index.text = @"洗车";

        [self.washCar addTarget:self action:@selector(index:) forControlEvents:UIControlEventTouchUpInside];
        
        self.limitNumber = [[IndexButton alloc]init];
        [self.contentView addSubview:self.limitNumber];
        self.limitNumber.iconImageView.image = [UIImage imageNamed:@"ipw_limitNumber"];
        self.limitNumber.index.text = @"限号车牌";
        [self.limitNumber addTarget:self action:@selector(limitNumberAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.ultraviolet = [[IndexButton alloc]init];
        [self.contentView addSubview:self.ultraviolet];
        self.ultraviolet.iconImageView.image = [UIImage imageNamed:@"ipw_x-ray"];
        self.ultraviolet.index.text = @"紫外线";

        [self.ultraviolet addTarget:self action:@selector(index:) forControlEvents:UIControlEventTouchUpInside];

        self.dress.title.text = @"--";
        self.washCar.title.text = @"--";
        self.limitNumber.title.text = @"--";
        self.ultraviolet.title.text = @"--";


        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setArray:(NSMutableArray *)array
{
//    if (_array != array) {
         if (array!=nil) {
        _array = array;
        self.washcarArray = [WashCar suitableForCarWashDayWithArray:array];
        self.clothersArray = [self getClothesArray:array];
        self.xrayArray = [self getxRayArray:array];
        if (array.count > 0) {
            [self setWashcarWithIndex:0];
        }
    }
}

-(void)setWashcarWithIndex:(NSInteger)index
{
    _index = index;
    if (self.array.count == 0) {
        return;
    }
    WeatherModel * model = [self.array objectAtIndex:index];
    //可以持续获取的
    self.washCar.title.text = [self.washcarArray objectAtIndex:index];

    NSArray *array = [self getLimitNumber:model.month andDay:model.day andWeek:model.week];
    //限号 号牌
    if ([array[0] length]>=5) {
        self.limitNumber.title.font = [UIFont fontWithName:CALENDARFONTHEITI size:15];
    }else{
         self.limitNumber.title.font = [UIFont fontWithName:CALENDARFONTHEITI size:20];
    }
    self.limitNumber.title.text  = array[0];

    self.dress.title.text = [self.clothersArray objectAtIndex:index];

    self.ultraviolet.title.text = [self.xrayArray objectAtIndex:index];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;
    self.dress.frame = CGRectMake(0, 0, frame.size.width/2, frame.size.height/2);
    self.washCar.frame = CGRectMake(0, frame.size.height/2, frame.size.width/2, frame.size.height/2);
    self.limitNumber.frame = CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height/2);
    self.ultraviolet.frame = CGRectMake(frame.size.width/2, frame.size.height/2, frame.size.width/2, frame.size.height/2);
     [self setWashcarWithIndex:self.index];
}

- (void)index:(IndexButton *)button
{
    // 当无数据时禁止进入下一页
    if (self.array.count == 0) {
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate addRequestErrorView];
        return;
    }
    IndexViewController * indexVC = [[IndexViewController alloc]initWithNibName:@"IndexViewController" bundle:nil];
    indexVC.title = button.index.text;
    indexVC.array = self.array;
    indexVC.nowCityModel = self.nowCityModel;
    NSString * path = nil;
    if ([button.index.text isEqualToString:dressStr]) {
        path = [[NSBundle mainBundle]pathForResource:@"dressBack.jpg" ofType:nil];
        indexVC.otherArray = self.clothersArray;
    } else if ([button.index.text isEqualToString:washCarStr]){
        path = [[NSBundle mainBundle]pathForResource:@"washCarBack.jpg" ofType:nil];
        indexVC.otherArray = self.washcarArray;
    }else if ([button.index.text isEqualToString:ultravioletStr]){
        path = [[NSBundle mainBundle]pathForResource:@"x-rayBack.jpg" ofType:nil];
        indexVC.otherArray = self.xrayArray;
    }
     indexVC.aqi = self.aqi;
    indexVC.image = [UIImage imageWithContentsOfFile:path];
    indexVC.indexpath = self.index;
    [self.viewControllerDelegate.navigationController pushViewController:indexVC animated:YES];
}

- (void)limitNumberAction:(IndexButton *)button
{
    // 当无数据时禁止进入下一页
    if (self.array.count == 0) {
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate addRequestErrorView];
        return;
    }
    LimitNumberVC * limitNumberVC = [[LimitNumberVC alloc]initWithNibName:@"LimitNumberVC" bundle:nil];
    limitNumberVC.aqi = self.aqi;
    limitNumberVC.title = button.index.text;
    limitNumberVC.array = self.array;
    limitNumberVC.nowCityModel = self.nowCityModel;
    NSString * path = [[NSBundle mainBundle]pathForResource:@"limitNumberBack.jpg" ofType:nil];
    limitNumberVC.image = [UIImage imageWithContentsOfFile:path];
    limitNumberVC.indexpath = self.index;
    [self.viewControllerDelegate.navigationController pushViewController:limitNumberVC animated:YES];
}

//紫外线指数
-(NSMutableArray *)getxRayArray:(NSArray *)array{
    NSMutableArray *array1 = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        if (i==0) {
            WeatherModel *model = array[i];
            NSString *clothesStr = @" ";
            int feelsLikeC = [model.xray intValue];
           if (feelsLikeC>=10){
                clothesStr = @"很强";

            }else if (feelsLikeC>=7 && feelsLikeC<=9){
                clothesStr = @"强";
            }else if (feelsLikeC>=5 && feelsLikeC<=6){
                clothesStr = @"中等";
            }else if (feelsLikeC>=3 && feelsLikeC<=4){
                clothesStr = @"弱";
            }else if (feelsLikeC<=2){
                clothesStr = @"最弱";
            }else{
                 clothesStr = @"--";
            }
            [array1 addObject:clothesStr];
        }else{
            NSString *str = @"--";
            [array1 addObject:str];
        }
    }
    return array1;

}

//获取穿衣
-(NSMutableArray *)getClothesArray:(NSArray *)array{

    NSMutableArray *array1 = [NSMutableArray array];
    for (int i=0; i<array.count; i++) {
        if (i==0) {
            WeatherModel *model = array[i];
            NSString *clothesStr = @" ";
            int feelsLikeC = [model.feelslike_c intValue];
            if (feelsLikeC>=32) {
                clothesStr = @"炎热";
            }else if (feelsLikeC>=26 && feelsLikeC<32){
                clothesStr = @"热";
            }else if (feelsLikeC>=18 && feelsLikeC<26){
                clothesStr = @"舒适";
            }else if (feelsLikeC>=10 && feelsLikeC<18){
                clothesStr = @"凉爽";
            }else if (feelsLikeC>=0 && feelsLikeC<10){
                clothesStr = @"冷";
            }else if ( feelsLikeC<0){
                clothesStr = @"寒冷";
            }
            [array1 addObject:clothesStr];
        }else{
            NSString *str = @"--";
            [array1 addObject:str];
        }
    }
    return array1;
}

//获取限号
-(NSArray *)getLimitNumber:(NSInteger)month andDay:(NSInteger)day andWeek:(NSString *)week{

    NSMutableArray *array1 = [NSMutableArray array];
    NSString *sql = nil;
    NSString *limitNumber = @" ";
    NSString *limitTime = @" ";
    NSString *columnStr = @" ";


    int loc = 0;
    if ([week isEqualToString:@"星期一"]) {
        columnStr = @"LimitNumber1";
    }else if ([week isEqualToString:@"星期二"]){
        columnStr = @"LimitNumber2";
    }else if ([week isEqualToString:@"星期三"]){
        columnStr = @"LimitNumber3";
    }else if ([week isEqualToString:@"星期四"]){
        columnStr = @"LimitNumber4";
    }else if ([week isEqualToString:@"星期五"]){
        columnStr = @"LimitNumber5";
    }
    
    if([self.nowCityModel.cityCC rangeOfString:@"北京"].location !=NSNotFound )//_roaldSearchText
    {
        if ([Datetime isLegalHoliday:month andDay:day]) {
            limitNumber = @"假日不限行";
            limitTime = @" ";

        }else if ([week isEqualToString:@"星期六"] || [week isEqualToString:@"星期日"]){
            limitNumber = @"周末不限行";
            limitTime = @" ";

        }
        else{
            sql = @"select * from LimitNumber where City = '北京市'";
            FMResultSet *set = [limitNumberDB executeQuery:sql];
            NSRange range ;
            switch (month) {
                case 4:
                {  if (day>=11) {
                    loc = 0;
                }
                    break;
                }
                case 5:
                    loc = 0;
                    break;
                case 6:
                    loc = 0;
                    break;
                case 7:
                {if (day<11) {
                    loc = 0;
                }else{
                    loc = 1;
                }
                    break;
                }
                case 8:
                    loc = 1;
                    break;
                case 9:
                    loc = 1;
                    break;
                case 10:
                {  if (day<=9) {
                    loc = 1;
                }else{
                    loc = 2;
                }
                    break;
                }
                case 11:
                    loc = 2;
                    break;
                case 12:
                    loc = 2;
                    break;
                default:
                    break;
            }
            range = NSMakeRange(loc*4, 3);

            if (set.next) {
                NSString *string = [set stringForColumn:columnStr];
                limitNumber = [string substringWithRange:range];
                limitTime = [set stringForColumn:@"LocalLimitTime"];
            }

        }

    }else if([self.nowCityModel.cityCC rangeOfString:@"天津"].location !=NSNotFound)//_roaldSearchText
    {
        if ([Datetime isLegalHoliday:month andDay:day]) {
            limitNumber = @"假日不限行";
            limitTime = @" ";

        }else if ([week isEqualToString:@"星期六"] || [week isEqualToString:@"星期日"]){
            limitNumber = @"周末不限行";
            limitTime = @" ";

        }else{
            sql = @"select * from LimitNumber where City = '天津市'";
            FMResultSet *set = [limitNumberDB executeQuery:sql];
            NSRange range ;
            int loc = 0;
            switch (month) {
                case 4:
                    if (day>=10) {
                        loc = 0;
                    }
                    break;
                case 5:
                    loc = 0;
                    break;
                case 6:
                    loc = 0;
                    break;
                case 7:
                { if (day<10) {
                    loc = 0;
                }else{
                    loc = 1;
                }
                    break;
                }
                case 8:
                    loc = 1;
                    break;
                case 9:
                    loc = 1;
                    break;
                case 10:
                {if (day<=8) {
                    loc = 1;
                }else{
                    loc = 2;
                }
                    break;
                }
                case 11:
                    loc = 2;
                    break;
                case 12:
                    loc = 2;
                    break;
                default:
                    break;
            }
            range = NSMakeRange(loc*4, 4);

            if (set.next) {
                NSString *string = [set stringForColumn:columnStr];
                limitNumber = [string substringWithRange:range];
                limitTime = [set stringForColumn:@"LocalLimitTime"];

            }
        }
    }else if ([self.nowCityModel.cityCC rangeOfString:@"杭州"].location !=NSNotFound || [self.nowCityModel.cityCC rangeOfString:@"贵阳"].location !=NSNotFound || [self.nowCityModel.cityCC rangeOfString:@"南昌"].location !=NSNotFound || [self.nowCityModel.cityCC rangeOfString:@"萧山"].location !=NSNotFound){
        if ([Datetime isLegalHoliday:month andDay:day]) {
            limitNumber = @"假日不限行";
            limitTime = @" ";

        }else if ([week isEqualToString:@"星期六"] || [week isEqualToString:@"星期日"]){
            limitNumber = @"周末不限行";
            limitTime = @" ";

        }else{
            if ([self.nowCityModel.cityCC rangeOfString:@"杭州"].location !=NSNotFound ) {
                sql = @"select * from LimitNumber where City = '杭州市'";
            }else if ([self.nowCityModel.cityCC rangeOfString:@"贵阳"].location !=NSNotFound){
                sql = @"select * from LimitNumber where City = '贵阳市'";
            }else if ([self.nowCityModel.cityCC rangeOfString:@"南昌"].location !=NSNotFound){
                sql = @"select * from LimitNumber where City = '南昌市'";
            }else if ([self.nowCityModel.cityCC rangeOfString:@"萧山"].location !=NSNotFound){
                sql = @"select * from LimitNumber where City = '杭州市'";
            }
            FMResultSet *set = [limitNumberDB executeQuery:sql];
            if (set.next) {
                limitNumber = [set stringForColumn:columnStr];
                limitTime = [set stringForColumn:@"LocalLimitTime"];
            }
        }
    }else if ([self.nowCityModel.cityCC rangeOfString:@"成都"].location !=NSNotFound){
        sql = @"select * from LimitNumber where City = '成都市'";
        FMResultSet *set = [limitNumberDB executeQuery:sql];
        if ([Datetime isLegalHoliday:month andDay:day]) {
            limitNumber = @"假日不限行";
            limitTime = @" ";
        }else if ([week isEqualToString:@"星期六"] || [week isEqualToString:@"星期日"]){
            limitNumber = @"周末不限行";
            limitTime = @" ";

        }else{
            if ([Datetime isAdjustDay:month andDay:day]) {
                if ([week isEqualToString:@"星期日"] && [Datetime isAdjustDay:month andDay:day-1]) {
                    columnStr = @"LimitNumber2";
                }else{
                    columnStr = @"LimitNumber1";
                }
            }
            if (set.next) {
                limitNumber = [set stringForColumn:columnStr];
                limitTime = [set stringForColumn:@"LocalLimitTime"];
            }
        }

    }else if ([self.nowCityModel.cityCC rangeOfString:@"武汉"].location !=NSNotFound || [self.nowCityModel.cityCC rangeOfString:@"哈尔滨"].location !=NSNotFound || [self.nowCityModel.cityCC rangeOfString:@"济南"].location !=NSNotFound){
        
        if ([self.nowCityModel.cityCC rangeOfString:@"武汉"].location !=NSNotFound ) {
            sql = @"select * from LimitNumber where City = '武汉市'";
        }
        if ([self.nowCityModel.cityCC rangeOfString:@"哈尔滨"].location !=NSNotFound){
            sql = @"select * from LimitNumber where City = '哈尔滨'";
        }
        if ([self.nowCityModel.cityCC rangeOfString:@"济南"].location !=NSNotFound){
            sql = @"select * from LimitNumber where City = '济南市'";
        }
        FMResultSet *set = [limitNumberDB executeQuery:sql];

        if (set.next) {
            columnStr = @"LimitNumber1";
            limitNumber = [set stringForColumn:columnStr];

            if ([limitNumber isEqualToString:@"SS"]) {
                if (day %2 == 0) {
                    limitNumber = @"0、2、4、6、8";

                }else{
                    limitNumber = @"1、3、5、7、9";
                }

            }else if ([limitNumber isEqualToString:@"SD"]){
                if (day %2 == 0) {
                    limitNumber = @"1、3、5、7、9";

                }else{
                    limitNumber = @"0、2、4、6、8";
                }

            }
            limitTime = [set stringForColumn:@"LocalLimitTime"];

        }

    }else if ([self.nowCityModel.cityCC rangeOfString:@"兰州"].location !=NSNotFound ){
        sql = @"select * from LimitNumber where City = '兰州市'";
        FMResultSet *set = [limitNumberDB executeQuery:sql];
        if (day>=10) {
            day = day%10;
        }
        if (day ==1 || day ==6) {
            limitNumber = @"1和6";
        }else if (day ==2 || day ==7){
            limitNumber = @"2和7";
        }else if (day ==3 || day ==8){
            limitNumber = @"3和8";
        }else if (day ==4 || day ==9){
            limitNumber = @"4和9";
        }else if (day ==5 || day ==0){
            limitNumber = @"5和0";
        }
        if (set.next) {
            limitTime = [set stringForColumn:@"LocalLimitTime"];
        }
    }else if ([self.nowCityModel.cityCC rangeOfString:@"长春"].location !=NSNotFound){
        sql = @"select * from LimitNumber where City = '长春市'";
        FMResultSet *set = [limitNumberDB executeQuery:sql];
        if (day>=10 && day!=31) {
            day = day%10;
        }
        if (set.next) {
            if (day == 4) {
                limitNumber = @"4";
            }else if (day == 31){
                limitNumber = @"今日不限行";
            }else {
                limitNumber = [NSString stringWithFormat:@"%ld",(long)day];
            }
            limitTime = [set stringForColumn:@"LocalLimitTime"];

        }

    }
    else{
        limitNumber = @"此城市不限行";
        limitTime = @" ";
    }

    [array1 addObject:limitNumber];
    [array1 addObject:limitTime];

    return array1;
}
-(void)dealloc{
    [limitNumberDB close];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
