//
//  AppDelegate.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/2/25.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "WanNianLiDate.h"
#import "ToolVC.h"

@interface AppDelegate ()
@property (nonatomic , retain) NSMutableArray * array; // 用来记录目前正在进行的网络请求
@end

@implementation AppDelegate
{
    NSTimer * _timer;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 记录进入程序时间
    NSDate *myDate = [NSDate date];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:myDate forKey:@"mydate"];

    // 清除系统自动缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    RootViewController *rtVC = [[RootViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rtVC];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

//    [WanNianLiDate getDataBase];
    [self initNetworkMonitor];
    [self readUserDefaults];
    [self getLaunageCode];

    [self creatActivity];
    [self creatRequestErrorView];
    return YES;
}

-(void)getLaunageCode{
    //天气接口中的区域语言需要特殊处理,万年历里的日期也有request
    self.languageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}

- (void)creatRequestErrorView{
    self.requestErrorView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    _requestErrorView.center = self.window.center;
    _requestErrorView.text = @"请检查网络";
    _requestErrorView.backgroundColor = [UIColor whiteColor];
    _requestErrorView.alpha = 0.7;
    _requestErrorView.layer.cornerRadius = 10;
    _requestErrorView.layer.masksToBounds = YES;
    _requestErrorView.textAlignment = NSTextAlignmentCenter;
}

// 网络超时请求
- (void)addRequestErrorView{
    // 添加请求失败视图,三秒后移除
    [self.window addSubview:self.requestErrorView];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self.requestErrorView selector:@selector(removeFromSuperview) userInfo:nil repeats:NO];
}

// 正在加载视图
- (void)creatActivity{
     self.loadView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _loadView.backgroundColor = UIColorFromRGB(0x5F5F5F);
    _loadView.alpha = 0.9;
    _loadView.layer.cornerRadius = 6;
    _loadView.layer.masksToBounds = YES;
    _loadView.frame = CGRectMake(0, 0, 120, 120);
    _loadView.center = self.window.center;
    self.array = [NSMutableArray array];

    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, 120, 20)];
    title.text = @"加载中,请稍候…";
    title.textColor = UIColorFromRGB(0xFFFFFF);
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 0;
    title.font = [UIFont fontWithName:CALENDARFONTHEITI size:14];
    [self.loadView addSubview:title];
    /****/
    [self.window addSubview:self.loadView];
}

- (void)addLoadView{
    [_loadView startAnimating];
    self.window.userInteractionEnabled = NO;
    [self.array addObject:@"1"];
}

- (void)removeLoadView{
    [self.array removeLastObject];
    if (self.array.count == 0) {
        [_loadView stopAnimating];
        self.window.userInteractionEnabled = YES;
    }
}

- (void)initNetworkMonitor{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
    [self.hostReach startNotifier];//开始监听，会启动一个run loop
}


-(void)reachabilityChanged:(NSNotification *)noti{
    Reachability* curReach = [noti object];
    //对连接改变做出响应处理动作
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    NSLog(@"netStatusAPP:%lu",(long)netStatus);
    _reachableCount++;
    if (_reachableCount == 2) {
        _reachableCount = 0;
        return;
    }
    if (netStatus == NotReachable) {
        NSLog(@"ReachableViaWiFi");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:NSLocalizedString(@"network failed", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
        [alert show];
    }else if (netStatus == ReachableViaWiFi) {
        NSLog(@"ReachableViaWiFi");
    }else if (netStatus == ReachableViaWWAN) {
        NSLog(@"ReachableViaWWAN");
    }
}


// 将气象源本地的存储
- (NSInteger)readUserDefaults
{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    if (![userDefaultes objectForKey:@"FirstLaunch"]) {
        [userDefaultes setBool:YES forKey:@"FirstLaunch"];
    }else{
        [userDefaultes setBool:NO forKey:@"FirstLaunch"];
    }
    [userDefaultes setObject:APP_VERSION forKey:@"APP_VERSION"];

    [WanNianLiDate updateJYJSFile]; //jyjscalendar.zip文件更新,SelectedWallpaperListDB 更新

    self.meteorologicalSource = [userDefaultes integerForKey:@"meteorologicalSource"];
    //如未添加气象源,则默认为1
    if (0 == self.meteorologicalSource) {
        self.meteorologicalSource = 1;
        [self saveUserDefaults];
    }
    /*
     1. 使用实时背景
     2. 不使用实时背景
     */
//    self.realtimeWeatherBackground = [userDefaultes integerForKey:@"realtimeWeatherBackground"];
//    if (0 == self.realtimeWeatherBackground) {
//         self.realtimeWeatherBackground = 2;
//        [self savveRealtimeWeatherBackground];
//    }
    return self.meteorologicalSource;
}

- (void)saveUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:self.meteorologicalSource forKey:@"meteorologicalSource"];
}

//- (void)savveRealtimeWeatherBackground{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setInteger:self.realtimeWeatherBackground forKey:@"realtimeWeatherBackground"];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // 记录进入后台的时间
    NSDate *myDate = [NSDate date];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:myDate forKey:@"mydate"];
}

// 进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application{
     NSLog(@"进入前台开始刷新");
    //当程序进入后台超过两个小时再返回前台时,程序进入根视图,刷新数据
    NSDate *nowDate = [NSDate date];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSDate *myDate = [userDefaultes valueForKey:@"mydate"];
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    RootViewController *rtVC = [nav.viewControllers firstObject];
    if ([nowDate compare:[myDate dateByAddingTimeInterval:(2*60*60)]] == NSOrderedDescending) {
        [nav popToRootViewControllerAnimated:NO];
        [rtVC handleData];
    }
#pragma wq
//    [rtVC.leftViewController.locMgr startUpdatingLocation];
      [rtVC.leftViewController startLocation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
