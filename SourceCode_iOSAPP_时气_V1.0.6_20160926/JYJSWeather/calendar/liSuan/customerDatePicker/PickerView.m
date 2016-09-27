//
//  PickerView.m
//  naviel
//
//  Created by mac on 14-6-11.
//  Copyright (c) 2014年 chris. All rights reserved.
//

#import "PickerView.h"
#import "Date+string.h"
#import "Tool_ChineseCalendar.h"
#import "ConvertLunarOrSolar.h"
//#import "JMWhenTapped.h"
#import "NSDate+BeeExtension.h"
#import "CalendarViewController1.h"
#import "dateModel.h"

@interface PickerView ()

@property(nonatomic,strong) NSArray * arrYear;/*年份*/
@property(nonatomic,strong) NSMutableArray * arrMonthList;/*月份*/
@property(nonatomic,strong) NSArray * arrDayBigList;/*大月天数*/
@property(nonatomic,strong) NSArray  * arrDayLittleList;/*小月天数*/
@property(nonatomic,strong) NSMutableArray *arrSola;
@property(nonatomic,strong) NSArray  * lunSolArray;/*阴阳数组年 根据条件改变*/
@property(nonatomic,strong) NSMutableArray  * lunSolMonArray;/*阴阳数组月 根据条件改变*/
@property(nonatomic,strong) NSDictionary * dicYearBaseList;
@property(nonatomic,strong) NSArray *MonthReferList;/*月数组*/
@property(nonatomic,strong) NSString * strMonth;/*月份对应码，每一位代表一个月,为1则为大月,为0则为小月*/
@property(nonatomic,strong) UISegmentedControl * segment;
@property(nonatomic,strong) ConvertLunarOrSolar *convert;
@property(nonatomic,strong) NSMutableArray *hourArray;/*小时数组*/
@property(nonatomic,strong) NSMutableArray *minutArray;/*分钟数组*/

@end

@implementation PickerView
{
    BOOL isBigMonth;
    BOOL valueChanged;
    NSInteger indexYear;/*选择年份对应的行数下标*/
    NSInteger indexMonth;/*选择月份对应下标*/
    NSInteger indexDay;/*选择天数对应下标*/
    NSInteger indexHour;/*选择天数对应下标*/
    NSInteger indexMinu;/*选择天数对应下标*/
    UIButton *_selectedButton01;
}
//DEF_SIGNAL( SELDATE )
//DEF_SIGNAL( SELDATE5 )
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect selfRect;

        selfRect = CGRectMake(0, 0,ScreenWidth, ScreenHeight);

        self.frame = selfRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
        UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignViewResponder)];
        [self addGestureRecognizer:singleTap2];
        
        _arrYear =[[NSArray alloc] init];
        _arrDayBigList =[[NSArray alloc] init];
        _arrDayLittleList =[[NSArray alloc] init];
        
        _arrYear =@[@"一九零一",@"一九零二",@"一九零三",@"一九零四",@"一九零五",@"一九零六",@"一九零七",@"一九零八",@"一九零九",/*1*/
                   @"一九一零",@"一九一一",@"一九一二",@"一九一三",@"一九一四",@"一九一五",@"一九一六",@"一九一七",@"一九一八",@"一九一九",/*2*/
                   @"一九二零",@"一九二一",@"一九二二",@"一九二三",@"一九二四",@"一九二五",@"一九二六",@"一九二七",@"一九二八",@"一九二九",/*3*/
                   @"一九三零",@"一九三一",@"一九三二",@"一九三三",@"一九三四",@"一九三五",@"一九三六",@"一九三七",@"一九三八",@"一九三九",/*4*/
                   @"一九四零",@"一九四一",@"一九四二",@"一九四三",@"一九四四",@"一九四五",@"一九四六",@"一九四七",@"一九四八",@"一九四九",/*5*/
                   @"一九五零",@"一九五一",@"一九五二",@"一九五三",@"一九五四",@"一九五五",@"一九五六",@"一九五七",@"一九五八",@"一九五九",/*6*/
                   @"一九六零",@"一九六一",@"一九六二",@"一九六三",@"一九六四",@"一九六五",@"一九六六",@"一九六七",@"一九六八",@"一九六九",/*7*/
                   @"一九七零",@"一九七一",@"一九七二",@"一九七三",@"一九七四",@"一九七五",@"一九七六",@"一九七七",@"一九七八",@"一九七九",/*8*/
                   @"一九八零",@"一九八一",@"一九八二",@"一九八三",@"一九八四",@"一九八五",@"一九八六",@"一九八七",@"一九八八",@"一九八九",/*9*/
                   @"一九九零",@"一九九一",@"一九九二",@"一九九三",@"一九九四",@"一九九五",@"一九九六",@"一九九七",@"一九九八",@"一九九九",/*10*/
                   @"二零零零",@"二零零一",@"二零零二",@"二零零三",@"二零零四",@"二零零五",@"二零零六",@"二零零七",@"二零零八",@"二零零九",/*11*/
                   @"二零一零",@"二零一一",@"二零一二",@"二零一三",@"二零一四",@"二零一五",@"二零一六",@"二零一七",@"二零一八",@"二零一九",/*12*/
                   @"二零二零",@"二零二一",@"二零二二",@"二零二三",@"二零二四",@"二零二五",@"二零二六",@"二零二七",@"二零二八",@"二零二九",/*13*/
                   @"二零三零",@"二零三一",@"二零三二",@"二零三三",@"二零三四",@"二零三五",@"二零三六",@"二零三七",@"二零三八",@"二零三九",/*14*/
                   @"二零四零",@"二零四一",@"二零四二",@"二零四三",@"二零四四",@"二零四五",@"二零四六",@"二零四七",@"二零四八",@"二零四九",/*15*/
                   ];

        _arrDayBigList =@[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                         @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                         @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
        
        _arrDayLittleList = [_arrDayBigList subarrayWithRange:NSMakeRange(0, 29)];
        
        _MonthReferList =@[@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊"];
        
        _convert = [[ConvertLunarOrSolar alloc] init];
        NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"lunarcalenda" ofType:@"plist"];
        _dicYearBaseList =[[NSDictionary alloc] initWithContentsOfFile:strBasePath];
        _arrMonthList =[[NSMutableArray alloc] init];
        _lunSolMonArray = [[NSMutableArray alloc] init];
        _arrSola = [[NSMutableArray alloc] init];
        
        indexYear=0;
        indexMonth=0;
        indexDay=0;
        valueChanged=0;
        _lunSolArray = [[NSArray alloc] initWithArray:_arrYear];

    }
    return self;
}
-(void)resignViewResponder2
{
}
-(void)resignViewResponder
{
    [self animationExict];
}
-(void)initDate:(NSDate*)date calendarType:(NSInteger)calendarType
{
    UIView * view= [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 252, ScreenWidth, 252)];
    view.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [self addSubview:view];
    
    _pickerView =[[UIPickerView alloc] init];
    _pickerView.frame = CGRectMake(0, 0, ScreenWidth, 162);
    _pickerView.delegate=self;
    _pickerView.dataSource=self;
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.backgroundColor = UIColorFromRGB(0xffffff);
    _pickerView.alpha = 1.0f;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignViewResponder2)];
    [view addGestureRecognizer:singleTap];
    [view addSubview:_pickerView];
    
    UIView * paddingLineW = [[UIView alloc] init];
    CGRect rect01 = CGRectMake(0, 162.5f, ScreenWidth, 0.5f);
    paddingLineW.frame = rect01;
    paddingLineW.backgroundColor = UIColorFromRGB(0xb3ae95);
    [view addSubview:paddingLineW];
    
    UIView * paddingLineWT = [[UIView alloc] initWithFrame:CGRectMake(0, 207.5f, ScreenWidth, 0.5f)];
    paddingLineWT.backgroundColor = UIColorFromRGB(0xb3ae95);
    [view addSubview:paddingLineWT];
    
    UIView * paddingLineL = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth * 0.5 -0.5f,208, 0.5f, 44)];
    paddingLineL.backgroundColor = UIColorFromRGB(0xb3ae95);
    [view addSubview:paddingLineL];
    
    //     添加取消按钮
    CGRect frame = CGRectMake(0, 208, ScreenWidth * 0.5 - 0.5f, 44);
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.frame=frame;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchDown];
    
    [view addSubview:cancelButton];
    
    //     添加确定按钮
    CGRect selectFrame = CGRectMake(ScreenWidth * 0.5 ,208, ScreenWidth * 0.5, 44);
    UIButton * selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectButton.frame=selectFrame;
    [selectButton setTitle:@"确定" forState:UIControlStateNormal];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:18];
    selectButton.backgroundColor = [UIColor whiteColor];
    [selectButton addTarget:self action:@selector(selectPressed:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:selectButton];
    
    //添加阴阳历选择按钮
    CGFloat btnW = 44;
    CGRect rect1 = CGRectMake(0, 163, ScreenWidth*0.5 - 0.5, btnW);
    UIButton *yang = [self createBtnWithName:@"阳历选择" rect:rect1 tag:10 imageName:@"keSong_CellSeleted0" selectedImage:@"keSong_CellSeleted1"];
    self.yangBtn = yang;
    _selectedButton01 = yang;
    _selectedButton01.enabled = NO;
    [view addSubview:yang];
    
    CGRect rect2 = CGRectMake(ScreenWidth*0.5 , 163, ScreenWidth*0.5 , btnW);
    UIButton * yin = [self createBtnWithName:@"阴历选择" rect:rect2 tag:11 imageName:@"keSong_CellSeleted0" selectedImage:@"keSong_CellSeleted1"];
    self.yinBtn = yin;
    [view addSubview:yin];
    //指定初始时间
    if(calendarType == CalendarTypeLunar)
    {
        [self initlunarDate:[date year] month:[date month] day:[date day]];
    }else
    {
        [self initSolarDate:[date year] month:[date month] day:[date day]];
        _selectedButton01 = yang;
    }
    
    if(_pickerViewCount == PickerViewCount5)
    {
        _hourArray = [[NSMutableArray alloc]init];
        _minutArray = [[NSMutableArray alloc]init];
        for (int i=0; i<24; i++) {
            [_hourArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        for (int i=0; i<60; i++) {
            [_minutArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        indexHour = [date hour];
        indexMinu = [date minute];
        [_pickerView selectRow:[_hourArray indexOfObject:[NSString stringWithFormat:@"%ld",(long)indexHour]] inComponent:3 animated:NO];
        [_pickerView selectRow:[_minutArray indexOfObject:[NSString stringWithFormat:@"%ld",(long)indexMinu]] inComponent:4 animated:NO];
    }
    [_pickerView selectRow:indexYear inComponent:0 animated:NO];
    [_pickerView selectRow:indexMonth inComponent:1 animated:NO];
    [_pickerView selectRow:indexDay inComponent:2 animated:NO];
}

-(void)onYinYangBtnClick:(UIButton *)sender
{

    _selectedButton01.enabled = YES;
    _selectedButton01 = sender;
    _selectedButton01.enabled = NO;
    
    if(sender.tag == 10)
    {
        NSInteger  year=[[Date_string setYearInt:_lunSolArray[indexYear]] intValue];
        NSInteger  month =[[Date_string setMonthInt:_arrMonthList[indexMonth]] intValue];
        NSInteger  day =[[Date_string setDayInt:_arrDayBigList[indexDay]] intValue];
        NSInteger  reserved =[[Date_string setReservedInt:_arrMonthList[indexMonth]] intValue];
        
        
        NSArray * lunarArray = [_convert convertLunar2Solar:day lunarMonth:month lunarYear:year lunarLeap:reserved];
        

        [self initSolarDate:[lunarArray[2] intValue] month:[lunarArray[1] intValue] day:[lunarArray[0] intValue]];
        

        [_pickerView reloadComponent:0];
        [_pickerView reloadComponent:1];
        [_pickerView reloadComponent:2];
        [_pickerView selectRow:indexYear inComponent:0 animated:YES];
        [_pickerView selectRow:indexMonth inComponent:1 animated:YES];
        [_pickerView selectRow:indexDay inComponent:2 animated:YES];
        
    }else
    {
        
        NSInteger year  = [_lunSolArray[indexYear] intValue];
        NSInteger month = [_arrMonthList[indexMonth] intValue];
        NSInteger day   = [_arrSola[indexDay] intValue];
        [self initlunarDate:year month:month day:day];
        
        [_pickerView reloadComponent:0];
        [_pickerView reloadComponent:1];
        [_pickerView reloadComponent:2];
        [_pickerView selectRow:indexYear inComponent:0 animated:YES];
        [_pickerView selectRow:indexMonth inComponent:1 animated:YES];
        [_pickerView selectRow:indexDay inComponent:2 animated:YES];
    }

}

-(UIButton *)createBtnWithName:(NSString *)btnName rect:(CGRect)rect tag:(NSInteger)tag imageName:(NSString *)imageName selectedImage:(NSString *)selectedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.tag =tag;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateDisabled];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [button setTitle:btnName forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x867f7f) forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(onYinYangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;

}

/**
 *动画退出
 */
-(void)animationExict
{
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, ScreenHeight);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void) cancelPressed:(id)sender
{
    [self animationExict];
}

-(void) selectPressed:(id)sender
{
    
//    NSLog(@"(((((((((((((()))))))))))))))");
//    UIButton * btn = (UIButton *)sender;
    NSInteger  year;
    NSInteger  month;
    NSInteger  day;
    NSInteger  reserved;
    NSDate *date;
    NSString *dateString;
    if(valueChanged)
    {
        if(_selectedButton01.tag == 11)
        {
            year  =[[Date_string setYearInt:_lunSolArray[indexYear]] intValue];
            month =[[Date_string setMonthInt:_arrMonthList[indexMonth]] intValue];
            day   =[[Date_string setDayInt:_arrDayBigList[indexDay]] intValue];
            reserved =[[Date_string setReservedInt:_arrMonthList[indexMonth]] intValue];
            NSArray * lunarArray = [_convert convertLunar2Solar:day lunarMonth:month lunarYear:year lunarLeap:reserved];
            
            dateString = [NSString stringWithFormat:@"%d-%0.2d-%0.2d",[lunarArray[2] intValue],[lunarArray[1] intValue],[lunarArray[0] intValue]];
            date =[NSDate dateFromFormatterString:dateString dateFormat:@"yyyy-MM-dd"];
            
            if(_pickerViewCount == PickerViewCount5)
            {
                NSMutableArray *tmp = [[NSMutableArray alloc] init];
                tmp[0] = dateString;
                tmp[1] = [NSString stringWithFormat:@"%d年%@月%@日 %0.2d:%0.2d",year,_arrMonthList[indexMonth],_arrDayBigList[indexDay],indexHour,indexMinu];
                NSMutableDictionary * dir = [[NSMutableDictionary alloc] init];
                [dir setObject:tmp forKey:@"array"];
                [dir setObject:date forKey:@"date"];
            }else
            {
                NSMutableArray *tmp = [[NSMutableArray alloc] init];
                tmp[0] = dateString;
                tmp[1] = [NSString stringWithFormat:@"%d年%@月%@",year,_arrMonthList[indexMonth],_arrDayBigList[indexDay]];
                NSMutableDictionary * dir = [[NSMutableDictionary alloc] init];
                [dir setObject:tmp forKey:@"array"];
                [dir setObject:date forKey:@"date"];
            }
        }else
        {
            year  = [_lunSolArray[indexYear] intValue];
            month = [_arrMonthList[indexMonth] intValue];
            day   = [_arrSola[indexDay] intValue];
            dateString = [NSString stringWithFormat:@"%ld-%0.2ld-%0.2ld",(long)year,(long)month,(long)day];
            date =[NSDate dateFromFormatterString:dateString dateFormat:@"yyyy-MM-dd"];
            if(_pickerViewCount == PickerViewCount5)
            {
                NSArray * lunarArray = [_convert convertSolar2Lunar:day mm:month yy:year];
                NSString *strMonth_date =[NSString stringWithFormat:@"%dx%d",[lunarArray[1] intValue],[lunarArray[3] intValue]];
                NSString *strDay_date =[NSString stringWithFormat:@"%0.2d",[lunarArray[0] intValue]];
                NSMutableArray *tmp = [[NSMutableArray alloc] init];
                tmp[0] = dateString;
                tmp[1] = [NSString stringWithFormat:@"%ld年%@月%@日",year,[Date_string setMonthBaseSting:strMonth_date],[Date_string setDayBaseSting:strDay_date]];
                NSMutableDictionary * dir = [[NSMutableDictionary alloc] init];
                [dir setObject:tmp forKey:@"array"];
                [dir setObject:date forKey:@"date"];
            }
        }
    }else {
        if (_selectedButton01.tag == 11) {
            year  =[[Date_string setYearInt:_lunSolArray[indexYear]] intValue];
            month =[[Date_string setMonthInt:_arrMonthList[indexMonth]] intValue];
            day   =[[Date_string setDayInt:_arrDayBigList[indexDay]] intValue];
            reserved =[[Date_string setReservedInt:_arrMonthList[indexMonth]] intValue];
            NSArray * lunarArray = [_convert convertLunar2Solar:day lunarMonth:month lunarYear:year lunarLeap:reserved];
            
            dateString = [NSString stringWithFormat:@"%d-%0.2d-%0.2d",[lunarArray[2] intValue],[lunarArray[1] intValue],[lunarArray[0] intValue]];
        }else {
            year  = [_lunSolArray[indexYear] intValue];
            month = [_arrMonthList[indexMonth] intValue];
            day   = [_arrSola[indexDay] intValue];
            dateString = [NSString stringWithFormat:@"%ld-%0.2ld-%0.2ld",(long)year,(long)month,(long)day];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(pickerViewDelegateWithDateString:)]) {
        [self.delegate pickerViewDelegateWithDateString:dateString];
    }
   [self animationExict];
}



-(void)initSolarDate:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    _lunSolMonArray = _arrMonthList;
    _lunSolArray = [Date_string setYearsToPick];
    _arrMonthList = [[NSMutableArray alloc] initWithArray:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"]];
    
    NSInteger days = [Tool_ChineseCalendar solarDays:year m:month];
    NSInteger index = [_arrMonthList indexOfObject:[NSString stringWithFormat:@"%d",month]];
    
    [_arrSola removeAllObjects];
    for(int i=1;i<=days;i++)
    {
        [_arrSola addObject:[NSString stringWithFormat:@"%d",i]];
    }
    NSInteger tmpIndexY = [_lunSolArray indexOfObject:[NSString stringWithFormat:@"%d",year]];
    indexDay = day-1;
    indexMonth = index;
    indexYear = tmpIndexY;
}

/*设定初始时间*/
- (void)initlunarDate:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    _lunSolArray = _arrYear;
    _arrMonthList = _lunSolMonArray;
    NSArray * solarArray = [_convert convertSolar2Lunar:day mm:month yy:year];
    NSString *strYear_date =[NSString stringWithFormat:@"%d",[solarArray[2] intValue]];
    NSString *strMonth_date =[NSString stringWithFormat:@"%dx%d",[solarArray[1] intValue],[solarArray[3] intValue]];
    NSString *strDay_date =[NSString stringWithFormat:@"%d",[solarArray[0] intValue]];
    [self setPickerViewSlelctRowAndConponent:strYear_date Month:strMonth_date Day:strDay_date];

}

/*设定初始时间*/
- (void)setPickerViewSlelctRowAndConponent:(NSString *)year Month:(NSString *)month Day:(NSString *)day{
    year =[Date_string setYearBaseSting:year];
    month =[Date_string setMonthBaseSting:month];
    if(day.length < 2)
    {
        day = [NSString stringWithFormat:@"0%@",day];
    }
    day =[Date_string setDayBaseSting:day];
    /*指定年份*/
    for (int i=0; i<_lunSolArray.count; i++) {
        
        if ([year isEqualToString:_lunSolArray[i]]) {
            indexYear=i;
            
        }
    }
    [self setMonthAndDay:_dicYearBaseList[_lunSolArray[indexYear]]];
    
    /*指定月份*/
    for (int i=0; i<_arrMonthList.count; i++) {
        
        if ([month isEqualToString:_arrMonthList[i]]) {
            
            indexMonth=i;
        }
    }
    
    [self setDay:indexMonth];
    if(isBigMonth)
    {
        for (int i=0; i<_arrDayBigList.count; i++) {
            if ([day isEqualToString:_arrDayBigList[i]]) {
                indexDay=i;
            }
        }
    }else
    {
        for (int i=0; i<_arrDayLittleList.count; i++) {
            if ([day isEqualToString:_arrDayLittleList[i]]) {
                indexDay=i;
            }
        }
    }
    /*指定日份*/

}

//刷新内容属性(月，日)
- (void)setMonthAndDay:(NSString *)strYearBase{/*传入对应的年份编码制*/
    
    NSString * MonthAndDay =[strYearBase substringFromIndex:3];
    _strMonth  =[[self getBinaryByhex:MonthAndDay] substringToIndex:12];/*用于大月平月的判断字符串*/
    [self setLeapMonth:strYearBase];/*判断闰月*/
}

//判断闰月以及闰月的天数
- (void)setLeapMonth:(NSString *)YearBaseDate{
    NSString *isLeap=[YearBaseDate substringFromIndex:YearBaseDate.length-1];
    NSString *isBigLeap =[YearBaseDate substringToIndex:1];
    if (![isLeap isEqualToString:@"0"]) {/*是否有闰月*/
        if ([isBigLeap isEqualToString:@"0"]) {
            //闰小月
            if (_arrMonthList) [_arrMonthList removeAllObjects];
            int leapNumnber=[isLeap intValue];
            
            for (int i=0; i<_strMonth.length; i++) {
                [_arrMonthList  addObject:_MonthReferList[i]];
                if (leapNumnber-1==i)[_arrMonthList addObject:[NSString stringWithFormat:@"闰%@",_MonthReferList[leapNumnber-1]]];
            }
            
            NSString * strOne =[_strMonth substringToIndex:leapNumnber];
            NSString * strTwo =[_strMonth substringFromIndex:leapNumnber];
            _strMonth =[NSString stringWithFormat:@"%@0%@",strOne,strTwo];
        }else{
            //闰大月
            if (_arrMonthList) [_arrMonthList removeAllObjects];
            int leapNumnber=[isLeap intValue];
            for (int i=0; i<_strMonth.length; i++) {
                [_arrMonthList  addObject:_MonthReferList[i]];
                if (leapNumnber-1==i)[_arrMonthList addObject:[NSString stringWithFormat:@"闰%@",_MonthReferList[leapNumnber-1]]];
            }
            
            NSString * strOne =[_strMonth substringToIndex:leapNumnber];
            NSString * strTwo =[_strMonth substringFromIndex:leapNumnber];
            _strMonth =[NSString stringWithFormat:@"%@1%@",strOne,strTwo];
        }
    }else{//如果不闰月
        if (_arrMonthList) [_arrMonthList removeAllObjects];
        _arrMonthList =[[NSMutableArray alloc] initWithArray:_MonthReferList];
    }
}


//刷新内容属性(日)<判断是否为大月，平月>
- (void)setDay:(NSInteger)row{
    NSString * strBool;
    int count =row;
    int max =_strMonth.length;
    if (count<max) {
        strBool=[_strMonth substringFromIndex:row];
    }else{
        strBool=[_strMonth substringFromIndex:_strMonth.length-1];
    }
    
    strBool =[strBool substringToIndex:1];
    if ([strBool isEqualToString:@"0"])isBigMonth=NO;
    else isBigMonth=YES;

}


//将16进制转化为二进制
-(NSString *)getBinaryByhex:(NSString *)hex
{
    NSMutableDictionary  *hexDic;
    
    hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    
    [hexDic setObject:@"0000" forKey:@"0"];
    
    [hexDic setObject:@"0001" forKey:@"1"];
    
    [hexDic setObject:@"0010" forKey:@"2"];
    
    [hexDic setObject:@"0011" forKey:@"3"];
    
    [hexDic setObject:@"0100" forKey:@"4"];
    
    [hexDic setObject:@"0101" forKey:@"5"];
    
    [hexDic setObject:@"0110" forKey:@"6"];
    
    [hexDic setObject:@"0111" forKey:@"7"];
    
    [hexDic setObject:@"1000" forKey:@"8"];
    
    [hexDic setObject:@"1001" forKey:@"9"];
    
    [hexDic setObject:@"1010" forKey:@"a"];
    
    [hexDic setObject:@"1011" forKey:@"b"];
    
    [hexDic setObject:@"1100" forKey:@"c"];
    
    [hexDic setObject:@"1101" forKey:@"d"];
    
    [hexDic setObject:@"1110" forKey:@"e"];
    
    [hexDic setObject:@"1111" forKey:@"f"];
    
    NSString *binaryString=[[NSString alloc] init];
    
    for (int i=0; i<[hex length]; i++) {
        
        NSRange rage;
        
        rage.length = 1;
        
        rage.location = i;
        
        NSString *key = [hex substringWithRange:rage];
        
        NSString * strLast =[NSString stringWithFormat:@"%@",[hexDic objectForKey:key]];
        binaryString = [NSString stringWithFormat:@"%@%@",binaryString,strLast];
    }
    return binaryString;

}



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    valueChanged = 1;
    switch (component) {
        case 0:{
            indexYear=row;
            if(_selectedButton01.tag == 11)  //_segment.selectedSegmentIndex == 1
            {
                [self setMonthAndDay:_dicYearBaseList[_lunSolArray[row]]];
                [self setDay:indexMonth];
                [pickerView reloadComponent:1];
                indexMonth = [pickerView selectedRowInComponent:1];
            }else
            {
                [self setDays:[_lunSolArray[indexYear] intValue] month:[_arrMonthList[indexMonth] intValue]];
            }
            [pickerView reloadComponent:2];
            indexDay = [pickerView selectedRowInComponent:2];
        }
            break;
        case 1:{
            indexMonth=row;
            if(_selectedButton01.tag == 11)  //_segment.selectedSegmentIndex==1
            {
                [self setDay:indexMonth];
            }else
            {
                [self setDays:[_lunSolArray[indexYear] intValue] month:[_arrMonthList[indexMonth] intValue]];
            }
            [pickerView reloadComponent:2];
            indexDay = [pickerView selectedRowInComponent:2];
        }
            break;
        case 2: {
            indexDay =row;
            
        }
            break;
        case 3: {
            indexHour =row;
            
        }
            break;
        case 4: {
            indexMinu =row;
            
        }
            break;
        default:
            break;
    }

}

-(void)setDays:(NSInteger)year month:(NSInteger)month
{
    NSInteger days = [Tool_ChineseCalendar solarDays:year m:month];
    [_arrSola removeAllObjects];
    for(int i=1;i<=days;i++)
    {
        [_arrSola addObject:[NSString stringWithFormat:@"%d",i]];
    }

}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    UILabel *myView = nil;
    NSString *string = nil;
    switch (component) {
        case 0:{
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            string = [NSString stringWithFormat:@"%@年",[_lunSolArray objectAtIndex:row]];
            myView.text = string;
            //            myView.text = [_lunSolArray objectAtIndex:row];
            myView.font = [UIFont systemFontOfSize:pushFontSize];         //用label来设置字体大小
            myView.backgroundColor = [UIColor clearColor];
        }
            break;
        case 1:{
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
            string = [NSString stringWithFormat:@"%@月",[_arrMonthList objectAtIndex:row]];
            myView.text = string;
            //            myView.text = [_arrMonthList objectAtIndex:row];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.font = [UIFont systemFontOfSize:pushFontSize];
            myView.backgroundColor = [UIColor clearColor];
        }
            break;
        case 2:{
            if(_selectedButton01.tag == 11)  //  _segment.selectedSegmentIndex==1
            {
                myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
                if (isBigMonth)
                {
                    myView.text = [_arrDayBigList objectAtIndex:row];
                }
                else
                {
                    myView.text = [_arrDayLittleList objectAtIndex:row];
                }
                myView.textAlignment = NSTextAlignmentCenter;
                myView.font = [UIFont systemFontOfSize:pushFontSize];
                myView.backgroundColor = [UIColor clearColor];
            }else
            {
                
                myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
                string = [NSString stringWithFormat:@"%@日",[_arrSola objectAtIndex:row]];
                myView.text = string;
                //                myView.text = [_arrSola objectAtIndex:row];
                myView.textAlignment = NSTextAlignmentCenter;
                myView.font = [UIFont systemFontOfSize:pushFontSize];
                myView.backgroundColor = [UIColor clearColor];
            }
        }
            break;
        case 3:{
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
            string = [NSString stringWithFormat:@"%@时",[_hourArray objectAtIndex:row]];
            myView.text = string;
            //            myView.text = [NSString stringWithFormat:@"%@",[_hourArray objectAtIndex:row]];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.font = [UIFont systemFontOfSize:pushFontSize];
            myView.backgroundColor = [UIColor clearColor];
        }
            break;
        case 4:{
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
            string = [NSString stringWithFormat:@"%@分",[_minutArray objectAtIndex:row]];
            myView.text = string;
            //            myView.text = [_minutArray objectAtIndex:row];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.font = [UIFont systemFontOfSize:pushFontSize];
            myView.backgroundColor = [UIColor clearColor];
        }
            break;
        default:
            break;
    }


    return myView;

}


//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(_pickerViewCount==0)
    {
        _pickerViewCount = 3;
    }
    return _pickerViewCount;

}

//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(_selectedButton01.tag == 11)  //_segment.selectedSegmentIndex==1
    {
        switch (component) {
            case 0:{
                return _lunSolArray.count;}
                break;
            case 1:{
                return _arrMonthList.count;}
                break;
            case 2:{
                if (isBigMonth)return _arrDayBigList.count;
                else return _arrDayLittleList.count;
                
            }
                break;
            case 3:{
                return 24;
            }
                break;
            case 4:{
                return 60;
            }
                break;
            default:
                return 0;
                break;
        }
    }else
    {
        switch (component) {
            case 0:{
                return _lunSolArray.count;}
                break;
            case 1:{
                return _arrMonthList.count;}
                break;
            case 2:{
                return _arrSola.count;
            }
                break;
            case 3:{
                return 24;
            }
                break;
            case 4:{
                return 60;
            }
                break;
            default:
                return 0;
                break;
        }
    }

}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    
    return 40.0f;


}


@end
