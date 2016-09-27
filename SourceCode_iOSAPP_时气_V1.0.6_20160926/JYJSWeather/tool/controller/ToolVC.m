//
//  ToolVC.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/11.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "ToolVC.h"
#import "DBModel.h"
#import "SqlDataBase.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "LocationController.h"
#import "AboutUsViewController.h"
#import "FeedbackViewController.h"
//#import <CoreLocation/CoreLocation.h>

@interface ToolVC ()<UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate, UIAlertViewDelegate>
@property (nonatomic , strong) UITableView          * table;
@property (nonatomic , strong) NSMutableArray       * textArray;
//@property (nonatomic , strong) CLLocationManager    * locMgr;
@property (nonatomic , strong) CLGeocoder           * geocoder;
@property (nonatomic , strong) UILabel              * numlabel;
@property (nonatomic , strong) UISwitch             * switchView;
@property (nonatomic , strong) UIButton             * cleanButton;
@property (nonatomic , strong) DBModel              * locationCityModel;
@property (nonatomic , strong) UIAlertView          * alert;              // 定位失败弹出的提示框
@property (nonatomic , assign) CGFloat                imageSize;          // 记录缓存壁纸大小
//@property (nonatomic , strong) UISwitch             * switchWeather;      // 显示实时气象背景
@end

@implementation ToolVC

- (instancetype)init
{
    self = [super init];
    if (self) {
//         self.textArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"my city", nil), NSLocalizedString(@"my wallpaper", nil), NSLocalizedString(@"prefer use", nil),NSLocalizedString(@"real-time weather",nil),NSLocalizedString(@"feedback", nil), NSLocalizedString(@"about us", nil), nil];
        self.textArray = [NSMutableArray arrayWithObjects:NSLocalizedString(@"my city", nil), NSLocalizedString(@"my wallpaper", nil), NSLocalizedString(@"prefer use", nil),NSLocalizedString(@"feedback", nil), NSLocalizedString(@"about us", nil), nil];

        self.locationCityModel = [[DBModel alloc]init];
    }
    return self;
}
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [NSString stringWithFormat:@"%@/images", path];
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    self.imageSize = folderSize/(1024.0*1024.0);
    self.numlabel.text = [NSString stringWithFormat:@"缓存:%0.2fM",self.imageSize];
    return folderSize/(1024.0*1024.0);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"alert", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];

    [self startLocation];
//    self.switchWeather = [[UISwitch alloc]init];

    self.numlabel = [[UILabel alloc]init];
    self.switchView = [[UISwitch alloc]init];
    self.cleanButton = [[UIButton alloc]init];
    [self creatTableView];
}
- (void)startLocation{
    //判断用户定位服务是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        //开始定位用户的位置
        //        [self.locMgr requestWhenInUseAuthorization];//添加这句
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            //调用授权方法
            [self.locMgr requestWhenInUseAuthorization];
        }
        //每隔多少米定位一次（这里的设置为任何的移动）
        self.locMgr.distanceFilter=kCLDistanceFilterNone;
        //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）
        self.locMgr.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
        NSLog(@"重走这个方法");
    }else{
        //不能定位用户的位置
        //1.提醒用户检查当前的网络状况
        //2.提醒用户打开定位开关
        NSLog(@"不能使用定位啊:1.请打开定位");
        self.alert.message = NSLocalizedString(@"location services off", nil);
        [self showAlertView];
    }
    [self.locMgr startUpdatingLocation];
}
#pragma mark-懒加载
-(CLLocationManager *)locMgr
{
    if (_locMgr==nil) {
        //1.创建位置管理器（定位用户的位置）
        self.locMgr=[[CLLocationManager alloc]init];
        //2.设置代理
        self.locMgr.delegate=self;
    }
    return _locMgr;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    CLLocation *location = [locations firstObject];
    NSLog(@"定位成功");

    self.geocoder=[[CLGeocoder alloc]init];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            CLPlacemark *placemark=[placemarks firstObject];
            DBModel * model = [[DBModel alloc]init];
            BOOL isHostReach  = [ReachManager isReachable];
            if (isHostReach) {
                model.cityCC = [placemark.addressDictionary objectForKey:@"City"];
                model.lat = [NSString stringWithFormat:@"%f", placemark.location.coordinate.latitude];
                model.lon = [NSString stringWithFormat:@"%f", placemark.location.coordinate.longitude];
                //解决2次定位添加不进去的问题,qwz标识符标示此城市是定位的城市,后面拼接 lat,lon以区别不同定位城市
                model.qwz = [NSString stringWithFormat:@"qwz%@%@",model.lat,model.lon];
                //判断国家编码
                if ([[placemark.addressDictionary objectForKey:@"Country"] isEqualToString:@"US"]) {
                     model.country_name = @"USA";
                }else if ([[placemark.addressDictionary objectForKey:@"Country"] isEqualToString:@"CN"]){
                     model.country_name = @"China";
                }
                self.locationCityModel = model;
                self.delegate.locationCityModel = model;
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:model.cityPinyin forKey:@"NOLOCATIONCITYPINYIN"];
                [user setObject:model.country_name forKey:@"NOLOCATIONCOUNTRYNAME"];
                [user setObject:model.lat forKey:@"NOLOCATIONLAT"];
                [user setObject:model.lon forKey:@"NOLOCATIONLON"];
                [user setObject:model.cityCC forKey:@"NOLOCATIONCITYCC"];
                [user setObject:model.qwz forKey:@"NOLOCATIONCITYL"];
                NSLog(@"当前城市信息:%@",[placemark.addressDictionary objectForKey:@"City"]);
            }else{
                self.alert.message = NSLocalizedString(@"location failed", nil);
                [self showAlertView];
            }

        } else {
            self.alert.message = NSLocalizedString(@"location failed", nil);
            [self showAlertView];
        }
    }];
    //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
    [self.locMgr stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied) {
        NSLog(@"用户拒绝使用定位服务,请用户打开定位服务!");
        self.alert.message = NSLocalizedString(@"location services off", nil);
        [self showAlertView];
    }else if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"目前位置是未知的,但CL将继续努力");
    }else if ([error code] == kCLErrorRegionMonitoringDenied) {
        NSLog(@"这是啥");
    }else if ([error code] == kCLErrorDeferredFailed){
        self.alert.message = NSLocalizedString(@"location failed", nil);
        [self showAlertView];
        NSLog(@"定位失败");
    }else{
        self.alert.message = NSLocalizedString(@"location failed", nil);
        [self showAlertView];
    }
}
// 提示定位异常, 当城市列表为空时提醒用户
- (void)showAlertView
{
    SqlDataBase *sqldata = [[SqlDataBase alloc]init];
     [sqldata configDatabase];
    NSArray * array = [sqldata searchAllSaveCity];
    if (array.count == 0) {
        [_alert show];
    }
}
- (void)creatTableView
{
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LeftWidth, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:self.table];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.scrollEnabled = NO;

    UIButton *appTitle = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    appTitle.contentEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
    [appTitle setTitle:NSLocalizedString(@"CFBundleDisplayName", nil) forState:UIControlStateNormal];
    self.table.tableHeaderView = appTitle;
    appTitle.highlighted = NO;
    [appTitle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    appTitle.titleLabel.font = [UIFont fontWithName:CALENDARFONTKAITI size:25];
    appTitle.userInteractionEnabled = NO;
    appTitle.backgroundColor = [UIColor whiteColor];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TOOLVCCELL"];

    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TOOLVCCELL"];
    }
    cell.textLabel.font = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERTHREE];
    cell.textLabel.text = [self.textArray objectAtIndex:indexPath.row];
    if (indexPath.row == 1) {
        _cleanButton.frame = CGRectMake(LeftWidth - 60, 20, 50,  21);
        [_cleanButton removeFromSuperview];
        [cell addSubview:_cleanButton];
        [_cleanButton setTitle:NSLocalizedString(@"clear", nil) forState:UIControlStateNormal];
         _cleanButton.titleLabel.font = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERTHREE];
        [_cleanButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cleanButton addTarget:self action:@selector(cleanAction) forControlEvents:UIControlEventTouchUpInside];
        _cleanButton.backgroundColor = [UIColor lightGrayColor];
        _cleanButton.layer.cornerRadius = 5;
        _cleanButton.layer.masksToBounds = YES;
        
        [_numlabel removeFromSuperview];
        [cell addSubview:_numlabel];
        _numlabel.frame = CGRectMake(_cleanButton.frame.origin.x-100, 15, 90, 31);
        _numlabel.text = [NSString stringWithFormat:@"缓存:%0.2fM",self.imageSize];
        _numlabel.textColor = [UIColor grayColor];
        _numlabel.font = [UIFont fontWithName:CALENDARFONTHEITI size:TextNumberThree];
        _numlabel.textAlignment = NSTextAlignmentRight;
    }
    if (indexPath.row == 2) {
        self.switchView.frame = CGRectMake(LeftWidth - 60, 15, 35, cell.frame.size.height-15);
        [cell addSubview:self.switchView];

        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        switch (delegate.meteorologicalSource) {
            case 2:
                _switchView.on = NO;
                break;
                
            default:
                _switchView.on = YES;
                break;
        }
        [_switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
//    if (indexPath.row == 3) {
//        self.switchWeather.frame = CGRectMake(LeftWidth - 60, 15, 35, cell.frame.size.height-15);
//        
//        [cell addSubview:self.switchWeather];
//        
//        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//        switch (delegate.realtimeWeatherBackground) {
//            case 2:
//                _switchWeather.on = YES;
//                break;
//                
//            default:
//                _switchWeather.on = NO;
//                break;
//        }
//        [_switchWeather addTarget:self action:@selector(switchWeatherAction:) forControlEvents:UIControlEventValueChanged];
//    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
// 清除缓存
- (void)cleanAction
{
    NSFileManager* manager = [NSFileManager defaultManager];
     NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [NSString stringWithFormat:@"%@/images", path];
    NSArray *contents = [manager contentsOfDirectoryAtPath:path error:NULL];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"clear alert title", nil) message:[NSString stringWithFormat:NSLocalizedString(@"clear alert", nil), self.imageSize,(unsigned long)contents.count] delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"ok", nil),nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self sureClean];
    }
}

- (void)sureClean
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [NSString stringWithFormat:@"%@/images", path];
    NSArray *contents = [manager contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        [manager removeItemAtPath:[path stringByAppendingPathComponent:filename] error:NULL];
    }
    [self folderSizeAtPath];
    [self.table reloadData];
    //请求初始时间重置
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:nil forKey:@"RequestDataTime"];
    //清空数据表
    SqlDataBase *sqldata = [[SqlDataBase alloc]init];
    [sqldata configSelectedWallpaperListDB];
    [sqldata eraseTableInSelectedWallpaperListDB];
    NSLog(@"分隔-----------------");
    //重新请求数据
    [_delegate requestWallpaperList];
}

- (void)switchAction:(UISwitch *)switchView
{
    if (switchView.on) {
        NSLog(@"国外气象源");
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.meteorologicalSource=1;
        [delegate saveUserDefaults];
    } else {
        NSLog(@"国内气象源");
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.meteorologicalSource=2;
        [delegate saveUserDefaults];
    }
}

//- (void)switchWeatherAction:(UISwitch *)switchWeather{
//    if (switchWeather.on) {
//        NSLog(@"非实时背景");
//        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//        delegate.realtimeWeatherBackground=2;
//        [delegate savveRealtimeWeatherBackground];
//    } else {
//        NSLog(@"实时背景");
//        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//        delegate.realtimeWeatherBackground=1;
//        [delegate savveRealtimeWeatherBackground];
//    }
//    
//    [self.delegate reloadWeatherCell];
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString(@"system settings", nil);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 61.f;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.textArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"my city", nil)]) {
        LocationController *locationVC = [[LocationController alloc]init];
        locationVC.locationCityModel = self.locationCityModel;
        [self.delegate.navigationController pushViewController:locationVC animated:YES];
    }
    if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"about us", nil)]) {
        AboutUsViewController *aboutUs = [[AboutUsViewController alloc]init];
        [self.delegate.navigationController pushViewController:aboutUs animated:YES];
    }
    if ([cell.textLabel.text isEqualToString:NSLocalizedString(@"feedback", nil)]) {
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc]init];
        [self.delegate.navigationController pushViewController:feedbackVC animated:YES];
    }
    
}


@end
