//
//  RootViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/12.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "RootViewController.h"
#import "Utils.h"
#pragma wq 1 del
//#import "ToolVC.h"
#import "DBModel.h"
#import "Image_Model.h"
#import "AppDelegate.h"
#import "WallpaperVC.h"
#import "SqlDataBase.h"
#import "RefreshView.h"
#import "AppDelegate.h"
#import "WeatherModel.h"
#import "CalendarModel.h"
#import "WeekCollectionCell.h"
#import "LocationController.h"
#import "WeatherTableViewCell.h"
#import "CalendarTableViewCell.h"
#import "WallpaperTableViewCell.h"
#import "CalendarMainPagesModel.h"
#import <CoreLocation/CoreLocation.h>
#import "WeatherCollectionViewCell.h"
#import "NarrowWeatherTableViewCell.h"
#import "NarrowCalendarTableViewCell.h"
#import "CityTitleCollectionViewCell.h"
#define SH [UIScreen mainScreen].bounds.size.height
#define SW [UIScreen mainScreen].bounds.size.width

#define RefreshDelayInterval 0.0
//自动滚动方向
typedef enum {
   AutoScrollUp,
   AutoScrollDown
}  AutoScroll;

#define moduleNumber 3 // 模块数量

@interface RootViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate, UIScrollViewDelegate ,CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource,RefreshViewDelegate,CalendarTableViewCellDelegate,NSXMLParserDelegate>
{
    NSString     * weatherKey;
    NSString     * calendarKey;
    NSString     * wallpaperkey;
    FMDatabase   * _db;
    FMDatabase   * _zangLiDb;
    NSInteger     asnMark;


}
@property (nonatomic, strong) CLGeocoder                * geocoder;
@property (retain)            CLLocationManager         * locationManager;
@property (nonatomic, strong) UITableView               * table;
@property (strong, nonatomic) NSMutableArray            * weatherArray;              // 天气数据
@property (strong, nonatomic) NSMutableDictionary       * dictionary;                //cell 的一些信息
@property (strong, nonatomic) NSMutableArray            * cellNameArray;             // 模块顺序
@property (strong, nonatomic) UIImageView               * navigationImageView;
@property (strong, nonatomic) UIImageView               * headBackImageView;
@property (nonatomic, strong) CADisplayLink             * displayLink;

/**
 *  press 变量记录,是否点按开始,点按开始,刷新tabview 数据,以模块方式进行展示
 */
@property (nonatomic, assign) BOOL                        press;
@property (nonatomic, assign) BOOL                        isBegan;
@property (nonatomic, assign) AutoScroll                  autoScroll;
@property (nonatomic, strong) UIImageView               * cellImageView;
@property (nonatomic, strong) UIView                    * leftView;
@property (nonatomic, strong) UIView                    * mainView;
#pragma wq 1 delete
//@property (nonatomic, strong) ToolVC                    * leftViewController;
@property (nonatomic, strong) UIView                    * navigationBackView;       // 渐变导航栏背景view
@property (nonatomic, strong) UIButton                  * leftButton;               // 左侧抽屉按钮
@property (nonatomic, strong) UIButton                  * rightButton;              // 右侧分享按钮
@property (nonatomic, strong) UICollectionView          * titleCollectionView;      //导航栏上面滚动城市
@property (nonatomic, strong) NSMutableArray            * wallpaperArray_big;       // 壁纸大图数组
@property (nonatomic, strong) NSMutableArray            * wallpaperArray_little;    // 壁纸缩略图数组
@property (nonatomic, assign) int                         pages;                     // 数据库中是从0加载还是从1加载

@property (nonatomic, strong) NSMutableArray            * calendarArray;            //日历数组
@property (nonatomic, strong) CalendarMainPagesModel    * calemdarMainPagesModel;
@property (nonatomic, strong) CalendarModel             * calendarModel;
@property (nonatomic, strong) CacheDataManager          * cacheDataManager;
//刷新视图
@property (nonatomic, strong) RefreshView               * refreshView;
@property (nonatomic, strong)UILabel                    * titleLibel;
@property (nonatomic, strong) NSMutableArray            * suntimeArray;
@property (nonatomic, assign) NSInteger                   aqi;                  // 空气质量

@end

@implementation RootViewController
{
   NSMutableArray * _calendarModelArray;
   NSMutableArray * _calendarZangliArray;
   BOOL             _isRefresh;//是不是下拉刷新,刷新 tableView 的
}

static NSIndexPath  * fromIndexPath   = nil;   // 点按cell
static NSIndexPath  * sourceIndexPath = nil;   // 目标cell
- (instancetype)init{
   self = [super init];
   if (self) {
      self.cityArray             = [NSMutableArray array];
      self.userCityArray         = [NSMutableArray array];
      self.locationCityModel     = [[DBModel alloc]init];
      self.nowCityModel          = [[DBModel alloc]init];
      self.wallpaperArray_big    = [NSMutableArray array];
      self.wallpaperArray_little = [NSMutableArray array];
      self.weatherArray          = [NSMutableArray array];
      self.cellNameArray         = [NSMutableArray array];
      self.calendarArray         = [NSMutableArray array];
      self.suntimeArray          = [NSMutableArray array];
      _calendarModelArray        = [NSMutableArray array];
      _calendarZangliArray       = [NSMutableArray array];
      weatherKey                 = @"天气";
      calendarKey                = @"日历";
      wallpaperkey               = @"壁纸";
      _isRefresh                 = NO;
      // 通知,当天气模块为缩略状态下,点击城市切换下一个城市,当为最后一个城市时,循环到第一个城市
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRootCityNotification) name:@"ChangeRootCityNotification" object:nil];
   }
   return self;
}

- (void)setLocationCityModel:(DBModel *)locationCityModel{
   if (_locationCityModel != locationCityModel) {
      _locationCityModel = locationCityModel;
      if (_locationCityModel.cityCC && self.cityArray.count == 0) {
         // 请求天气数据(不包括壁纸)
         [self jiazai];
      }
   }
}

- (void)saveUserDefaults:(NSMutableArray *)array ToKey:(NSString *)key{
   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   [userDefaults setObject:array forKey:key];
}
- (NSMutableArray *)readUserDefaultsWithKey:(NSString *)key{
   NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
   NSMutableArray *array = [ NSMutableArray arrayWithArray:[userDefaultes arrayForKey:key]];
   return array;
}
- (void)saveUserDefaults{
   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   [userDefaults setObject:self.userCityArray forKey:@"userCityArray"];
}
- (void)readUserDefaults{
   NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
   self.userCityArray = [ NSMutableArray arrayWithArray:[userDefaultes arrayForKey:@"userCityArray"]];
}
- (void)saveTimeUserDefaultsWithCityModel:(DBModel *)cityModel Aqi:(NSInteger)aqi{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * l = cityModel.qwz;
    if (!l) {
        return;
    }
    NSMutableDictionary * dictionary = [[userDefaultes dictionaryForKey:l]mutableCopy];
    if (!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
    }
    [dictionary setObject:[NSString stringWithFormat:@"%ld", (long)aqi] forKey:@"aqi"];
    NSDate * nowDate = [NSDate date];
    [dictionary setObject:nowDate forKey:@"date"];
    [userDefaultes setObject:dictionary forKey:l];
}
- (BOOL)readTimeUserDefaulesWithCityModel:(DBModel *)cityModel{
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * l = cityModel.qwz;
    if (!l) {
        return NO;
    }
    NSDictionary * dictionary = [userDefaultes dictionaryForKey:l];
    if (dictionary.allKeys.count == 0) {
        // 开始刷新
        return NO;
    }
    NSDate * lastDate = [dictionary objectForKey:@"date"];
    NSDate * nowDate = [NSDate date];
    if ([nowDate compare:[lastDate dateByAddingTimeInterval:(5*60)]] == NSOrderedDescending) {
        // 开始刷新
        return NO;
    }
    else{
        // 读取本地
        self.aqi = [[dictionary objectForKey:@"aqi"] integerValue];
        return YES;
    }
}
- (NSMutableDictionary *)dictionary{
   if (!_dictionary) {
      _dictionary = [@{
                       weatherKey:@{@"header_height":@ModuleWeatherHeight,
                                    @"narrow_height":@ModuleNarrowWeatherHeight,
                                    @"header_class":@"WeatherTableViewCell",
                                    @"header_identifier":@"WEATHERTABLEVIEWCELL",
                                    @"narrow_class":@"NarrowWeatherTableViewCell",
                                    @"narrow_identifier":@"NARROWWEATHERTABLEVIEWCELL"
                                    },
                       
                       calendarKey:@{@"header_height":@ModuleCalendarHeight,
                                     @"narrow_height":@ModuleNarrowCalendarHeight,
                                     @"header_class":@"CalendarTableViewCell",
                                     @"header_identifier":@"CALENDARTABLEVIEWCELL",
                                     @"narrow_class":@"NarrowCalendarTableViewCell",
                                     @"narrow_identifier":@"NARROWCALENDARTABLEVIEWCELL"
                                     },
                       wallpaperkey:@{@"header_height":@ModuleWallpaperHeight,
                                      @"narrow_height":@ModuleNarrowWallpaperHeight,
                                      @"header_class":@"WallpaperTableViewCell",
                                      @"header_identifier":@"WALLPAPERTABLEVIEWCELL",
                                      @"narrow_class":@"NarrowWallpaperTableViewCell",
                                      @"narrow_identifier":@"NARROWWALLPAPERTABLEVIEWCELL"
                                      
                                      }} mutableCopy];
   }
   return _dictionary;
}
#pragma mark 视图初始化
- (void)initLeftView{
   self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LeftWidth, self.view.frame.size.height)];
   [self.view addSubview:self.leftView];
   self.leftView.backgroundColor = [UIColor whiteColor];
   
   self.leftViewController = [[ToolVC alloc]init];
   [self.leftView addSubview:self.leftViewController.view];
   _leftViewController.view.frame = _leftView.frame;
   _leftViewController.delegate = self;
}

- (void)initMainView{
   self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
   [self.view addSubview:self.mainView];
   self.mainView.backgroundColor = [UIColor whiteColor];
}
- (void)creatTable{
   
   self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
   _table.showsHorizontalScrollIndicator = NO;
   _table.showsVerticalScrollIndicator = NO;
   _table.separatorStyle = UITableViewCellSeparatorStyleNone;
   UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
   [_table addGestureRecognizer:longPress];
   [self.mainView addSubview:self.table];
   self.table.delegate = self;
   self.table.dataSource = self;
   
   self.navigationBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
   [self.mainView addSubview:self.navigationBackView];
   self.navigationBackView.backgroundColor = [UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:navigationBackViewAlpha];
   self.navigationBackView.alpha = navigationBackViewAlpha;
   
}
#pragma mark - 抽屉效果
// 返回根视图
- (void)goToRootViewController:(UIButton *)sender{
   if (sender.selected) {
      self.mainView.userInteractionEnabled = YES;
      [self setmainViewX:0];
   } else {
      // 每次显示抽屉效果,就计算一下图片缓存数
      [self.leftViewController folderSizeAtPath];
      self.mainView.userInteractionEnabled = NO;
      [self setmainViewX:LeftWidth];
   }
   sender.selected = !sender.selected;
   
}
// 左划返回根视图
- (void)swipeGesture:(UISwipeGestureRecognizer *)swipeGesture{
   if (self.leftButton.selected) {
      self.mainView.userInteractionEnabled = YES;
      [self setmainViewX:0];
      self.leftButton.selected = !self.leftButton.selected;
   }
}
//设置最大侧滑
- (void)setmainViewX:(CGFloat)endX{
   
   CGRect frame = self.mainView.frame;
   frame.origin.x = endX;
   
   CGRect naviFrame = self.navigationController.navigationBar.frame;
   naviFrame.origin.x = endX;
   
   [UIView animateWithDuration:0.2 animations:^{
      self.mainView.frame = frame;
      self.navigationController.navigationBar.frame = naviFrame;
   }];
   
}
- (void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
   CGRect frame = self.mainView.frame;
   frame.origin.x = 0;
   self.mainView.frame=frame;
   CGRect naviFrame = self.navigationController.navigationBar.frame;
   naviFrame.origin.x = 0;
   self.navigationController.navigationBar.frame = naviFrame;
   ////去掉背景图片,去掉底部线条
   self.navigationImageView.hidden = YES;
   
   // 防止在tool界面直接跳转到第三个界面后,返回root,点击抽屉按钮,按钮迟钝
   self.leftButton.selected = NO;
   self.mainView.userInteractionEnabled = YES;
   
   [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated{
   [super viewWillDisappear:animated];
   [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

   CGRect naviFrame = self.navigationController.navigationBar.frame;
   naviFrame.origin.x = 0;
   self.navigationController.navigationBar.frame = naviFrame;
}
- (void)viewDidLoad {
   [super viewDidLoad];
    _type = 0;
   self.cellNameArray = [self readUserDefaultsWithKey:@"moduleNameArray"];
   if (self.cellNameArray.count == 0) {
      NSMutableArray * array = [@[weatherKey,calendarKey,wallpaperkey] mutableCopy];
      [self saveUserDefaults:array ToKey:@"moduleNameArray"];
      self.cellNameArray = array;
   }
   
   //添加轻扫手势,左划返回
   UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
   //设置轻扫的方向
   swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
   [self.view addGestureRecognizer:swipeGesture];

   [self initLeftView];
   [self initMainView];

   [self handleData];
   [self creatTable];
   [self creatRefreshHeadView];
   [self setNavigationIteam];
}

#pragma mark 创建刷新试图
- (void)creatRefreshHeadView{
   //创建下拉刷新 View
   if (!_refreshView) {
      RefreshView *view = [[RefreshView alloc] initWithFrame:CGRectMake(0, -300, self.view.frame.size.width, 300)];
      
      _refreshView = view;
      _refreshView.delegate = self;
      [_table addSubview:_refreshView];
   }
   [_refreshView refreshLastUpdatedDate];
}

//- (void)reloadWeatherCell{
//    NSString * cellName = [self.cellNameArray objectAtIndex:0];
//    if ([cellName isEqualToString:weatherKey]) {
//
//        [self.table reloadData];
//    }
//}

#pragma mark - 加载数据
- (void)jiazai{
   // 城市数据
    self.type = 0;
   [self handleCityData];
   
    BOOL isHostReach  = [ReachManager isReachable];
   _cacheDataManager = [[CacheDataManager alloc]initFile];
   
   NSLog(@"isHostReach:%d",isHostReach);

   if (isHostReach == 1) {
      // 请求天气数据
       [self handleWeatherAndSunTimes];
   }

}
- (void)handleData{
    // 城市数据
    [self handleCityData];
    // 藏历数据
    [self handleCaldsfData];

     BOOL isHostReach  = [ReachManager isReachable];
    _cacheDataManager = [[CacheDataManager alloc]initFile];
    NSLog(@"isHostReach:%d",isHostReach);
    self.type = 0;
    if (isHostReach == 1) {
        if (![JSNet hasRegister]) {
            [JSNet appRegisterWithFinishBlock:^(BOOL isFinishRegister) {
                NSLog(@"AppregisterSuccess");
                [self handleWeatherAndSunTimes];
                [self handleWallpaperData];
            }];
        }else{
            [self handleWeatherAndSunTimes];
            [self handleWallpaperData];
        }
    }else{
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate addRequestErrorView];
        if ([_cacheDataManager isExistCacheFile]) {
            [self reachLocalWeatherData];
            [self reachLocalWallpaperData];
        }
        //暂时保留着
        //写在这里防止出现黄历主页,闪2次的情况
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.table reloadData];
        });
    }
}

- (void)requestWallpaperList{
     BOOL isHostReach  = [ReachManager isReachable];
    if (isHostReach == 1) {
        if (![JSNet hasRegister]) {
            [JSNet appRegisterWithFinishBlock:^(BOOL isFinishRegister) {
                NSLog(@"AppregisterSuccess");
                [self handleWallpaperData];
            }];
        }else{
            [self handleWallpaperData];
        }
    }else{
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate addRequestErrorView];
        if ([_cacheDataManager isExistCacheFile]) {
            [self reachLocalWallpaperData];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.table reloadData];
        });
    }

}

/*
- (void)requestWeatherData{

}
- (void)requestCalendarData{

}
- (void)reloadCalendarCell{

}
- (void)reloadWeatherCell{

}
- (void)reloadWallpaperCell{

}
*/

//只是请求天气与城市
-(void)handleWeatherAndCityData{
    // 城市数据
    [self handleCityData];
     BOOL isHostReach  = [ReachManager isReachable];
    _cacheDataManager = [[CacheDataManager alloc]initFile];
    self.type = 0;
    if (isHostReach == 1) {
        // 请求天气数据
        [self handleWeatherAndSunTimes];
    }else{
        if ([_cacheDataManager isExistCacheFile]) {
            [self reachLocalWeatherData];
        }
    }
}

//加载本地天气数据
-(void)reachLocalWeatherData{

    NSDictionary *dic = [_cacheDataManager requestLocalWeatherData:[NSString stringWithFormat:@"%@-%@",CacheWeather,[self.nowCityModel.qwz stringByReplacingOccurrencesOfString:@"/" withString:@""]]];
    self.weatherArray = [WeatherModel analysisDataWithArray:dic];
    for (int i = 0; i < 3; i++) {
        NSString * cellName = [self.cellNameArray objectAtIndex:i];
        if ([cellName isEqualToString:weatherKey] || [cellName isEqualToString:calendarKey]) {
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:0];
            BaseTableViewCell * cell = [self.table cellForRowAtIndexPath:indexPath1];
            cell.type = self.type;
            cell.isRefresh = _isRefreshing;

//            if (i==0 && [cellName isEqualToString:weatherKey]) {
//                [self.table reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
//            }
//            else{
//                 [self.table reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationNone];
//            }
            if ([cellName isEqualToString:weatherKey]) {
                if (i==0) {
                    [self.table reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
                }else {
                     [self.table reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }

}

//加载本地壁纸
-(void)reachLocalWallpaperData{
    SqlDataBase *sqldata = [[SqlDataBase alloc]init];
     [sqldata configSelectedWallpaperListDB];
    //有网络请求的才进行列表数据缓存
    if ([sqldata achieveTableDataNum:@"WallpaperList"]>0) {
        self.wallpaperArray_big = (NSMutableArray *)[sqldata achieveTenWallper:0 andWallpaperKind:3];
        self.wallpaperArray_little =(NSMutableArray *)[sqldata achieveTenWallper:0 andWallpaperKind:1];
        self.pages = 1;
    }
}

// 藏历数据
- (void)handleCaldsfData{
   int   YearCurrent = [[Datetime GetYear] intValue];
   int countDay = [Datetime GetOneYearCountDay:YearCurrent];
   _calemdarMainPagesModel = [[CalendarMainPagesModel alloc]initWithReceiveData:countDay andYear:YearCurrent];
   _calendarArray = [_calemdarMainPagesModel readDataFromDB];
    // 刷新藏历的试图
    for (int i = 0; i < 3; i++) {
        NSString * cellName = [self.cellNameArray objectAtIndex:i];
        if ([cellName isEqualToString:calendarKey]) {
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:0];
            [self.table reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

// 请求壁纸数据
- (void)handleWallpaperData{
    // 返回的格林治时间
      NSDate *dateUtc = nil;
      NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
      if (![user objectForKey:@"RequestDataTime"]) {
         dateUtc = nil;

      }else{
         NSDate *date1 = [user objectForKey:@"RequestDataTime"];
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         //输入格式
         [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         NSString *str = [dateFormatter stringFromDate:date1];
         NSDate *dateFormatted = [dateFormatter dateFromString:str];
         NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
         [dateFormatter setTimeZone:timeZone];
         //输出格式
         [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
         dateUtc = [dateFormatter dateFromString:dateString];
         NSLog(@"dateUtc:%@",dateUtc);
      }

   // 请求壁纸大数据
   [JSNet handleWallPaperListFinishDataBlock:^(NSData *data) {
       
      SqlDataBase *sqldata = [[SqlDataBase alloc]init];
       [sqldata configDatabase];
       [sqldata configSelectedWallpaperListDB];
      NSError * error = nil;
      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

      if (!error) {
          NSArray *array = [dic objectForKey:@"d"];
          if ((NSNull *)array != [NSNull null]) {
              if (array.count!=0) {
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setObject:[NSDate date] forKey:@"RequestDataTime"];
                      //解析数据
                      NSMutableArray *arrayTemp  = [Image_Model sortOutDataWith:array];
//                      //addWallperToServerWallPaperList
//                      [sqldata addWallperToServerWallPaperList:arrayTemp];
                      //添加到数据库
                      [sqldata addWallper:arrayTemp];
              }

                    self.wallpaperArray_big = (NSMutableArray *)[sqldata achieveTenWallper:0 andWallpaperKind:3];
                    self.wallpaperArray_little =(NSMutableArray *)[sqldata achieveTenWallper:0 andWallpaperKind:1];
                    self.pages = 1;

                  for (int i = 0; i < 3; i++) {
                      NSString * cellName = [self.cellNameArray objectAtIndex:i];
                      if ([cellName isEqualToString:wallpaperkey]) {
                          NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:0];
                          [self.table reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationNone];
                          break;
                      }
                  }

          }else{

              self.wallpaperArray_big = [NSMutableArray array];
              self.wallpaperArray_little = [NSMutableArray array];
          }

      }else{

          NSLog(@"error");
          self.wallpaperArray_big = [NSMutableArray array];
          self.wallpaperArray_little = [NSMutableArray array];
      }

      }];
    Image_Model *imageModel = [[Image_Model alloc]init];
    for (int i=0; i<10; i++) {
        [self.wallpaperArray_big addObject:imageModel];
        [self.wallpaperArray_little addObject:imageModel];
    }

}

// 请求天气和日出日落数据
- (void)handleWeatherAndSunTimes{
    // 当断网情况下走本地缓存
     BOOL isHostReach  = [ReachManager isReachable];
    _cacheDataManager = [[CacheDataManager alloc]initFile];
    if ([self readTimeUserDefaulesWithCityModel:self.nowCityModel] || isHostReach == 0) {
        if ([_cacheDataManager isExistCacheFile]) {
            [self reachLocalWeatherData];
        }
    }else{
        asnMark ++ ;
        [self handleAqi];
        [self handleWeatherData];
    }
}
- (void)refreshWeather{
    asnMark ++ ;
    self.type = 0;
    [self handleAqi];
    [self handleWeatherData];
}
// 请求空气质量数据
- (void)handleAqi{
    self.aqi = 0;
    [JSNet handlAqiWithCityModel:self.nowCityModel Mark:asnMark finishAqiBlock:^(NSUInteger mark, NSInteger aqi) {
        if (asnMark == mark) {
            self.aqi = aqi;
            for (int i = 0; i < 3; i++) {
                NSString * cellName = [self.cellNameArray objectAtIndex:i];
                if ([cellName isEqualToString:weatherKey]) {
                    if (i == 0) {
                        BaseTableViewCell * baseCell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        baseCell.aqi = self.aqi;
                        if (baseCell.collectionView.visibleCells.count > 0) {
                            WeatherCollectionViewCell *wCell = (WeatherCollectionViewCell *)[baseCell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                            NSString * path =[Help getAqiImage:self.aqi];                            if (path) {
                                wCell.pollution.image = [UIImage imageWithContentsOfFile:path];
                            }else{
                                wCell.pollution.image = nil;
                            }
                            
                        }
                        
                    } else {
                        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        BaseTableViewCell * cell = [self.table cellForRowAtIndexPath:indexPath];
                        cell.type = self.type;
                        cell.isRefresh = _isRefreshing;

                        [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    }
                     [self saveTimeUserDefaultsWithCityModel:self.nowCityModel Aqi:self.aqi];
                }
            }
        }
        
    }];
}
// 请求天气数据
- (void)handleWeatherData{
   
   [JSNet handleWeatherWithCityModel:self.nowCityModel Mark:asnMark FinishBlock:^(NSData *data, NSUInteger mark) {
      
      NSError * error = nil;
      NSDictionary * finishDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
      if (!error) {
          
          NSString * dataString = [finishDic objectForKey:@"d"];
          if ((NSNull *)dataString != [NSNull null]) {

                NSData * finishData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:finishData options:NSJSONReadingMutableContainers error:nil];
                _cacheDataManager = [[CacheDataManager alloc]initFile];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    [_cacheDataManager createWeatherFileWithFileName:[NSString stringWithFormat:@"%@-%@",CacheWeather,[self.nowCityModel.qwz stringByReplacingOccurrencesOfString:@"/" withString:@""]] andData:dic];
                });
              if (asnMark == mark) {
                  // 解析数据
                  self.weatherArray = [WeatherModel analysisDataWithArray:dic];
                  NSLog(@"开始刷新");
                for (int i = 0; i < 3; i++) {
                      NSString * cellName = [self.cellNameArray objectAtIndex:i];
                      if ([cellName isEqualToString:weatherKey] || [cellName isEqualToString:calendarKey]) {
                          NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:0];
                          BaseTableViewCell * cell = [self.table cellForRowAtIndexPath:indexPath1];
                          cell.type = self.type;
                          cell.isRefresh = _isRefreshing;
//                          if (i==0 && [cellName isEqualToString:weatherKey]) {
//                              [self.table reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
//                          }
//                          else{
//                              [self.table reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationNone];
//                          }
                          if ([cellName isEqualToString:weatherKey]) {
                              if (i==0) {
                                   [self.table reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
                              }else{
                                  [self.table reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationNone];
                              }
                          }


                      }

                  }

              }
          }else{
              
              self.weatherArray = [NSMutableArray array];
          }

      }else{
          
         NSLog(@"请求失败");
          self.weatherArray = [NSMutableArray array];
      }
   }];
}
- (void)handleCityData{
   
        [self readUserDefaults];
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        SqlDataBase *sqldata = [[SqlDataBase alloc]init];
        [sqldata configDatabase];
       NSArray * arr = [sqldata searchAllSaveCity];
       BOOL isHostReach  = [ReachManager isReachable];
       
       if (arr.count == 0 && _locationCityModel.cityCC && isHostReach==1) {
          self.nowCityModel = self.locationCityModel;
           delegate.nowCity = self.nowCityModel;
          [self.cityArray removeAllObjects];
          [self.cityArray addObject:self.locationCityModel];
          self.titleCollectionView.contentOffset = CGPointMake(0, 0);
          [self.titleCollectionView reloadData];
          NSLog(@"城市列表为空");
       }
       
       if (arr.count == 0 && isHostReach==0) {
          DBModel * model1 = [[DBModel alloc]init];
          NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
          model1.cityPinyin = [user objectForKey:@"NOLOCATIONCITYPINYIN"];
          model1.country_name = [user objectForKey:@"NOLOCATIONCOUNTRYNAME"];
          model1.lat = [user objectForKey:@"NOLOCATIONLAT"];
          model1.lon = [user objectForKey:@"NOLOCATIONLON"];
          model1.cityCC = [user objectForKey:@"NOLOCATIONCITYCC"];
          self.nowCityModel = model1;
           delegate.nowCity = self.nowCityModel;
          [self.cityArray removeAllObjects];
          [self.cityArray addObject:self.nowCityModel];
          self.titleCollectionView.contentOffset = CGPointMake(0, 0);
          [self.titleCollectionView reloadData];
          NSLog(@"城市列表为空");
          
       }
   
   if(arr.count>0){
      [self.cityArray removeAllObjects];
       for (NSString * cityname in self.userCityArray) {
           for (DBModel *model in arr) {
               BOOL flag  =  NO;

               // 按顺序给城市排序
               //                l 相同,名字不同可以添加; l 不同,名字相同,可以添加 ; l 不同,名字不同,可以添加
               //                l 相同,名字相同不可以添加;
               if ([cityname isEqualToString:model.cityCC]) {
                   for (int j=0; j<self.cityArray.count; j++) {
                       DBModel *model1 = self.cityArray[j];
                       if ([model1.cityCC isEqualToString:cityname] && [model1.qwz isEqualToString:model.qwz]) {
                           flag = YES;//已经添加过了
                           break;
                       }
                       flag = NO;
                   }
                   if (!flag) {
                       [self.cityArray addObject:model];
                   }
               }
           }
       }

      self.nowCityModel = [self.cityArray firstObject];
       delegate.nowCity = self.nowCityModel;
      [self.titleCollectionView reloadData];
      self.titleCollectionView.contentOffset = CGPointMake(0, 0);
   }
}

#pragma mark - tableview的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return moduleNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    BaseTableViewCell*    cell = nil;
    NSString * moduleName = [self.cellNameArray objectAtIndex:indexPath.row];
    NSString * className = nil;
    NSString * identifier = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;

    if (!_press && indexPath.row == 0) {
        cell.contentView.alpha = 1.0;
        // 非移动状态,获取当前cell的类型
        className = [[self.dictionary objectForKey:moduleName] objectForKey:@"header_class"];
        identifier = [[self.dictionary objectForKey:moduleName] objectForKey:@"header_identifier"];
    }else{
        className = [[self.dictionary objectForKey:moduleName] objectForKey:@"narrow_class"];
        identifier = [[self.dictionary objectForKey:moduleName] objectForKey:@"narrow_identifier"];
    }
    // 创建cell
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        Class class = NSClassFromString(className);
        cell = [[class alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    // 对cell进行赋值
    if ([moduleName isEqualToString:weatherKey]) {
        cell.array = self.weatherArray;
        cell.otherArray = self.cityArray;
        cell.aqi = self.aqi;

        cell.type = self.type;

        [cell.collectionView reloadData];
    }
    if ([moduleName isEqualToString:wallpaperkey]) {
        if (indexPath.row == 0) {
            cell.array = self.wallpaperArray_big;
            cell.pages = self.pages;
            [cell.otherCollectionView reloadData];
            [cell.collectionView reloadData];
        } else {
            cell.array = self.wallpaperArray_little;
            cell.pages = self.pages;
            cell.otherArray = self.wallpaperArray_big;
            [cell.collectionView reloadData];
        }
    }
    if ([moduleName isEqualToString:calendarKey]) {
        cell.array = self.calendarArray;
        cell.countRows = _calendarArray.count;
        cell.isRefresh = _isRefresh;

        cell.type = self.type;
        
        [cell.collectionView reloadData];
    }
    cell.locationCityModel = self.locationCityModel;
    cell.cityModel = self.nowCityModel; // 仅 NarrowWeatherTableViewCell 用到
    cell.viewControllerDelegate = self;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   NSString * moduleName = [self.cellNameArray objectAtIndex:indexPath.row];
   
   NSString * cellHeight = nil;
   
   if (!_press && indexPath.row == 0) {
      cellHeight = [[self.dictionary objectForKey:moduleName] objectForKey:@"header_height"];
   }else{
      cellHeight = [[self.dictionary objectForKey:moduleName] objectForKey:@"narrow_height"];
   }
   return [cellHeight floatValue];
}
#pragma mark - 导航栏
- (void)setNavigationIteam{
   UIImageView *navigationImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
   self.navigationImageView = navigationImageView;
   self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
   [self applyTransparentBackgroundToTheNavigationBar:1.0];
    
    self.leftButton = [[UIButton alloc]init];
    _leftButton.frame = CGRectMake(0, 0, 33, 24.7);
    [_leftButton addTarget:self action:@selector(goToRootViewController:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    
    self.rightButton = [[UIButton alloc]init];
    _rightButton.frame = CGRectMake(0, 0, 18, 24);
    [_rightButton addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    [self setTitleView];
   
}
// 导航栏全透明
- (void)applyTransparentBackgroundToTheNavigationBar:(CGFloat)opacity{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];

}

-(UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
- (void)setTitleView{
   UIImage *leftimage ;
   UIImage *rightimage ;
    if (_press) {
      self.navigationBackView.alpha = navigationBackViewAlpha;
      self.navigationItem.titleView = nil;
   } else {
   
   NSString * firstCelName = [self.cellNameArray firstObject];
   if ([firstCelName isEqualToString:weatherKey]) {
       leftimage = [UIImage imageNamed:@"user_white"];
       rightimage = [UIImage imageNamed:@"share_white"];
      UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc]init];
      self.titleCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 150, 44) collectionViewLayout:flow];
      self.navigationItem.titleView = _titleCollectionView;
      _titleCollectionView.delegate = self;
      _titleCollectionView.dataSource = self;
      _titleCollectionView.backgroundColor = [UIColor whiteColor];
      [_titleCollectionView registerClass:[CityTitleCollectionViewCell class] forCellWithReuseIdentifier:@"TITLECOLLECTIONVIEWCELL"];
      _titleCollectionView.pagingEnabled = YES;
      flow.itemSize = self.titleCollectionView.frame.size;
      flow.minimumLineSpacing = 0;
      flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      _titleCollectionView.backgroundColor = [UIColor clearColor];
    self.navigationBackView.alpha = 0.0;
       for (int i = 0 ; i < self.cityArray.count;i ++) {
           DBModel * model = [self.cityArray objectAtIndex:i];
           if ([self.nowCityModel.cityCC isEqualToString:model.cityCC]) {
               self.titleCollectionView.contentSize = CGSizeMake(self.cityArray.count * self.titleCollectionView.frame.size.width, self.titleCollectionView.frame.size.height);
               self.titleCollectionView.contentOffset = CGPointMake(i * self.titleCollectionView.frame.size.width, 0);
               [self.titleCollectionView reloadData];
           }
       }
   }else if([firstCelName isEqualToString:wallpaperkey]){
       leftimage = [UIImage imageNamed:@"user_white"];
       rightimage = [UIImage imageNamed:@"share_white"];
      UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 150, 46)];
      _titleLibel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 150, 44)];
      self.navigationItem.titleView = titleView;
      _titleLibel.backgroundColor = [UIColor clearColor];
      _titleLibel.font = [UIFont fontWithName:CALENDARFONTHEITI size:19];
      _titleLibel.text = @"壁纸";
      _titleLibel.textColor = [UIColor whiteColor];
      _titleLibel.textAlignment = NSTextAlignmentCenter;
      [titleView addSubview:_titleLibel];
      self.navigationBackView.alpha = navigationBackViewAlpha;
   }else{
       leftimage = [UIImage imageNamed:@"user_red"];
       rightimage = [UIImage imageNamed:@"share_red"];
      UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 150, 46)];
      self.navigationItem.titleView = titleView;
      _titleLibel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, titleView.frame.size.width, 44)];
      [titleView addSubview:_titleLibel];
      _titleLibel.font = [UIFont fontWithName:CALENDARFONTKAITI size:19];
      _titleLibel.text = @"吉祥缘起通历";
      _titleLibel.textAlignment = NSTextAlignmentCenter;
      _titleLibel.textColor = UIColorFromRGB(0xaa4322);
       self.navigationBackView.alpha = 0.0;
   }
   }
    [_leftButton setImage:leftimage forState:UIControlStateNormal];
    [_rightButton setImage:rightimage forState:UIControlStateNormal];

}
#pragma mark - collection的代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   CityTitleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TITLECOLLECTIONVIEWCELL" forIndexPath:indexPath];

   if (self.cityArray.count>0) {
      DBModel * model = [self.cityArray objectAtIndex:indexPath.row];
      cell.textLabel.text = model.cityCC;
   }
   return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return _cityArray.count;
}
//点击城市进入城市管理
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   [self location];
}
// 城市管理
- (void)location{
   LocationController *location = [[LocationController alloc]init];
   location.locationCityModel = self.locationCityModel;
   [self.navigationController pushViewController:location animated:YES];
}
//分享按钮
- (void)shareBtnClick{
   NSLog(@" shareBtnClick");
   UIImage *image = [Help captureScrollView:_table];
   NSArray *activityItems = [[NSArray alloc]initWithObjects: image, nil];
   UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
   [self presentViewController:avc animated:YES completion:nil];
   UIActivityViewControllerCompletionHandler myblock = ^(NSString *type,BOOL completed){
      NSLog(@"completed:%d type:%@",completed,type);
   };
   avc.completionHandler = myblock;
}
#pragma mark - 长按拖动
-(void)longPressGestureRecognized:(UILongPressGestureRecognizer *)sender{
   UILongPressGestureRecognizer *longPress = sender;
   UIGestureRecognizerState state = longPress.state;
   CGPoint location = [longPress locationInView:_table];
   NSIndexPath *indexPath = [_table indexPathForRowAtPoint:location];
   switch (state) {
      case UIGestureRecognizerStateBegan: {
         
         _press = YES;
         _isBegan = YES;

         // 点按时隐藏上部titleView
         [self setTitleView];
         /*这里记录开始点按的位置*/
         sourceIndexPath = indexPath;
         fromIndexPath = indexPath;
         UITableViewCell *cell = [_table cellForRowAtIndexPath:indexPath];
         _cellImageView = [self customCellImageViewFromView:cell];
         _cellImageView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
         _cellImageView.alpha = 0.0;
         [_table addSubview:_cellImageView];
         [UIView animateWithDuration:0.25 animations:^{
            _cellImageView.frame = CGRectMake(cell.frame.origin.x, location.y, cell.frame.size.width, cell.frame.size.height);
            _cellImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            _cellImageView.alpha = 0.4;
            cell.alpha = 0.0;
         } completion:^(BOOL finished) {
            cell.hidden = YES;
            _isRefresh = NO;
            //这里刷新,是为了显示效果进行刷新,
            [_table reloadData];
         }];
         
         break;
      }
         
      case UIGestureRecognizerStateChanged: {
         //具体查看效果,因为点按的#(1,2,3等),大小需要保持不变,这个时候,不能用 origin.y 进行计算位置,不然手指不会处于模块#的位置,无法对齐
         CGPoint center = _cellImageView.center;
         center.y = location.y;
         _cellImageView.center = center;
         if ([self isScrollToEdge]){
            [self startTimerToScrollTableView];
            
         }else{
            [_displayLink invalidate];
         }
         
         if (indexPath && ![indexPath isEqual:sourceIndexPath]){
            // 移动cell
            [self.cellNameArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
            [_table moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
            sourceIndexPath = indexPath;
         }
         break;
      }
         
      default: {

         // 停止滚动
         [_displayLink invalidate];
         
         // 将当前模块顺序添加到userDefaults中
         [self saveUserDefaults:self.cellNameArray ToKey:@"moduleNameArray"];
          _isRefresh = NO;
         UITableViewCell *cell = [_table cellForRowAtIndexPath:sourceIndexPath];
         UITableViewCell *cell1 = [_table cellForRowAtIndexPath:fromIndexPath];
         cell.hidden = NO;
         cell.alpha = 0.0;
         [UIView animateWithDuration:0.25 animations:^{
            _cellImageView.center = cell.center;
            _cellImageView.alpha = 0.0;
            cell.alpha = 1.0;
            cell1.alpha = 1.0;
         } completion:^(BOOL finished) {
            sourceIndexPath = nil;
            _cellImageView = nil;
            [self.cellImageView removeFromSuperview];
            
         }];
         [self performSelector:@selector(refresh) withObject:nil afterDelay:RefreshDelayInterval];
         break;
      }
   }
}

-(void)refresh{
    // 结束状态
    _press = NO;
    _isBegan = NO;
    // 改变NavigationBar中的标题
    [self setTitleView];
    [_table reloadData];

}
-(BOOL)isScrollToEdge {
   //imageView拖动到tableView顶部，且tableView没有滚动到最上面
   if ((CGRectGetMaxY(self.cellImageView.frame)-10 > _table.contentOffset.y + _table.frame.size.height - _table.contentInset.bottom) && (_table.contentOffset.y-10 < _table.contentSize.height - _table.frame.size.height + _table.contentInset.bottom)) {
      self.autoScroll = AutoScrollDown;
      return YES;
   }
   
   //imageView拖动到tableView底部，且tableView没有滚动到最下面
   if ((self.cellImageView.frame.origin.y < _table.contentOffset.y + _table.contentInset.top) && (_table.contentOffset.y > -_table.contentInset.top)) {
      self.autoScroll = AutoScrollUp;
      return YES;
   }
   
   return NO;
}
-(void)startTimerToScrollTableView {
   [_displayLink invalidate];
   _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollTableView)];
   [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)scrollTableView{
   //如果已经滚动到最上面或最下面，则停止定时器并返回,手势结束时候,定时器也要停止
   if ((_autoScroll == AutoScrollUp && _table.contentOffset.y <= -_table.contentInset.top)|| (_autoScroll == AutoScrollDown && _table.contentOffset.y >= _table.contentSize.height - _table.frame.size.height + _table.contentInset.bottom)) {
      [_displayLink invalidate];
      return;
   }
   /*改变tableView的contentOffset，实现自动滚动*/
   CGFloat height = _autoScroll == AutoScrollUp? -3 : 3;
   [_table setContentOffset:CGPointMake(0, _table.contentOffset.y + height)];
   _cellImageView.frame = CGRectMake(_cellImageView.frame.origin.x, _cellImageView.frame.origin.y+height, _cellImageView.frame.size.width, _cellImageView.frame.size.height);
   
   /*
    滚动tableView的同时也要执行交换操作,(这里用center 是防止获取 fromIndexPath丢失)
    */
   fromIndexPath = [_table indexPathForRowAtPoint:_cellImageView.center];
   if (fromIndexPath && ![sourceIndexPath isEqual:fromIndexPath]){
      [self.cellNameArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:sourceIndexPath.row];
      [_table moveRowAtIndexPath:sourceIndexPath toIndexPath:fromIndexPath];
      sourceIndexPath = fromIndexPath;
   }
}
- (UIImageView *)customCellImageViewFromView:(UIView *)inputView {
   //截出图片
   UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0.0);
   [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
   UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   //截图试图
   UIImageView *cellImageView = [[UIImageView alloc] initWithImage:image];
   cellImageView.layer.masksToBounds = NO;
   cellImageView.layer.shadowOffset = CGSizeMake(-9.0, 0.0);
   cellImageView.layer.shadowRadius = 3.0;
   cellImageView.layer.shadowOpacity = 2.5;
   return cellImageView;
}

#pragma mark  下面是刷新试图的代理方法
-(void)setNavigationBarShow{
    NSString * firstCelName = [self.cellNameArray firstObject];
    if ([firstCelName isEqualToString:wallpaperkey]){
        self.navigationBackView.alpha = navigationBackViewAlpha;
    }
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark scrollView Delegate
//判断滚动方向向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   // 当模块顺序已经固定好了, 上下滑动tableview,顶部类似navigationbar效果渐变
   if (!_press && [scrollView isEqual:self.table]) {
      [_refreshView refreshViewDidScroll:scrollView];
      
      if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 64) {
//         self.navigationBackView.alpha = scrollView.contentOffset.y / 64;
      }

      if (scrollView.contentOffset.y < 0 ) {
         [self.navigationController setNavigationBarHidden:YES animated:YES];
          self.navigationBackView.alpha = 0;
      }
      if (scrollView.contentOffset.y>=0 && _isRefreshing == NO) {
          self.navigationBackView.alpha = navigationBackViewAlpha;
          [self.navigationController setNavigationBarHidden:NO animated:YES];
      }
      if (scrollView.contentOffset.y >= 64) {
         self.navigationBackView.alpha = navigationBackViewAlpha;
      }
      if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {
         
         scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height);
      }
      NSString * firstCelName = [self.cellNameArray firstObject];
      if ([firstCelName isEqualToString:weatherKey]) {
          self.navigationBackView.alpha = 0;
      }else if ([firstCelName isEqualToString:calendarKey]){
          self.navigationBackView.alpha = 0;
      }
   }
   
}
//松手的时候
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   NSLog(@"scrollView.contentOffset.y == 0:%f",scrollView.contentOffset.y );
   if ([scrollView isEqual:self.titleCollectionView]) {
      
   }
   else{
       [_refreshView refreshViewDidEndDragging:scrollView];
   }

}
- (void)getType{
    NSIndexPath *indexPath = nil;
    for (int i = 0; i < 3; i++) {
        NSString * cellName = [self.cellNameArray objectAtIndex:i];
        if ([cellName isEqualToString:weatherKey]) {
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        }
    }
    BaseTableViewCell * cell = [self.table cellForRowAtIndexPath:indexPath];
    NSInteger index = cell.collectionView.contentOffset.x / ScreenWidth ;
    self.type = index;
}

//通知,当天气模块为缩略状态下,点击城市切换下一个城市,当为最后一个城市时,循环到第一个城市
- (void)changeRootCityNotification{
   int cityNum = 0;
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (self.cityArray.count>1) {
        for (int i = 0; i<self.cityArray.count; i++) {
            DBModel * model = [self.cityArray objectAtIndex:i];
            if ([model.cityCC isEqualToString:self.nowCityModel.cityCC]) {
                cityNum = i + 1;
                break;
            }
        }
        [self getType];
        
         BOOL isHostReach  = [ReachManager isReachable];
        _cacheDataManager = [[CacheDataManager alloc]initFile];

        if (cityNum < self.cityArray.count) {
            self.nowCityModel = [self.cityArray objectAtIndex:cityNum];
            delegate.nowCity = self.nowCityModel;
            if (isHostReach == 1) {
                
                // 请求天气数据
                [self handleWeatherAndSunTimes];
            }else{
                AppDelegate *delegate1=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                [delegate1 addRequestErrorView];
                if ([_cacheDataManager isExistCacheFile]) {
                    [self reachLocalWeatherData];
                }
            }

        }else{
            self.nowCityModel = [self.cityArray objectAtIndex:0];
            delegate.nowCity = self.nowCityModel;
            if (isHostReach == 1) {
                // 请求天气数据
                [self handleWeatherAndSunTimes];
            }else{
                AppDelegate *delegate1=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                [delegate1 addRequestErrorView];
                if ([_cacheDataManager isExistCacheFile]) {
                    [self reachLocalWeatherData];
                }
            }

        }
        NSLog(@"%@", self.nowCityModel.cityCC);
    }
}
// 天气为第一模块,滑动顶部切换城市
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

   if ([scrollView isEqual:self.titleCollectionView]) {
      CGFloat cityNum = self.titleCollectionView.contentOffset.x/self
      .titleCollectionView.frame.size.width;
      DBModel * model = [self.cityArray objectAtIndex:cityNum];
       // 更改城市前获取当前显示的是第几日的天气
       NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
       BaseTableViewCell * cell = [self.table cellForRowAtIndexPath:indexPath1];
       [self getType];
//       self.type = cell.type;
//       有名字或L中的一个不同,进行刷新, (特殊情况:国内城市,名字不同,但是qwz相同)
        if (![model.cityCC isEqualToString:self.nowCityModel.cityCC] && ![model.qwz isEqualToString:self.nowCityModel.qwz]) {
           self.nowCityModel = model;
           AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
           delegate.nowCity = self.nowCityModel;

            BOOL isHostReach  = [ReachManager isReachable];
           _cacheDataManager = [[CacheDataManager alloc]initFile];
           if (isHostReach == 1) {
               // 请求天气数据
               [self handleWeatherAndSunTimes];
           }else{
               AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
               [delegate addRequestErrorView];
               if ([_cacheDataManager isExistCacheFile]) {
                   [self reachLocalWeatherData];

               }
           }
       }

   }else{
      [_refreshView refreshViewDidEndDragging:scrollView];
   }
}

//下载数据
- (void)UpdownloadData{
//    [self handleCityData];
   //这里刷新数据
    BOOL isHostReach  = [ReachManager isReachable];
   _cacheDataManager = [[CacheDataManager alloc]initFile];
   NSLog(@"isHostReach:%d",isHostReach);
   if (isHostReach == 1) {
    //检测是否注册过,没有需要先注册,注册完成后,请求数据
       if (![JSNet hasRegister]) {
            [JSNet appRegisterWithFinishBlock:^(BOOL isFinishRegister) {
                // 请求天气数据
                [self refreshWeather];
                // 请求壁纸数据
                [self handleWallpaperData];
            }];
            
       }else{
          // 请求天气数据
          [self refreshWeather];
          // 请求壁纸数据
          [self handleWallpaperData];
       }
   }else{
       [self reachLocalWeatherData];
       [self reachLocalWallpaperData];
      // 断网情况下不刷新
      AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
      [delegate addRequestErrorView];
   }
   //刷新完成后,应该让刷新视图调用下面的方法,来结束刷新,收起刷新提示条
   [_refreshView refreshViewDataSourceDidFinishedLoading:_table];
   //改变标记状态
   _isRefreshing = NO;
   _type = 0;
}
#pragma mark RefreshView Delegate
//下拉刷新的执行方法  如果上述两个监听的滚动高度小于-65(scrollView.contentOffset.y <= - 65.0f)则执行这个代理方法改变刷新状态(出现菊花图)
- (void)refreshViewDidTriggerRefresh:(RefreshPosition)refreshPosition{
   NSLog(@"这里触发执行刷新操作");
   _isRefreshing = YES;
    
   [self performSelector:@selector(UpdownloadData) withObject:nil afterDelay:0];
}

//滚动过程会不断调用这个方法监听是否改变刷新状态(即是否出现菊花图转的效果),实现原理中 需要这个变量去判断请求数据是否完成
- (BOOL)refreshViewDataIsLoading:(UIView *)view{
   return _isRefreshing;
}

//显示刷新时间
- (NSDate*)refreshViewDataLastUpdated{
  
   return [NSDate date];
}

#pragma mark 日历无限滚动delegate
-(void)reloadCalendarTableViewCell:(NSMutableArray *)array{
   [_calendarArray removeAllObjects];
   _calendarArray = array;
   _isRefresh = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
    [_table reloadData];
    });
}

- (void) fromWeatherInsidetoHomeWithCityModel:(DBModel *)city WeatherArray:(NSMutableArray *)weatherArray AndType:(NSInteger)type andIsCalendarInsidePagesBack:(BOOL)isBackOrPush{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSLog(@"%@ %@ %@", self.nowCityModel.cityCC, city.cityCC, delegate.nowCity.cityCC);
    self.nowCityModel = city;

    // 更改城市
    for (int i = 0 ; i < self.cityArray.count;i ++) {
        DBModel * model = [self.cityArray objectAtIndex:i];
        if ([self.nowCityModel.cityCC isEqualToString:model.cityCC]) {
            [self.titleCollectionView reloadData];
            self.titleCollectionView.contentOffset = CGPointMake(i * self.titleCollectionView.frame.size.width, 0);
            
            break;
        }
    }
    //更改数据
    for (int i = 0; i < 3; i++) {
        NSString * cellName = [self.cellNameArray objectAtIndex:i];
        if ([cellName isEqualToString:weatherKey] || [cellName isEqualToString:calendarKey]) {
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:0];
            BaseTableViewCell * cell = [self.table cellForRowAtIndexPath:indexPath1];
            cell.type = type;
            _type = type;
                
            }

    }

    self.weatherArray = weatherArray;
    [self.table reloadData];
}

@end
