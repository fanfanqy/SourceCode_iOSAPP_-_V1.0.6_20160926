//
//  CalendarViewController1.m
//  Calendar
//
//  Created by DEVP-IOS-03 on 16/4/12.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import "CalendarViewController1.h"
#import "Datetime.h"
#import "WanNianLiDate.h"
#import "calendarDBModel.h"
#import "PickerView.h"
#import "wanNianLiTool.h"

#import "liSuanCalendarView.h"
#import "AlmanacView.h"
#import "WeekView.h"
#import "NarrowCalendarView.h"
#import "ZangLiModel.h"
#import "AppDelegate.h"

#define BUDDHAIMAGEWIDTH 350
#define BUDDHAIMAGEHEIGHT 460

@interface CalendarViewController1 ()<lisuanCalendarViewDelegate,pickerViewDelegate,NarrowCalendarViewDelegate,UIScrollViewDelegate>
{
    FMDatabase * _db;
    FMDatabase * _zangLiDb;
    PickerView * _datepicker;//时间选择器作用:快速定位到某一个日期
    int isPush ;
    int labelIndexYi;
    int labelIndexJi;
     BOOL isPre;
}
@property (nonatomic,strong)UIButton *titlebutton;
@property (nonatomic,strong)liSuanCalendarView * calendarView;//日历
@property (nonatomic,strong)UIView * buddleView;
@property (nonatomic,strong)NSMutableArray * calendarArray;
@property (nonatomic,strong)NSMutableArray * narrowCalendarArray;
@property (nonatomic,strong)NSMutableArray * zangLiArray;
@property (nonatomic,strong)UIScrollView * scrView;

@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,strong)UIButton * today;
@property (nonatomic,strong)UIButton *updateBtn;
@property (nonatomic,strong)AlmanacView *almanacView;
@property (nonatomic,strong) WeekView *weekView;
@property (nonatomic,strong) NarrowCalendarView *narrowCalendarView;
@property (nonatomic,strong) UIImageView *navigationBackView;
@property (nonatomic,strong)NSString *titleStr;
@property (nonatomic,strong)UIButton *downBackgroundBtn;
@property (nonatomic,strong) UIButton *downButton;
@property (nonatomic,assign)BOOL isNarrow;
@property (nonatomic,assign)BOOL isShowNarrow;
@property (nonatomic,assign)int  isFirst;
@property (nonatomic,strong)NSMutableArray *arrayYi;
@property (nonatomic,strong)NSMutableArray *arrayJi;
@property (nonatomic,strong)AppDelegate *delegate;
@end

@implementation CalendarViewController1

//解决iOS7.0,- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath ,点击cell ,它会走layout subviews,iOS8及其以上不会
-(void)viewDidDisappear:(BOOL)animated{

}

- (void)viewDidLoad {
    
    [super  viewDidLoad];
    _isNarrow = NO;
    _isFirst = 0;
    _isShowNarrow = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    if (SystemVersion >= 10.0) {
         _navigationBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    }else{
         _navigationBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -64, ScreenWidth, 64)];
    }
    _navigationBackView.image = [UIImage imageNamed:@"navBackground"];
    [self.view addSubview:_navigationBackView];
    [self.view bringSubviewToFront:_navigationBackView];
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;

    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending ) {
        self.edgesForExtendedLayout = NO;
    }

    if (IS_IPHONE4 || IS_IPHONE5) {
        _delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [_delegate addLoadView];
    }

    self.calendarArray = [[NSMutableArray alloc] init];
    self.narrowCalendarArray = [[NSMutableArray alloc]init];
    _arrayYi = [NSMutableArray array];
    _arrayJi = [NSMutableArray array];
    [self setNavigationBar];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
            _db = [WanNianLiDate getDataBase];
            NSString * path = [[NSBundle mainBundle] pathForResource:@"zangli" ofType:@"db"];
            _zangLiDb = [[FMDatabase alloc] initWithPath:path];
            [_zangLiDb open];
            [self createScrollView];
            [self createToday];
            [self createWeekView];
            [self createCalendarView];
            [self createAlmanacView];

            if (IS_IPHONE4 || IS_IPHONE5) {
             [_delegate removeLoadView];
            }
        });
    });
}

- (void)setNavigationBar
{

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 22, 22);
    backBtn.contentMode = UIViewContentModeScaleAspectFit;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBackLastController) forControlEvents:UIControlEventTouchUpInside];

    UIButton *todayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    todayButton.frame = CGRectMake(30, 0, 25, 25);
    [todayButton setBackgroundImage:[UIImage imageNamed:@"today"] forState:UIControlStateNormal];
    [todayButton addTarget:self action:@selector(backTodayAction) forControlEvents:UIControlEventTouchUpInside];
    UIButton *kongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    kongButton.frame = CGRectMake(0, 0, 20, 23);


    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    UIBarButtonItem *todayButtonItem = [[UIBarButtonItem alloc]initWithCustomView:todayButton];
    UIBarButtonItem *kongButtonItem = [[UIBarButtonItem alloc]initWithCustomView:kongButton];

    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:backButtonItem,kongButtonItem,todayButtonItem, nil];
    
    /* 刷新titleButton*/
    _titlebutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 101, 21)];
    // 2个数字占据,一个字符距离,20
    _titlebutton.titleLabel.font = [UIFont fontWithName:CALENDARFONTKAITI size:18];

    [_titlebutton setTitle:@" " forState:UIControlStateNormal];
    _titleStr = [NSString stringWithFormat:@"%d-%d-%d", self.strYear,self.strMonth,self.strDay];
    [_titlebutton addTarget:self action:@selector(dateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titlebutton;
    
    UIButton *downButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 13, 8)];
    [downButton setImage:[UIImage imageNamed:@"open1"] forState:UIControlStateNormal];
    [downButton addTarget:self action:@selector(dateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *kongButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    kongButton1.frame = CGRectMake(0, 0, (ScreenWidth/2)-86, 23);
    UIBarButtonItem *downButtonItem = [[UIBarButtonItem alloc]initWithCustomView:downButton];
    UIBarButtonItem *kongButton1Item = [[UIBarButtonItem alloc]initWithCustomView:kongButton1];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:kongButton1Item,downButtonItem, nil];

}

-(void)createScrollView
{
//    self.scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    if (SystemVersion>=10.0) {
        self.scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0+topTabbrHeight, ScreenWidth, ScreenHeight-64)];
    }else{
        self.scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    }
    _scrView.showsHorizontalScrollIndicator = NO;
    _scrView.showsVerticalScrollIndicator = NO;
    _scrView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calendarBack"]];
    _scrView.bounces = NO;
    _scrView.delegate = self;
    _scrView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    [self.view addSubview:_scrView];
}
//上部分背景图
-(void)createToday{
    /**
     创建一个按钮作为背景
     */
    UIImage * nomal = [UIImage imageNamed:@"calendarTopBack"];//;//  btnBackGround
    _today = [[UIButton alloc] initWithFrame:CGRectMake(0, -2*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+0.5*TOPBUTTONHEIGHT, ScreenWidth, 14.8 * CALENDARBTNPADDING )];
    [_today setImage:nomal  forState:UIControlStateNormal];
    _today.adjustsImageWhenHighlighted = NO;
    [_scrView addSubview:_today];
}

#pragma mark - 星期View
-(void)createWeekView{
    _weekView = [[WeekView alloc]init];
//    _weekView.frame = CGRectMake(0, 0, ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
    if (SystemVersion>=10.0) {
        _weekView.frame = CGRectMake(0, 0+topTabbrHeight, ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
    }else{
        _weekView.frame = CGRectMake(0, 0, ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
    }
   _weekView.backgroundColor = [UIColor clearColor];//全透明
    [self.view addSubview:_weekView];
}

#pragma mark - 缩略日历试图
-(void)createNarrowCalendarView{
     _narrowCalendarView = [[NarrowCalendarView alloc]initWithFrame:CGRectMake(0, -1*(CALENDARBTNPADDING+TOPBUTTONHEIGHT), ScreenWidth, 2.4*CALENDARBTNPADDING)];
    _narrowCalendarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calendarTopBack"]];
    _narrowCalendarView.delegate = self;
    _narrowCalendarView.opaque = NO;
    _downButton = [[UIButton alloc]initWithFrame:CGRectMake(0.5*ScreenWidth-17, _narrowCalendarView.frame.origin.y+_narrowCalendarView.frame.size.height+5, 40, 24)];
    [_downButton setImage:[UIImage imageNamed:@"open0"] forState:UIControlStateNormal];
    _downButton.contentMode = UIViewContentModeScaleAspectFit;
    [_downButton addTarget:self action:@selector(showCalendarView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_narrowCalendarView];
    [self.view addSubview:_downButton];
}

#pragma mark - 日历View
-(void)createCalendarView
{
    _isNarrow = NO;
    _calendarView = [[liSuanCalendarView alloc] initWithFrame:CGRectMake(CALENDARBTNPADDING * 0.5,2*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+TOPBUTTONHEIGHT, ScreenWidth-CALENDARBTNPADDING, 13 * CALENDARBTNPADDING+2) andYear:_strYearMain  andMonth:_strMonthMain andDay:_strDayMain];
    _calendarView.opaque = NO;

    _calendarView.backgroundColor = [UIColor clearColor];
    _calendarView.delegate = self;
    [_today addSubview:_calendarView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_calendarView markDataWithYear:_strYear month:_strMonth day:_strDay andIsSwipe:NO];
        });
    });
}

#pragma mark 变化后的坐标需要改变
-(void)showToday{
    UIImage * nomal = [UIImage imageNamed:@"calendarTopBack"];//;//  btnBackGround
    _today = [[UIButton alloc] initWithFrame: CGRectMake(0, -8*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+0.5*TOPBUTTONHEIGHT, ScreenWidth, 14.8 * CALENDARBTNPADDING )];
    [_today setImage:nomal  forState:UIControlStateNormal];
    _today.adjustsImageWhenHighlighted = NO;
    [_scrView addSubview:_today];

}

-(void)showAndCreateCalendarView{
     _calendarView = [[liSuanCalendarView alloc] initWithFrame:CGRectMake(CALENDARBTNPADDING * 0.5, 2*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+TOPBUTTONHEIGHT, ScreenWidth-CALENDARBTNPADDING, 13 * CALENDARBTNPADDING+2) andYear:_strYear andMonth:_strMonth andDay:_strDay];
    _calendarView.opaque = NO;
    _calendarView.backgroundColor = [UIColor clearColor];
    _calendarView.delegate = self;
    [_today addSubview:_calendarView];
    [_calendarView markDataWithYear:_strYear month:_strMonth day:_strDay andIsSwipe:NO];
}

-(void)showCalendarView{
    _isFirst = 0;
    _isNarrow = NO;
    [self showToday];
    [self.view bringSubviewToFront:_navigationBackView];
    [self showAndCreateCalendarView];
    [_downButton removeFromSuperview];
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.95 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _narrowCalendarView.frame = CGRectMake(0, -2*(CALENDARBTNPADDING+TOPBUTTONHEIGHT), ScreenWidth, 2.4*CALENDARBTNPADDING);
        _today.frame = CGRectMake(0, -2*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+0.5*TOPBUTTONHEIGHT, ScreenWidth, 14.8 * CALENDARBTNPADDING );
         [_scrView setContentOffset:CGPointMake(0, 0)];
         _downBackgroundBtn.frame = CGRectMake(0, _today.frame.origin.y+_today.frame.size.height+7, ScreenWidth, ScreenHeight-64);
          _scrView.contentSize = CGSizeMake(ScreenWidth, _downBackgroundBtn.frame.origin.y + _downBackgroundBtn.frame.size.height);
    } completion:^(BOOL finished) {
        [_narrowCalendarView removeFromSuperview];
    }];
}

-(void)tap{
    //变成缩略状态
    _isShowNarrow = YES;
    [self createNarrowCalendarView];
    [self.view bringSubviewToFront:_navigationBackView];
    [_narrowCalendarView markDataWithYear:_strYear month:_strMonth day:_strDay];
    [self.view bringSubviewToFront:_weekView];
    [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.95 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveLinear animations:^{

            if (SystemVersion>=10.0) {
                _narrowCalendarView.frame = CGRectMake(0, 1*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+topTabbrHeight, ScreenWidth, 2.4*CALENDARBTNPADDING);
            }else{
                _narrowCalendarView.frame = CGRectMake(0, 1*(CALENDARBTNPADDING+TOPBUTTONHEIGHT), ScreenWidth, 2.4*CALENDARBTNPADDING);
            }
//            _today.frame = CGRectMake(0, -8*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+0.5*TOPBUTTONHEIGHT-topTabbrHeight, ScreenWidth, 14.8 * CALENDARBTNPADDING );
         _today.frame = CGRectMake(0, -8*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+0.5*TOPBUTTONHEIGHT, ScreenWidth, 14.8 * CALENDARBTNPADDING );
//            _narrowCalendarView.frame = CGRectMake(0, 1*(CALENDARBTNPADDING+TOPBUTTONHEIGHT), ScreenWidth, 2.4*CALENDARBTNPADDING);
//            _today.frame = CGRectMake(0, -8*(CALENDARBTNPADDING+TOPBUTTONHEIGHT)+0.5*TOPBUTTONHEIGHT, ScreenWidth, 14.8 * CALENDARBTNPADDING );

            _downButton.frame = CGRectMake(0.5*ScreenWidth-17, _narrowCalendarView.frame.origin.y+_narrowCalendarView.frame.size.height+3, 34, 24);
            [_scrView setContentOffset:CGPointMake(0, 3.0*CALENDARBTNPADDING-9.0*TOPBUTTONHEIGHT-100) ];
            _downBackgroundBtn.frame = CGRectMake(0, 3*CALENDARBTNPADDING+TOPBUTTONHEIGHT+7, ScreenWidth, ScreenHeight-64+AlmanacDownHeight);
            _scrView.contentSize = CGSizeMake(ScreenWidth, _downBackgroundBtn.frame.origin.y + _downBackgroundBtn.frame.size.height);
        } completion:^(BOOL finished) {
            [_calendarView removeFromSuperview];
            [_today removeFromSuperview];
        }];
}

#pragma mark - 黄历View
-(void)createAlmanacView{
    _downBackgroundBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _today.frame.origin.y+_today.frame.size.height+7, ScreenWidth, ScreenHeight-64+AlmanacDownHeight)];

    [_downBackgroundBtn setImage:[UIImage imageNamed:@"calendarDownBack"] forState:UIControlStateNormal];
     [_downBackgroundBtn setImage:[UIImage imageNamed:@"calendarDownBack"] forState:UIControlStateHighlighted];

    _almanacView = [[[NSBundle mainBundle]loadNibNamed:@"AlmanacView" owner:self options:nil]lastObject];
    _almanacView.frame = CGRectMake(0, 0, ScreenWidth, AlmanacViewHeight);
    _almanacView.backgroundColor = [UIColor clearColor];
    [_downBackgroundBtn addSubview:_almanacView];
    [_scrView addSubview:_downBackgroundBtn];

     _scrView.contentSize = CGSizeMake(ScreenWidth,  _almanacView.frame.origin.y+_almanacView.frame.size.height);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    UIImage * nomal = [UIImage imageNamed:@"calendarTopBack"];
    _weekView.backgroundColor = [UIColor colorWithPatternImage:nomal];

        //
    if (!_isNarrow) {
        if (scrollView.contentOffset.y <= TOPBUTTONHEIGHT) {
            _weekView.backgroundColor = [UIColor clearColor];
        }
    }
    if (!_isNarrow) {
        if (scrollView.contentOffset.y >=(12.8*CALENDARBTNPADDING-1.5*TOPBUTTONHEIGHT-(CALENDARBTNPADDING+TOPBUTTONHEIGHT))) {
            [self.view bringSubviewToFront:_weekView];
            [self.view bringSubviewToFront:_navigationBackView];
//            _weekView.frame = CGRectMake(0, -(scrollView.contentOffset.y-(12.8*CALENDARBTNPADDING-1.5*TOPBUTTONHEIGHT-(CALENDARBTNPADDING+TOPBUTTONHEIGHT))), ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
            if (SystemVersion>=10.0) {
                _weekView.frame = CGRectMake(0, -(scrollView.contentOffset.y-(12.8*CALENDARBTNPADDING-1.5*TOPBUTTONHEIGHT-(CALENDARBTNPADDING+TOPBUTTONHEIGHT)))+topTabbrHeight, ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
            }else{
                _weekView.frame = CGRectMake(0, -(scrollView.contentOffset.y-(12.8*CALENDARBTNPADDING-1.5*TOPBUTTONHEIGHT-(CALENDARBTNPADDING+TOPBUTTONHEIGHT))), ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
            }
        }else{
//            _weekView.frame = CGRectMake(0, 0, ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
            if (SystemVersion>=10.0) {
                _weekView.frame = CGRectMake(0, 0+topTabbrHeight, ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
            }else{
                _weekView.frame = CGRectMake(0, 0, ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
            }

        }
    }

}

/**
 *  今天按钮点击事件,回到当前日期
 */
-(void)backTodayAction
{
    if (_isNarrow) {
        [_narrowCalendarView backTodayAction];
    }else{
    _strYear = [[Datetime GetYear] intValue];
    _strMonth = [[Datetime GetMonth] intValue];
    _strDay = [[Datetime GetDay] intValue];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_calendarView markDataWithYear:_strYear month:_strMonth day:_strDay andIsSwipe:YES];
        });
    });
    }
    if (SystemVersion>=10.0) {
        _weekView.frame = CGRectMake(0, 0+topTabbrHeight, ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
    }else{
        _weekView.frame = CGRectMake(0, 0, ScreenWidth, CALENDARBTNPADDING+TOPBUTTONHEIGHT);
    }


}
#pragma mark - 返回上一级
-(void)goBackLastController{

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 时间标题点击事件
-(void)dateBtnClick{
    if (self.strYear > 2049 || self.strYear <1901) {
        return;
    }else{
    [self AddTimePickerToCalendarWatch];
    [self initDatePicker];
    [_datepicker onYinYangBtnClick:_datepicker.yinBtn];
    [_datepicker onYinYangBtnClick:_datepicker.yangBtn];
    }
}

#pragma mark - datePicker初始化
-(void)initDatePicker
{
    NSString *dateString = [NSString stringWithFormat:@"%@ UTC",_titleStr];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd zzz"];
    NSDate* date = [formatter dateFromString:dateString];
    [_datepicker initDate:date calendarType:0];
}

#pragma mark - 添加时间选择器
-(void)AddTimePickerToCalendarWatch{

    _datepicker = [[PickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _datepicker.delegate = self;
    _datepicker.pickerViewCount = PickerViewCount3;
   
    [self.view.window addSubview:_datepicker];
    [UIView animateWithDuration:0.25 animations:^{
        _datepicker.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

#pragma mark - 时间选择器的确定和返回按钮
-(void)pickerViewDelegateWithDateString:(NSString *)dateString
{

    _isFirst = 0;
    NSArray * dateArr = [dateString componentsSeparatedByString:@"-"];
    [self reMoveTimePickerToCalendarWatch];
    //针对日期选择器,阴历选择,超出2049的判断
    if ([[dateArr objectAtIndex:0] intValue]>2049 ) {
        return;
    }

    self.strYear = [[dateArr objectAtIndex:0] intValue];
    self.strMonth = [[dateArr objectAtIndex:1] intValue];
    self.strDay = [[dateArr objectAtIndex:2] intValue];
    if (_isNarrow) {
        [_narrowCalendarView markDataWithYear:_strYear month:_strMonth day:_strDay];
    }else{
    [_calendarView markDataWithYear:self.strYear month:self.strMonth day:self.strDay andIsSwipe:NO];
    }
}

#pragma mark - 移除时间选择器
-(void)reMoveTimePickerToCalendarWatch{
    [[self.view viewWithTag:1000] removeFromSuperview];
}

#pragma mark NarrowCalendarViewDelegate
-(void)reloadNarrowCalendarDataWithYear:(int)newYear month:(int)newMonth day:(int)newDay andIsSelected:(BOOL)isSelected{

    self.strDay = newDay;
    self.strMonth = newMonth;
    self.strYear = newYear;
    [_narrowCalendarArray removeAllObjects];
    NSArray *array = [Datetime GetDayDicByYear:_strYear andMonth:_strMonth andDay:_strDay andCountsDay:7];
    NSMutableArray *arrayTemp  = [NSMutableArray array];
    for (int j=0; j<7; j++) {
        int year = [array[0][j] intValue];
        int month = [array[1][j] intValue];
        int day = [array[2][j] intValue];

        NSString *monthStr = nil;
        NSString *dayStr = nil;
        NSString *dateStr = nil;

        if (month < 10) {
            monthStr = [NSString stringWithFormat:@"0%d",month];
        }else{
            monthStr = [NSString stringWithFormat:@"%d",month];
        }
        if (day<10){
                dayStr = [NSString stringWithFormat:@"0%d",day];
        }else {
            dayStr = [NSString stringWithFormat:@"%d",day];
        }

        dateStr = [NSString stringWithFormat:@"%d%@%@",year,monthStr,dayStr];

        [arrayTemp addObject:dateStr];
    }
    if (arrayTemp.count > 0) {

    FMResultSet * setDb = [_db executeQuery:[NSString stringWithFormat:@"select * from calendar where id between '%@' and '%@'",arrayTemp[0],[arrayTemp lastObject]]];
    while ([setDb next]) {
        calendarDBModel * model = [[calendarDBModel alloc] init];
        model.ID = [setDb stringForColumn:@"id"];
        model.lid = [setDb stringForColumn:@"lid"];
        model.week = [setDb stringForColumn:@"week"];
        //            NSLog(@"model.week:%@",model.week);
        model.weekName = [setDb stringForColumn:@"weekName"];
        model.lYear = [setDb stringForColumn:@"lYear"];
        model.lMonth = [setDb stringForColumn:@"lMonth"];
        model.lDay = [setDb stringForColumn:@"lDay"];
        model.lYearName = [setDb stringForColumn:@"lYearName"];
        model.lMonthName = [setDb stringForColumn:@"lMonthName"];
        model.lDayName = [setDb stringForColumn:@"lDayName"];
        model.yearZhu = [setDb stringForColumn:@"yearZhu"];
        model.monthZhu = [setDb stringForColumn:@"monthZhu"];
        model.dayZhu = [setDb stringForColumn:@"dayZhu"];
        model.wxYear = [setDb stringForColumn:@"wxYear"];
        model.wxMonth = [setDb stringForColumn:@"wxMonth"];
        model.wxDay = [setDb stringForColumn:@"wxDay"];
        model.jieQi = [setDb stringForColumn:@"jieQi"];
        model.jieQiTime = [setDb stringForColumn:@"jieQiTime"];
        model.dayShierJianXing = [setDb stringForColumn:@"dayShierJianXing"];
        model.dayErShiBaXingSu = [setDb stringForColumn:@"dayErShiBaXingSu"];
        model.dayAnimal = [setDb stringForColumn:@"dayAnimal"];
        model.chongAnimal = [setDb stringForColumn:@"chongAnimal"];
        model.gongLiJieRi = [setDb stringForColumn:@"gongLiJieRi"];
        model.nongLIjieRi = [setDb stringForColumn:@"nongLiJieRi"];
        model.gd= [setDb stringForColumn:@"gd"];
        model.bd = [setDb stringForColumn:@"bd"];
        model.pssd = [setDb stringForColumn:@"pssd"];
        model.jixiong = [setDb stringForColumn:@"jixiong"];
        [_narrowCalendarArray addObject:model];
    }
    }

     calendarDBModel * model;
     ZangLiModel * zangliModel;
    for (int i=0; i<_narrowCalendarArray.count; i++) {
        model = _narrowCalendarArray[i];
        if ( [model.week isEqualToString:[NSString stringWithFormat:@"%d",[Datetime GetTheWeekOfDayByYera:newYear andByMonth:newMonth andByDay:newDay]]]) {
            break;
        }
    }
    /* 刷新titleButton*/
    if (self.strYear>=2050) {
        [_titlebutton setTitle:[NSString stringWithFormat:@"%d年%d月", 2049,12] forState:UIControlStateNormal];
        _titleStr = [NSString stringWithFormat:@"%d-%d-%d", 2049,12,31];
    }else if (self.strYear<=1900){
        [_titlebutton setTitle:[NSString stringWithFormat:@"%d年%d月", 1901,1] forState:UIControlStateNormal];
        _titleStr = [NSString stringWithFormat:@"%d-%d-%d", 1901,01,01];
    }else{
    [_titlebutton setTitle:[NSString stringWithFormat:@"%d年%d月", self.strYear,self.strMonth] forState:UIControlStateNormal];
    _titleStr = [NSString stringWithFormat:@"%d-%d-%d", self.strYear,self.strMonth,self.strDay];
    }
    if (_narrowCalendarArray.count == 7) {
        
    _narrowCalendarView.narrowCalendarArray = _narrowCalendarArray;


    NSString * zangliSql;
    if (self.strMonth < 10) {
        if (self.strDay < 10) {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d0%d0%d",_strYear,_strMonth,_strDay];
        }else {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d0%d%d",_strYear,_strMonth,_strDay];
        }
    }else {
        if (_strDay < 10) {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d%d0%d",_strYear,_strMonth,_strDay];
        }else {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d%d%d",_strYear,_strMonth,_strDay];
        }
    }

    FMResultSet * zangLi = [_zangLiDb executeQuery:zangliSql];
    while ([zangLi next]) {
        zangliModel = [[ZangLiModel alloc] init];
        zangliModel._id = [zangLi stringForColumn:@"id"];
        zangliModel.zm = [[[zangLi stringForColumn:@"zm"] componentsSeparatedByString:@" "] firstObject];
        zangliModel.zd = [[[zangLi stringForColumn:@"zd"] componentsSeparatedByString:@" "] firstObject];
        zangliModel.zid = [zangLi stringForColumn:@"zid"];
        zangliModel.zyn = [zangLi stringForColumn:@"zyn"];
        zangliModel.zmn = [zangLi stringForColumn:@"zmn"];
        zangliModel.h = [zangLi stringForColumn:@"h"];
        zangliModel.pssd = [zangLi stringForColumn:@"pssd"];
    }
    if (isSelected) {

        /**
         *  @param gdb 宜
         */
        FMResultSet * gdb = [_db executeQuery:[NSString stringWithFormat:@"select * from yi where id=%d",[model.gd intValue]]];

        while ([gdb next]) {
            NSString * yi = [gdb stringForColumn:@"value"];
          CGFloat width = [Help getWidthWithContent:yi height:35 font:14 fontName:CALENDARFONTKAITI];
          int row = width/(ScreenWidth - 160)+1;
            if (row%2 == 0) {
                row = row/2;
            }else{
                 row = row/2+1;
            }
        _arrayYi = [Help getArrayWithContent:yi andCount:row andIsNarrow:NO];
            labelIndexYi = 0;
        _almanacView.YiLabel.text = _arrayYi[0];
        _almanacView.YiLabel.numberOfLines = 0;
            if (_arrayYi.count > 1) {
                _almanacView.YiImageView.hidden = NO;
            }else{
                _almanacView.YiImageView.hidden = YES;
            }
        }
        
        /**
         *  忌
         */
        FMResultSet * bdb = [_db executeQuery:[NSString stringWithFormat:@"select * from ji where id='%@'",model.bd]];
        
        while ([bdb next]) {
            NSString * ji = [bdb stringForColumn:@"value"];
            CGFloat width1 = [Help getWidthWithContent:ji height:35 font:14 fontName:CALENDARFONTKAITI];
            int row = width1/(ScreenWidth - 160)+1;
            if (row%2 == 0) {
                row = row/2;
            }else{
                row = row/2+1;
            }
            _arrayJi = [Help getArrayWithContent:ji andCount:row andIsNarrow:NO];

            labelIndexJi = 0;
            _almanacView.JiLabel.text = _arrayJi[0];
            _almanacView.JiLabel.numberOfLines = 0;
            if (_arrayJi.count > 1) {
                _almanacView.JiImageView.hidden = NO;
            }else{
                _almanacView.JiImageView.hidden = YES;
            }
             [self addTap];
        }

        /**
         *  刷新宜忌上边的节日和节气数据
         */
        [_almanacView reloadDataOfYiJiView:model andZangLiModel:zangliModel year:_strYear month:_strMonth day:_strDay];

    }
    }
}

#pragma mark - 刷新数据
-(void)reloadDataWithYear:(int)newYear month:(int)newMonth day:(int)newDay andIsSelected:(BOOL)isSelected andIsSwipe:(BOOL)isSwipe
{
    self.strDay = newDay;
    self.strMonth = newMonth;
    self.strYear = newYear;
    
    NSString * starDate;
    NSString * endDate;
    int day=0;
    [_calendarArray removeAllObjects];

    for (int i=0; i<3; i++) {

        NSMutableArray *array = [NSMutableArray array];
        int  year=0;
        int  month=0;
        if (i==0) {
            if (_strMonth != 1) {
                year = _strYear;
                month = _strMonth-1;
            }else{
                year = _strYear-1;
                month = 12;
            }
            day = [Datetime GetNumberOfDayByYera:year andByMonth:month];//天数
            if ([Datetime GetTheWeekOfDayByYera:_strYear andByMonth:_strMonth] == 0) {
                day=1;
            }

                if (month < 10) {//eg:现实数据是2016-4-13,数据库中日期键会是2016-04-13
                starDate = [NSString stringWithFormat:@"%d0%d%d",year,month,1+day-[Datetime GetTheWeekOfDayByYera:_strYear andByMonth:_strMonth]];
                endDate = [NSString stringWithFormat:@"%d0%d%d",year,month,day];
            }else if(month >=10){
                starDate = [NSString stringWithFormat:@"%d%d%d",year,month,1+day-[Datetime GetTheWeekOfDayByYera:_strYear andByMonth:_strMonth]];
                endDate = [NSString stringWithFormat:@"%d%d%d",year,month,day];
            }

        }else if (i==1) {

            year = _strYear;
            month = _strMonth;
            day = [Datetime GetNumberOfDayByYera:_strYear andByMonth:_strMonth];//天数
                if (month < 10){//eg:现实数据是2016-4-13,数据库中日期键会是2016-04-13
                starDate = [NSString stringWithFormat:@"%d0%d0%d",year,month,1];
                endDate = [NSString stringWithFormat:@"%d0%d%d",year,month,day];
            }else if(month >=10){
                starDate = [NSString stringWithFormat:@"%d%d0%d",year,month,1];
                endDate = [NSString stringWithFormat:@"%d%d%d",year,month,day];
            }
        }else if (i==2) {
            if (_strMonth != 12) {
                year = _strYear;
                month = _strMonth+1;
            }else{
                year = _strYear+1;
                month = 1;
            }
            day = [Datetime GetNumberOfDayByYera:_strYear andByMonth:_strMonth];//天数
            if ([Datetime GetTheWeekOfDayByYera:year andByMonth:month] == 0) {
                day=42;
            }

            if (month < 10) {//eg:现实数据是2016-4-13,数据库中日期键会是2016-04-13
                starDate = [NSString stringWithFormat:@"%d0%d0%d",year,month,1];
                if (42-day-1>=10) {
                    endDate = [NSString stringWithFormat:@"%d0%d%d",year,month,42-day];
                }
                else{
                    endDate = [NSString stringWithFormat:@"%d0%d0%d",year,month,42-day];
                }
            }else if(month >=10){
                starDate = [NSString stringWithFormat:@"%d%d0%d",year,month,1];
                if (42-day-1>=10) {
                    endDate = [NSString stringWithFormat:@"%d%d%d",year,month,42-day];
                }
                else{
                    endDate = [NSString stringWithFormat:@"%d%d0%d",year,month,42-day];
                }

            }
        }

        /**
         *  数据库 calendar 中查看每个键的信息
         */
        NSLog(@"starDate%@,endDate%@",starDate,endDate);
        FMResultSet * setDb = [_db executeQuery:[NSString stringWithFormat:@"select * from calendar where id between '%@' and '%@'",starDate,endDate]];
        while ([setDb next]) {
            calendarDBModel * model = [[calendarDBModel alloc] init];
            model.ID = [setDb stringForColumn:@"id"];
            model.lid = [setDb stringForColumn:@"lid"];
            model.week = [setDb stringForColumn:@"week"];
            model.weekName = [setDb stringForColumn:@"weekName"];
            model.lYear = [setDb stringForColumn:@"lYear"];
            model.lMonth = [setDb stringForColumn:@"lMonth"];
            model.lDay = [setDb stringForColumn:@"lDay"];
            model.lYearName = [setDb stringForColumn:@"lYearName"];
            model.lMonthName = [setDb stringForColumn:@"lMonthName"];
            model.lDayName = [setDb stringForColumn:@"lDayName"];
            model.yearZhu = [setDb stringForColumn:@"yearZhu"];
            model.monthZhu = [setDb stringForColumn:@"monthZhu"];
            model.dayZhu = [setDb stringForColumn:@"dayZhu"];
            model.wxYear = [setDb stringForColumn:@"wxYear"];
            model.wxMonth = [setDb stringForColumn:@"wxMonth"];
            model.wxDay = [setDb stringForColumn:@"wxDay"];
            model.jieQi = [setDb stringForColumn:@"jieQi"];
            model.jieQiTime = [setDb stringForColumn:@"jieQiTime"];
            model.dayShierJianXing = [setDb stringForColumn:@"dayShierJianXing"];
            model.dayErShiBaXingSu = [setDb stringForColumn:@"dayErShiBaXingSu"];
            model.dayAnimal = [setDb stringForColumn:@"dayAnimal"];
            model.chongAnimal = [setDb stringForColumn:@"chongAnimal"];
            model.gongLiJieRi = [setDb stringForColumn:@"gongLiJieRi"];
            model.nongLIjieRi = [setDb stringForColumn:@"nongLiJieRi"];
            model.gd= [setDb stringForColumn:@"gd"];
            model.bd = [setDb stringForColumn:@"bd"];
            model.pssd = [setDb stringForColumn:@"pssd"];
            model.jixiong = [setDb stringForColumn:@"jixiong"];
            [array addObject:model];
        }
        [_calendarArray addObject:array];
    }
    calendarDBModel * model;
    ZangLiModel * zangliModel;
    //防止数组越界,下面的星期用datetime 算
    if (_calendarArray.count>0) {
    if (isSelected) {
         model  = _calendarArray[1][newDay- 1];
    }
    _calendarView.calendarArray = _calendarArray;
    NSString * zangliSql;
    if (self.strMonth < 10) {
        if (self.strDay < 10) {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d0%d0%d",_strYear,_strMonth,_strDay];
        }else {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d0%d%d",_strYear,_strMonth,_strDay];
        }
    }else {
        if (_strDay < 10) {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d%d0%d",_strYear,_strMonth,_strDay];
        }else {
            zangliSql = [NSString stringWithFormat:@"select * from zangli where id=%d%d%d",_strYear,_strMonth,_strDay];
        }
    }
    FMResultSet * zangLi = [_zangLiDb executeQuery:zangliSql];
    while ([zangLi next]) {
        zangliModel = [[ZangLiModel alloc] init];
        zangliModel._id = [zangLi stringForColumn:@"id"];
        zangliModel.zm = [[[zangLi stringForColumn:@"zm"] componentsSeparatedByString:@" "] firstObject];
        zangliModel.zd = [[[zangLi stringForColumn:@"zd"] componentsSeparatedByString:@" "] firstObject];
        zangliModel.zid = [zangLi stringForColumn:@"zid"];
        zangliModel.zyn = [zangLi stringForColumn:@"zyn"];
        zangliModel.zmn = [zangLi stringForColumn:@"zmn"];
        zangliModel.h = [zangLi stringForColumn:@"h"];
        zangliModel.pssd = [zangLi stringForColumn:@"pssd"];
    }

#pragma mark 条件很复杂,选中,且是缩略,才更新数据
    if (isSelected) {
        /**
         *  @param gdb 宜
         */
        FMResultSet * gdb = [_db executeQuery:[NSString stringWithFormat:@"select * from yi where id=%d",[model.gd intValue]]];

        while ([gdb next]) {
            NSString * yi = [gdb stringForColumn:@"value"];
            CGFloat width = [Help getWidthWithContent:yi height:35 font:14 fontName:CALENDARFONTKAITI];
            int row = width/(ScreenWidth - 160)+1;
            if (row%2 == 0) {
                row = row/2;
            }else{
                row = row/2+1;
            }
            _arrayYi = [Help getArrayWithContent:yi andCount:row andIsNarrow:NO];

            labelIndexYi = 0;
            _almanacView.YiLabel.text = _arrayYi[0];
            _almanacView.YiLabel.numberOfLines = 0;
            if (_arrayYi.count > 1) {
                _almanacView.YiImageView.hidden = NO;
            }else{
                _almanacView.YiImageView.hidden = YES;
            }
        }

        /**
         *  忌
         */
        FMResultSet * bdb = [_db executeQuery:[NSString stringWithFormat:@"select * from ji where id='%@'",model.bd]];

        while ([bdb next]) {
            NSString * ji = [bdb stringForColumn:@"value"];
            CGFloat width1 = [Help getWidthWithContent:ji height:35 font:14 fontName:CALENDARFONTKAITI];
            int row = width1/(ScreenWidth - 160)+1;
            if (row%2 == 0) {
                row = row/2;
            }else{
                row = row/2+1;
            }
            _arrayJi = [Help getArrayWithContent:ji andCount:row andIsNarrow:NO];

             labelIndexJi = 0;
            _almanacView.JiLabel.text = _arrayJi[0];
            _almanacView.JiLabel.numberOfLines = 0;
            if (_arrayJi.count > 1) {
                _almanacView.JiImageView.hidden = NO;
            }else{
                _almanacView.JiImageView.hidden = YES;
            }
        }
        [self addTap];



    /**
     *  刷新宜忌上边的节日和节气数据
     */
    [_almanacView reloadDataOfYiJiView:model andZangLiModel:zangliModel year:_strYear month:_strMonth day:_strDay];
    if (_isFirst>1 && _isNarrow == NO && !isSwipe) {
        _isNarrow = YES;
         [self tap];

    }else{
    _isFirst++;
    _scrView.contentSize = CGSizeMake(ScreenWidth, _downBackgroundBtn.frame.origin.y + _downBackgroundBtn.frame.size.height);
    }
    }
}
    /* 刷新titleButton*/
    if (self.strYear>=2050) {
        [_titlebutton setTitle:[NSString stringWithFormat:@"%d年%d月", 2049,12] forState:UIControlStateNormal];
        _titleStr = [NSString stringWithFormat:@"%d-%d-%d", 2049,12,31];
    }else if (self.strYear<=1900){
        [_titlebutton setTitle:[NSString stringWithFormat:@"%d年%d月", 1901,1] forState:UIControlStateNormal];
        _titleStr = [NSString stringWithFormat:@"%d-%d-%d", 1901,01,01];
    }else{
    /* 刷新titleButton*/
    [_titlebutton setTitle:[NSString stringWithFormat:@"%d年%d月", self.strYear,self.strMonth] forState:UIControlStateNormal];
    _titleStr = [NSString stringWithFormat:@"%d-%d-%d", self.strYear,self.strMonth,self.strDay];
    }
}


-(void)addTap{
    UITapGestureRecognizer *tapYi = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapYi)];
    _almanacView.YiImageView.image = [UIImage imageNamed:@"next_white"];
     _almanacView.YiImageView.userInteractionEnabled = YES;
    [_almanacView.YiImageView addGestureRecognizer:tapYi];


    UITapGestureRecognizer *tapJi = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapJi)];
    _almanacView.JiImageView.image = [UIImage imageNamed:@"next_white"];
     _almanacView.JiImageView.userInteractionEnabled = YES;
    [_almanacView.JiImageView addGestureRecognizer:tapJi];
    isPre = YES;
}

-(void)tapYi{

    if (_arrayYi.count > 1) {
        if (labelIndexYi == _arrayYi.count-1) {
            labelIndexYi--;
            _almanacView.YiImageView.image = [UIImage imageNamed:@"pre_white"];
            isPre = YES;
            if (labelIndexYi == 0 && isPre==YES) {
                _almanacView.YiImageView.image = [UIImage imageNamed:@"next_white"];
                isPre = NO;
            }

        }else if (labelIndexYi == 0) {
            labelIndexYi++;
            _almanacView.YiImageView.image = [UIImage imageNamed:@"next_white"];
            isPre = NO;
            if (labelIndexYi == _arrayYi.count-1 && isPre==NO) {
                _almanacView.YiImageView.image = [UIImage imageNamed:@"pre_white"];
                isPre = YES;
            }
        }else if (isPre) {
            _almanacView.YiImageView.image = [UIImage imageNamed:@"pre_white"];
            labelIndexYi--;
            if (labelIndexYi == 0 && isPre==YES) {
                _almanacView.YiImageView.image = [UIImage imageNamed:@"next_white"];
                isPre = NO;
            }

        }else{
            _almanacView.YiImageView.image = [UIImage imageNamed:@"next_white"];
             labelIndexYi++;
            if (labelIndexYi == _arrayYi.count-1 && isPre==NO) {
                _almanacView.YiImageView.image = [UIImage imageNamed:@"pre_white"];
                isPre = YES;
            }
        }


    NSString *newText = [_arrayYi objectAtIndex:labelIndexYi];
    newText = [newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    [UIView animateWithDuration:1.0 animations:^{
        _almanacView.YiLabel.text = newText;
    }];
    }
}

-(void)tapJi{
    if (_arrayJi.count > 1) {
        if (labelIndexJi == _arrayJi.count-1 ) {
            labelIndexJi--;
            _almanacView.JiImageView.image = [UIImage imageNamed:@"pre_white"];
            isPre = YES;
            if (labelIndexJi == 0 && isPre==YES) {
                _almanacView.JiImageView.image = [UIImage imageNamed:@"next_white"];
                isPre = NO;
            }
        }else  if (labelIndexJi == 0 ) {
            labelIndexJi++;
            _almanacView.JiImageView.image = [UIImage imageNamed:@"next_white"];
            isPre = NO;

            if (labelIndexJi == _arrayJi.count-1 && isPre==NO) {
                _almanacView.JiImageView.image = [UIImage imageNamed:@"pre_white"];
                isPre = YES;
            }
        }else if (isPre) {
            _almanacView.JiImageView.image = [UIImage imageNamed:@"pre_white"];
            labelIndexJi--;
            if (labelIndexJi == 0 && isPre==YES) {
                _almanacView.JiImageView.image = [UIImage imageNamed:@"next_white"];
                isPre = NO;
            }
        }else{
            _almanacView.JiImageView.image = [UIImage imageNamed:@"next_white"];
            labelIndexJi++;
            if (labelIndexJi == _arrayJi.count-1 && isPre==NO) {
                _almanacView.JiImageView.image = [UIImage imageNamed:@"pre_white"];
                isPre = YES;
            }
        }
    NSString *newText = [_arrayJi objectAtIndex:labelIndexJi];
    [UIView animateWithDuration:1.0 animations:^{
        _almanacView.JiLabel.text = newText;
    }];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self reMoveTimePickerToCalendarWatch];
}

-(void)dealloc
{
    _calendarView.delegate = nil;
    _narrowCalendarView.delegate = nil;
    [_db close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

