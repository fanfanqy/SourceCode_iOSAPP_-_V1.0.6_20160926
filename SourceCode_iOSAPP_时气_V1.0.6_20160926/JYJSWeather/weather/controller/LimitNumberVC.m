//
//  LimitNumberVC.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "LimitNumberVC.h"
#import "WeatherModel.h"
#import "Datetime.h"
#import "IndexCollectionViewCell_down.h"
#import "DBModel.h"

@interface LimitNumberVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    FMDatabase *limitNumberDB;
}
@end

@implementation LimitNumberVC
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     NSString * path = [[NSBundle mainBundle] pathForResource:@"LimitNumber" ofType:@"db"];
    limitNumberDB = [FMDatabase databaseWithPath:path];
    [limitNumberDB open];
    [self setFlowLayout];
    [self setbackgroundImage];
    if (self.array.count > 0) {
        CGFloat temp = ScreenWidth/3;
        self.collectionView.contentSize = CGSizeMake(10 * temp, self.collectionView.frame.size.height);
        if (_indexpath < 9) {
            self.collectionView.contentOffset = CGPointMake(_indexpath * temp, 0);
        }else{
            self.collectionView.contentOffset = CGPointMake(8 * temp, 0);
        }
        WeatherModel * model = [self.array objectAtIndex:_indexpath];
        if (model.riseTime != nil) {
            [self handleSunTime:_indexpath];
        } else {
            [self handleSunTime:_indexpath];
            [self handleSunTimesInPeriod];
        }
    }

    
}
- (void)handleSunTime:(NSInteger)index
{
    WeatherModel * model = [self.array objectAtIndex:index];
    self.week.text = model.week;
    NSArray *array = [self getLimitNumber:model.month andDay:model.day andWeek:model.week];

    //限号 号牌
    _number.text = array[0];
    if([array[0] length]>3)
    {
        _number.font = [UIFont fontWithName:CALENDARFONTHEITI size:26];
    }else{
        _number.font = [UIFont fontWithName:CALENDARFONTHEITI size:42];
    }
    //限号 时间段
    _limitTime.text = array[1];
    if (index == 0) {
        self.nowTemp.text = [NSString stringWithFormat:@"%@°", model.nowtemp];
        NSLog(@"当天温度范围:%@%@",model.maxtemp,model.mintemp);
        self.pollution.image = [Help getImageWithAqi:self.aqi Icon:model.icon];        
    }else{
        self.pollution.image = nil;
        if ([model.maxtemp isEqualToString:@""]) {
            self.nowTemp.text = [NSString stringWithFormat:@"%@˚", model.mintemp];
        }else{
            self.nowTemp.text = [NSString stringWithFormat:@"%@/%@°", model.maxtemp,model.mintemp];
        }
    }
    if ([model.maxtemp isEqualToString:@""]) {
         self.max_min_temp.text = [NSString stringWithFormat:@"温度范围:-/%@°", model.mintemp];
    }else if ([model.mintemp isEqualToString:@""]){
        self.max_min_temp.text = [NSString stringWithFormat:@"温度范围:%@°/-", model.maxtemp];
    }
    else{
        self.max_min_temp.text = [NSString stringWithFormat:@"温度范围:%@/%@°", model.maxtemp,model.mintemp];
    }

//    self.max_min_temp.text = [NSString stringWithFormat:@"温度范围:%@/%@°", model.mintemp, model.maxtemp ];
    self.weather_txt.text = [NSString stringWithFormat:@"天气状况:%@", model.weather_txt];
    if ([model.directionOfwind isEqualToString:@""]) {
        self.wind.text = @"风向风力:无风0级";
    }else{
        self.wind.text = [NSString stringWithFormat:@"风向风力:%@风%ld级", model.directionOfwind,(long)model.wind];
    }
    self.city.text = self.nowCityModel.cityCC;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *risetimeStr = [dateFormatter stringFromDate:model.riseTime];
    NSString * settimeStr = [dateFormatter stringFromDate:model.setTime];

    if (model.riseTime == nil) {
        risetimeStr = @"";
        settimeStr = @"";
        self.suntime.text = [NSString stringWithFormat:@"日出日落:%@/%@", risetimeStr , settimeStr ];
    }else{
        self.suntime.text = [NSString stringWithFormat:@"日出日落:%@/%@", [risetimeStr substringWithRange:NSMakeRange(0, 5)], [settimeStr substringWithRange:NSMakeRange(0, 5)]];
    }

}
- (void)handleSunTimesInPeriod
{
    SqlDataBase *sqldata = [[SqlDataBase alloc]init];
    [sqldata configDatabase];
    NSArray * arr = [sqldata searchAllSaveCity];

    if (arr.count == 0 || [self.nowCityModel.lat isEqualToString:@" "]) {

        int temp = [self.nowCityModel.lat intValue];

        if (!temp) {
            [self handleSunTime:_indexpath];
            return;
        }
    }
    [JSNet handleSunTimesInPeriodWithCityModel:self.nowCityModel FinishBlock:^(NSData *data) {
        NSError * error = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:&error];
        if (!error) {
            NSArray * array = [dic objectForKey:@"d"];
            for (int i = 0; i< self.array.count; i++) {
                WeatherModel * model = [self.array objectAtIndex:i];
                
                NSString * riseTime = [[[array objectAtIndex:i] objectForKey:@"RiseTime"] substringWithRange:NSMakeRange(6, 13)];
                NSString * setTime = [[[array objectAtIndex:i] objectForKey:@"SetTime"] substringWithRange:NSMakeRange(6, 13)];
                
                model.riseTime = [NSDate dateWithTimeIntervalSince1970:([riseTime longLongValue]/1000.0)];
                model.setTime = [NSDate dateWithTimeIntervalSince1970:([setTime longLongValue]/1000.0)];
            }
            [self handleSunTime:_indexpath];
        } else {
            NSLog(@"日出日落请求失败");
        }
    }];
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
                                    limitNumber = @"节假日不限行";
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
                                        limitNumber = @"节假日不限行";
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
                                        limitNumber = @"节假日不限行";
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
                                            limitNumber = @"节假日不限行";
                                            limitTime = @" ";
                                        }else if ([week isEqualToString:@"星期六"] || [week isEqualToString:@"星期日"]){
                                            limitNumber = @"周末不限行";
                                            limitTime = @" ";

                                        }else{
                                            if ([Datetime isAdjustDay:month andDay:day]) {
                                                if ([week isEqualToString:@"星期日"] && [Datetime isAdjustDay:month andDay:day-1]) {
                                                    columnStr = @"LocalLimitNumber2";
                                                }else{
                                                    columnStr = @"LocalLimitNumber1";
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
                                        }else if ([self.nowCityModel.cityCC rangeOfString:@"哈尔滨"].location !=NSNotFound){
                                            sql = @"select * from LimitNumber where City = '哈尔滨'";
                                        }else if ([self.nowCityModel.cityCC rangeOfString:@"济南"].location !=NSNotFound){
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

- (void)setbackgroundImage
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.view addSubview:backgroundImage];
    backgroundImage.image = self.image;
    [self.view sendSubviewToBack:backgroundImage];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImage *leftimage = [UIImage imageNamed:@"back_Black"];
    UIButton * leftButton = [[UIButton alloc]init];
    leftButton.frame = CGRectMake(0, 0, 22, 22);
    [leftButton setImage:leftimage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBackViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    // 分享按钮
    UIImage *rightimage = [UIImage imageNamed:@"share_black"];
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 18, 24);
    [rightButton setImage:rightimage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}
- (void)goBackViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareAction
{
    NSLog(@"分享给好友");
    UIImage * image = [Help captureView:self.view];
    NSArray *activityItems = [[NSArray alloc]initWithObjects:image, nil];
    UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
    UIActivityViewControllerCompletionHandler myblock = ^(NSString *type,BOOL completed){
        NSLog(@"completed:%d type:%@",completed,type);
    };
    avc.completionHandler = myblock;
}
- (void)setFlowLayout
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView.collectionViewLayout = flow;
    UINib *nib = [UINib nibWithNibName:@"IndexCollectionViewCell_down" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"INDEXCOLLECTIONVIEWCELLDOWN"];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.sectionInset = UIEdgeInsetsZero;
    flow.itemSize = CGSizeMake(frame.size.width/3-1, self.collectionView.frame.size.height-2);
    NSLog(@":%f   %f",self.collectionView.frame.size.height , flow.itemSize.height);
    
    flow.minimumLineSpacing = 1;
    flow.minimumInteritemSpacing = 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IndexCollectionViewCell_down * cell = nil;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"INDEXCOLLECTIONVIEWCELLDOWN" forIndexPath:indexPath];

    if (self.array.count > 0) {
         WeatherModel * model = [self.array objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        NSString *attriString = [NSString stringWithFormat:@"今天\n%ld.%ld", (long)model.month, (long)model.day];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attriString];
        [str addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:CALENDARFONTHEITI size:24]
                            range:NSMakeRange(0, 2)];
        cell.date.attributedText = str;
    }else if (indexPath.row == 1){
        NSString *attriString =  [NSString stringWithFormat:@"明天\n%ld.%ld", (long)model.month, (long)model.day];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attriString];
        [str addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:CALENDARFONTHEITI size:24]
                    range:NSMakeRange(0, 2)];
        cell.date.attributedText = str;
    }else if (indexPath.row == 2) {
        NSString *attriString =  [NSString stringWithFormat:@"后天\n%ld.%ld", (long)model.month, (long)model.day];
         NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attriString];
        [str addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:CALENDARFONTHEITI size:24]
                    range:NSMakeRange(0, 2)];
        cell.date.attributedText = str;
    } else {
        cell.date.text = [NSString stringWithFormat:@"%ld.%ld", (long)model.month, (long)model.day];
    }
    if (_indexpath == indexPath.row) {
        cell.downArrow.alpha = 1;
        
    } else {
        cell.downArrow.alpha = 0;
    }
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [collectionView visibleCells];
    for (IndexCollectionViewCell_down *cell in array) {
        cell.downArrow.alpha = 0;
    }
    IndexCollectionViewCell_down *cell = (IndexCollectionViewCell_down *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.downArrow.alpha = 1;
    _indexpath = indexPath.row;
    [self handleSunTime:_indexpath];
}
-(void)dealloc
{
    [limitNumberDB close];
}

@end
