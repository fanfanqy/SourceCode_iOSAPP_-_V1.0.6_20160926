//
//  WeatherInsidePagesVC.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "WeatherInsidePagesVC.h"
#import "Utils.h"
#import "DBModel.h"
#import "AppDelegate.h"
#import "RefreshView.h"
#import "SqlDataBase.h"
#import "WeatherModel.h"
#import "BaseTableViewCell.h"
#import "WeekTableViewCell.h"
#import "IndexTableViewCell.h"
#import "LocationController.h"
#import "RootViewController.h"
#import "WeatherTableViewCell.h"
#import "WeatherCollectionViewCell.h"
#import "CityTitleCollectionViewCell.h"
@interface WeatherInsidePagesVC ()<UITableViewDelegate, UITableViewDataSource, WeekTableViewCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate,RefreshViewDelegate>
{
    NSInteger asnMark;
}
@property (nonatomic , strong) NSMutableArray       * heightForRowArr;
@property (nonatomic , strong) UICollectionView     * titleCollectionView; //导航栏上面滚动城市
@property (nonatomic , strong) UIImageView          * backgroumdView_down; // 天气下部背景
@property (nonatomic , strong) CacheDataManager     * cacheDataManager;
//刷新视图
@property (nonatomic, strong) RefreshView            * refreshView;

@end

@implementation WeatherInsidePagesVC
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.array = [NSMutableArray array];
        self.cityArray = [NSMutableArray array];
        self.nowCityModel = [[DBModel alloc]init];
    }
    return self;
}
- (NSMutableArray *)heightForRowArr{
    if (!_heightForRowArr) {

        _heightForRowArr = [@[[NSString stringWithFormat:@"%f",ModuleWeatherHeight], @"325", @"150"]mutableCopy];
    }
    return _heightForRowArr;
}
- (void)saveTimeUserDefaultsWithCityModel:(DBModel *)cityModel Aqi:(NSInteger)aqi{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString * l = cityModel.qwz;
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
        return 0;
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
- (void)viewWillAppear:(BOOL)animated{
    /*
     * 1. 从主页跳转至此
     * 2. 从城市列表返回后跳转至此
     */
    [super viewWillAppear:animated];
    // 主页跳转过来不走这个方法
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (![delegate.nowCity.cityCC isEqualToString:self.nowCityModel.cityCC]) {
        self.nowCityModel = delegate.nowCity;
#pragma wq
        self.type = 0;
        [self handleWeatherAndAqi];
    }
    // 当前城市在城市列表中
    for (int i = 0 ; i < self.cityArray.count;i ++) {
        DBModel * model = [self.cityArray objectAtIndex:i];
        if ([self.nowCityModel.cityCC isEqualToString:model.cityCC]) {
            [self.titleCollectionView reloadData];
            self.titleCollectionView.contentOffset = CGPointMake(i * self.titleCollectionView.frame.size.width, 0);
            return;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTable];
    [self setNavigationIteam];
    [self creatRefreshHeadView];
    [self changeCollectionViewContentOffset];
}
- (void)changeCollectionViewContentOffset{
    self.titleCollectionView.contentSize = CGSizeMake(self.array.count * self.titleCollectionView.frame.size.width, self.titleCollectionView.frame.size.height);
    // 让城市名称与上一页的城市名称相对应
    for (int i = 0; i< self.cityArray.count; i++) {
        DBModel * model = [self.cityArray objectAtIndex:i];
        
        if ([model.cityCC isEqualToString:self.nowCityModel.cityCC]) {
            self.titleCollectionView.contentOffset = CGPointMake(i * self.titleCollectionView.frame.size.width, 0);
            break;
        }
    }
}
- (void)setNavigationIteam{
//    UIView * navigationBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//    [self.view addSubview:navigationBarView];
//    navigationBarView.backgroundColor = [UIColor whiteColor];
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;


    UIImage *leftimage = [UIImage imageNamed:@"back_white"];
    UIButton * leftButton = [[UIButton alloc]init];
    leftButton.frame = CGRectMake(0, 0, 22, 22);
    [leftButton setImage:leftimage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBackViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    // 分享按钮
    UIImage *rightimage = [UIImage imageNamed:@"share_white"];
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];

    rightButton.frame = CGRectMake(0, 0, 18, 24);
    [rightButton setImage:rightimage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
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

- (void)goBackViewController{
    RootViewController * root = (RootViewController *)[self.navigationController.viewControllers firstObject];

    [root fromWeatherInsidetoHomeWithCityModel:self.nowCityModel WeatherArray:self.array  AndType:_type andIsCalendarInsidePagesBack:NO];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareAction{
    NSLog(@"分享给好友");
    UIImage *image = [Help captureScrollView:_table];
    NSArray *activityItems = [[NSArray alloc]initWithObjects:image, nil];
    UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
    UIActivityViewControllerCompletionHandler myblock = ^(NSString *type,BOOL completed){
        NSLog(@"completed:%d type:%@",completed,type);
    };
    avc.completionHandler = myblock;
}
#pragma mark - 请求数据
- (void)handleData{
     BOOL isHostReach  = [ReachManager isReachable];
    _cacheDataManager = [[CacheDataManager alloc]initFile];
    if (isHostReach) {
        [self handleWeatherAndAqi];
    }else{
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate addRequestErrorView];
        [self handleLocalWeatherData];
    }

}
- (void)handleWeatherAndAqi{
    if ([self readTimeUserDefaulesWithCityModel:self.nowCityModel]) {
        if ([_cacheDataManager isExistCacheFile]) {
            [self handleLocalWeatherData];
        }
    }else{
        
        asnMark ++;
        [self handleWeatherData];
        [self handleAqi];
    }
}
// 请求空气质量数据
- (void)handleAqi{
    self.aqi = 0;
    [JSNet handlAqiWithCityModel:self.nowCityModel Mark:asnMark finishAqiBlock:^(NSUInteger mark, NSInteger aqi) {
        if (asnMark == mark) {
            self.aqi = aqi;
            WeatherTableViewCell * weatherTableCell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            WeatherCollectionViewCell *wCell = (WeatherCollectionViewCell *)[weatherTableCell.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            wCell.pollution.image = [self getImageWithAqi:aqi];
            [self saveTimeUserDefaultsWithCityModel:self.nowCityModel Aqi:self.aqi];
        }
    }];
}
- (UIImage *)getImageWithAqi:(NSInteger)aqi{
    if (aqi == 0) {
        return nil;
    }else{
       NSString * path =[Help getAqiImage:aqi];        if (path) {
            return [UIImage imageWithContentsOfFile:path];
        }else{
            return nil;
        }
    }
}
-(void)handleLocalWeatherData{
    _cacheDataManager = [[CacheDataManager alloc]initFile];
     NSDictionary *dic = [_cacheDataManager requestLocalWeatherData:[NSString stringWithFormat:@"%@-%@",CacheWeather,[self.nowCityModel.qwz stringByReplacingOccurrencesOfString:@"/" withString:@""]]];
     self.array = [WeatherModel analysisDataWithArray:dic];

    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *indexPath2 =  [NSIndexPath indexPathForRow:1 inSection:0];
    NSIndexPath *indexPath3 =  [NSIndexPath indexPathForRow:2 inSection:0];
    
    WeatherTableViewCell * weatherCell = [self.table cellForRowAtIndexPath:indexPath1];
    weatherCell.type = _type;
//    weatherCell.array = self.array;
    WeekTableViewCell * weekCell = [self.table cellForRowAtIndexPath:indexPath2];
    weekCell.type = _type;
//    weekCell.array = self.array;
    [self.table reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
    [self.table reloadRowsAtIndexPaths:@[indexPath2,indexPath3] withRowAnimation:UITableViewRowAnimationNone];
#pragma wq
    [self changeBackgroundView:_type];
}
- (void)handleWeatherData{
    [JSNet handleWeatherWithCityModel:self.nowCityModel Mark:asnMark FinishBlock:^(NSData *data, NSUInteger mark) {
        if (mark != asnMark) {
            return ;
        }
        if (mark != asnMark) {
            return ;
        }
        NSError * error = nil;
        NSDictionary * finishDic = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:&error];
        if (!error) {
            
            NSString * dataString = [finishDic objectForKey:@"d"];
            
            NSData * finishData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:finishData options:NSUTF8StringEncoding error:nil];

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [_cacheDataManager createWeatherFileWithFileName:[NSString stringWithFormat:@"%@-%@",CacheWeather,[self.nowCityModel.qwz stringByReplacingOccurrencesOfString:@"/" withString:@""]] andData:dic];
            });

            self.array = [WeatherModel analysisDataWithArray:dic];
            NSLog(@"天气数据请求结束");

              NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
              NSIndexPath *indexPath2 =  [NSIndexPath indexPathForRow:1 inSection:0];
              NSIndexPath *indexPath3 =  [NSIndexPath indexPathForRow:2 inSection:0];
            WeatherTableViewCell * weatherCell = [self.table cellForRowAtIndexPath:indexPath1];
            weatherCell.type = _type;
            
            WeekTableViewCell * weekCell = [self.table cellForRowAtIndexPath:indexPath2];
            weekCell.type = _type;

              [self.table reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationFade];
              [self.table reloadRowsAtIndexPaths:@[indexPath2,indexPath3] withRowAnimation:UITableViewRowAnimationNone];
              [self changeBackgroundView:_type];
                /****/

            
        }else{
            NSLog(@"请求失败");
        }
        
    }];
}
#pragma Mark- tableview
- (void)creatTable{
    self.backgroumdView_down = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.backgroumdView_down];
    self.backgroumdView_down.backgroundColor = UIColorFromRGB(0xcccccc);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setBackgroundViewToIndex:) name:@"WeatherTableViewCellEndDecelerating" object:nil];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.table];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.showsVerticalScrollIndicator = NO;
    self.table.showsHorizontalScrollIndicator = NO;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.backgroundColor = [UIColor clearColor];
    [self changeBackgroundView:_type];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        WeatherTableViewCell * cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:@"WEATHERTABLEVIEWCELL"];
        if (!cell) {
            cell = [[WeatherTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WEATHERTABLEVIEWCELL"];
        }
        cell.viewControllerDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.array = self.array;
        cell.aqi = self.aqi;
        cell.type = _type;

        [cell.collectionView reloadData];
        return cell;
        
    } else if (indexPath.row == 1){
        WeekTableViewCell * cell = nil;
         cell = [tableView dequeueReusableCellWithIdentifier:@"WEEKTABLEVIEWCELL"];
        if (!cell) {
            cell = [[WeekTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WEEKTABLEVIEWCELL"];
        }
        WeatherTableViewCell * cc = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.type = cc.topScrollView.contentOffset.x / ScreenWidth;
        cell.type = _type;
        if (cell.type > 4) {
            cell.collectionView.contentOffset = CGPointMake(ScreenWidth, 0);
        }else{
            cell.collectionView.contentOffset = CGPointMake(0, 0);
        }
        cell.viewControllerDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.array = self.array;
        cell.delegate = self;
        cell.aqi = self.aqi;
         [cell.collectionView reloadData];
        return cell;
        
    }else{
        IndexTableViewCell *cell = nil;
       
        cell = [[IndexTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"INDEXTABLEVIEWCELL"];
        
        cell.viewControllerDelegate = self;
        cell.nowCityModel = self.nowCityModel;
        cell.array = self.array;
        
        cell.aqi = self.aqi;
        WeatherTableViewCell * weatherCell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger index = weatherCell.topScrollView.contentOffset.x / ScreenWidth ;
        cell.index = index;
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [[self.heightForRowArr objectAtIndex:indexPath.row] floatValue];
    return height;
}
#pragma mark - collectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CityTitleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TITLECOLLECTIONVIEWCELL" forIndexPath:indexPath];
     if (self.cityArray.count>0) {
    DBModel * model = [self.cityArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.cityCC;
    cell.textLabel.font = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERTHREE];
    cell.textLabel.textColor = [UIColor whiteColor];
     }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LocationController *location = [[LocationController alloc]init];
    location.locationCityModel = self.locationCityModel;
    [self.navigationController pushViewController:location animated:YES];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _cityArray.count;
}
// 更改城市
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.titleCollectionView]) {
        
        CGFloat cityNum = self.titleCollectionView.contentOffset.x/self
        .titleCollectionView.frame.size.width;
        DBModel * model = [self.cityArray objectAtIndex:cityNum];

       if (![model.cityCC isEqualToString:self.nowCityModel.cityCC] && ![model.qwz isEqualToString:self.nowCityModel.qwz]){
            self.nowCityModel = model;
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            delegate.nowCity = self.nowCityModel;
            NSLog(@"准备请求");
#pragma wq
           // 更改城市前获取当前显示的是第几日的天气
           NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
//           BaseTableViewCell * cell = [self.table cellForRowAtIndexPath:indexPath1];
//           self.type = cell.type;
           BaseTableViewCell * cell = [self.table cellForRowAtIndexPath:indexPath1];
           NSInteger index = cell.collectionView.contentOffset.x / ScreenWidth ;
           self.type = index;
            [self handleData];
        }

    }else{
        [_refreshView refreshViewDidEndDragging:scrollView];
    }

}
#pragma mark - 通知
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (self.array.count>0) {
    NSIndexPath * cellIndexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    WeatherTableViewCell * cell = [self.table cellForRowAtIndexPath:cellIndexpath];
    cell.topScrollView.contentOffset = CGPointMake(indexPath.row * self.view.frame.size.width, 0);
    if (cell.array.count == 0) {
        cell.array = self.array;
    }
    _type = indexPath.row;
    [self changeBackgroundView:indexPath.row];
    NSIndexPath * downIndexpath = [NSIndexPath indexPathForRow:2 inSection:0];
    IndexTableViewCell *cell_down = [self.table cellForRowAtIndexPath:downIndexpath];
    [cell_down setWashcarWithIndex:indexPath.row];
    cell_down.index = indexPath.row;
    }
    else{

         BOOL isHostReach  = [ReachManager isReachable];
        if (isHostReach == 1) {

            UIAlertView *alert = nil;
            if ([JSNet hasRegister]){
                alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:NSLocalizedString(@"location services check", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
            }else{
                alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:NSLocalizedString(@"please pull down refresh data", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
            }
            [alert show];

        }else{
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            [delegate addRequestErrorView];
        }
    }

}
// 滑动上部每日天气,改变下部背景图片
-(void)setBackgroundViewToIndex:(NSNotification*)noti{

    NSDictionary *dic = noti.object;
    NSString *str = [dic objectForKey:@"endIndex"];
    int index = [str intValue];
    _type = index;
    NSIndexPath * downIndexpath = [NSIndexPath indexPathForRow:2 inSection:0];
    IndexTableViewCell *cell_down = [self.table cellForRowAtIndexPath:downIndexpath];
    [cell_down setWashcarWithIndex:index];
    cell_down.index = index;
    [self changeBackgroundView:index];
    WeekTableViewCell * weekCell = [self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    weekCell.type = index;
    if (index > 4) {
        weekCell.collectionView.contentOffset = CGPointMake(ScreenWidth, 0);
    }else{
        weekCell.collectionView.contentOffset = CGPointMake(0, 0);
    }
    [weekCell.collectionView reloadData];
}
// 改变下部背景图片
- (void)changeBackgroundView:(NSInteger)index{
    // 当刚刚滑动过日期的cell,即将改变下部背景时,滑动城市,重新请求天气数据,数组会空
    if (self.array.count == 0) {
        NSLog(@"下部图片变为空白");
        self.backgroumdView_down.image = nil;
        return;
    }
    WeatherModel * model = [self.array objectAtIndex:index];
    
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"day_weather" ofType:@"plist"];

    NSDictionary *dicPlist =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSDictionary * dictionary ;
//    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    if(1 == delegate.realtimeWeatherBackground){
//        dictionary = [dicPlist objectForKey:model.icon];
//    }else{
//        dictionary = [dicPlist objectForKey:model.mirror];
//    }
    //实时天气背景
    dictionary = [dicPlist objectForKey:model.mirror];
    self.backgroumdView_down.image = [UIImage imageNamed:[dictionary objectForKey:@"background_down"]];
}
#pragma mark  下面是刷新试图的代理方法
#pragma mark scrollView Delegate
//判断滚动方向向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
     if ([scrollView isEqual:self.table]) {
    [_refreshView refreshViewDidScroll:scrollView];

    if (scrollView.contentOffset.y < 0 ) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];

    }
    if (scrollView.contentOffset.y>=0 && _isRefreshing == NO) {

        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }

    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height) {

        scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.frame.size.height);
    }
     }
}

//松手的时候
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([scrollView isEqual:self.table]) {
        [_refreshView refreshViewDidEndDragging:scrollView];
    }
}

#pragma mark RefreshView Delegate
//下拉刷新的执行方法  如果上述两个监听的滚动高度小于-65(scrollView.contentOffset.y <= - 65.0f)则执行这个代理方法改变刷新状态(出现菊花图)
- (void)refreshViewDidTriggerRefresh:(RefreshPosition)refreshPosition{
    NSLog(@"这里触发执行刷新操作");
    _isRefreshing = YES;
    [self performSelector:@selector(refreshHandleData) withObject:nil afterDelay:0];
}

//滚动过程会不断调用这个方法监听是否改变刷新状态(即是否出现菊花图转的效果),实现原理中 需要这个变量去判断请求数据是否完成
- (BOOL)refreshViewDataIsLoading:(UIView *)view{
    return _isRefreshing;
}

//显示刷新时间
- (NSDate*)refreshViewDataLastUpdated{

    return [NSDate date];
}
-(void)refreshHandleData{
     BOOL isHostReach  = [ReachManager isReachable];
    _cacheDataManager = [[CacheDataManager alloc]initFile];
    self.type = 0;
    if (isHostReach) {
        [self handleWeatherAndAqi];
    }else{
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [delegate addRequestErrorView];
        [self handleLocalWeatherData];
    }
    //刷新完成后,应该让刷新视图调用下面的方法,来结束刷新,收起刷新提示条
    [_refreshView refreshViewDataSourceDidFinishedLoading:_table];
    _isRefreshing = NO;
}

-(void)setNavigationBarShow{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
