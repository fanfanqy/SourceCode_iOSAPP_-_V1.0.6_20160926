//
//  WeatherTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "WeatherTableViewCell.h"
#import "AppDelegate.h"
#import "WeatherModel.h"
#import "RootViewController.h"
#import "WeatherInsidePagesVC.h"
#import "WeatherCollectionViewCell.h"

@interface WeatherTableViewCell ()<UIWebViewDelegate>
@end

@implementation WeatherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         self.backgroundColor = UIColorFromRGB(0xcccccc);
        self.array = [NSMutableArray array];
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flow];
        
        [self.contentView addSubview:self.collectionView];
        self.collectionView.backgroundColor = UIColorFromRGB(0xcccccc);
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.bounces = NO;
        [self.collectionView registerClass:[WeatherCollectionViewCell class]  forCellWithReuseIdentifier:@"WEATHERCOLLECTIONCELL"];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setNarrowWeatherTableViewCellScrollToIndex:) name:@"CalendarTableViewCellEndDecelerating" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setNarrowWeatherTableViewCellScrollToIndex:) name:@"NarrowCalendarTableViewCellEndDecelerating" object:nil];
        self.collectionView.scrollEnabled = NO;
        self.topScrollView = [[UIScrollView alloc]init];
        [self.contentView addSubview:self.topScrollView];
        self.topScrollView.pagingEnabled = YES;
        self.topScrollView.delegate = self;
        self.topScrollView.bounces = NO;
        
        self.collectionView.frame = CGRectMake(- ScreenWidth, 0, ScreenWidth * 3, ModuleWeatherHeight);
        
        flow.minimumLineSpacing = 0;
        self.topScrollView.frame = CGRectMake(0, 0, ScreenWidth, ModuleWeatherHeight);
        self.topScrollView.contentSize = CGSizeMake(ScreenWidth * 10, ModuleWeatherHeight);
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    

    UICollectionViewFlowLayout * flow = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if ([self.viewControllerDelegate isKindOfClass:[RootViewController class]]) {
            flow.sectionInset = UIEdgeInsetsMake(-1*GapHeight, 0, 0, 0);
            flow.itemSize = CGSizeMake(ScreenWidth, ModuleWeatherHeight -GapHeight);
    }else{
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flow.itemSize = CGSizeMake(ScreenWidth, ModuleWeatherHeight);
    }


            if (self.type) {
                dispatch_async(dispatch_get_main_queue(), ^{
                     self.topScrollView.contentOffset = CGPointMake(self.type * ScreenWidth, 0);
                });
                  

            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                     self.topScrollView.contentOffset = CGPointMake(0, 0);
                    [self.collectionView scrollRectToVisible:CGRectMake(0,0,self.frame.size.width,self.frame.size.height) animated:NO];

                });

            }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if (self.array.count > 0) {
        return self.array.count + 2;
    } else {
        return 0;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    WeatherCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WEATHERCOLLECTIONCELL" forIndexPath:indexPath];
    
        if (indexPath.row == 0 || indexPath.row == self.array.count + 1) {
            WeatherModel * model = nil;
            if (indexPath.row == 0) {
                model = [self.array objectAtIndex:0];
            } else {
                model = [self.array objectAtIndex:self.array.count - 1];
            }
            NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"day_weather" ofType:@"plist"];
            NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
             NSDictionary * dictionary = [dic objectForKey:[self getmirror:model]];
            // 获取当前应用的根目录
            NSString *path = [[NSBundle mainBundle] bundlePath];
            NSURL *baseURL = [NSURL fileURLWithPath:path];
            // 通过baseURL的方式加载的HTML
            // 可以在HTML内通过相对目录的方式加载js,css,img等文件
            NSString *html = [self getHtmlWithString:[dictionary objectForKey:@"background"]];
            cell.backgroundWebView.userInteractionEnabled=NO;
            [cell.backgroundWebView loadHTMLString:html baseURL:baseURL];
            return cell;
        } else {
            if (self.array.count > 0) {
                    WeatherModel * model = [self.array objectAtIndex:indexPath.row-1];
                    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"day_weather" ofType:@"plist"];
                    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
                    NSDictionary * dictionary = [dic objectForKey:[self getmirror:model]];                    // 获取当前应用的根目录
                    NSString *path = [[NSBundle mainBundle] bundlePath];
                    NSURL *baseURL = [NSURL fileURLWithPath:path];
                    // 通过baseURL的方式加载的HTML
                    // 可以在HTML内通过相对目录的方式加载js,css,img等文件
                    NSString *html = [self getHtmlWithString:[dictionary objectForKey:@"background"]];
                    cell.backgroundWebView.userInteractionEnabled=NO;
                    [cell.backgroundWebView loadHTMLString:html baseURL:baseURL];
                    cell.mirror.image = [UIImage imageNamed:[dictionary objectForKey:@"mirror"]];
                    cell.person.image = [UIImage imageNamed:[dictionary objectForKey:@"person"]];
                    if ([model.maxtemp isEqualToString:@""]) {
                        cell.max_mintemp.text = [NSString stringWithFormat:@"-/%@˚", model.mintemp];
                    } else {
                        cell.max_mintemp.text = [NSString stringWithFormat:@"%@/%@˚", model.maxtemp, model.mintemp];
                    }
                    cell.week.text = model.week;
                    cell.date.text = [NSString stringWithFormat:@"%ld月%ld日", model.month, model.day];
                    cell.weather_txt.text = model.weather_txt;
                    if (indexPath.row == 1) {
                        if (model.nowtemp) {
                            cell.nowtemp.text = [NSString stringWithFormat:@"%@˚", model.nowtemp];
                            
                        }else{
                            cell.nowtemp.text = [NSString stringWithFormat:@"%@/%@˚", model.maxtemp, model.mintemp];
                        }
                        cell.pollution.image = [Help getImageWithAqi:self.aqi Icon:model.icon];
                    } else {
                        cell.pollution.image = nil;
                        cell.nowtemp.text = @"";
                    }
            }else{

            }
            cell.backgroundWebView.delegate = self;
        }
        return cell;
}
- (NSString *)getmirror:(WeatherModel *)model{
//    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    if(1 == delegate.realtimeWeatherBackground){
//        
//        return model.icon;
//    }else{
//        return model.mirror;
//    }
    return model.mirror;
}
- (NSString *)getHtmlWithString:(NSString *)imageName{
    // 可以在HTML内通过相对目录的方式加载js,css,img等文件
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendString:@"<style type=\"text/css\">"];
    [html appendString:@"* {margin:0;padding:0}"];
    [html appendString:@"</style>"];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    double imageHeightScale = (ModuleWeatherHeight/ScreenWidth)>1.4625?(ModuleWeatherHeight/ScreenWidth):1.4625;
    NSString *str = [NSString stringWithFormat:@"<img src =\"%@\" width=\"%f\"  height=\"%f\">", imageName,ScreenWidth,imageHeightScale*ScreenWidth];
    [html appendString: str];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    return html;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"%s",__func__);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
     NSLog(@"%s",__func__);
}
- (void)tapAction{

    if ([self.viewControllerDelegate isKindOfClass:[RootViewController class]]) {
        if (self.array.count > 0) {
            WeatherInsidePagesVC * weatherInsidePagesVC = [[WeatherInsidePagesVC alloc]init];
            weatherInsidePagesVC.array = self.array;
            weatherInsidePagesVC.cityArray = self.otherArray;
            weatherInsidePagesVC.locationCityModel = self.locationCityModel;
            weatherInsidePagesVC.nowCityModel = self.cityModel;
            weatherInsidePagesVC.aqi = self.aqi;
            weatherInsidePagesVC.type = self.type;
            
            [self.viewControllerDelegate.navigationController pushViewController:weatherInsidePagesVC animated:YES];
        }
    }

    if (self.array.count == 0) {
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
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.topScrollView]) {
        NSInteger index = self.topScrollView.contentOffset.x / ScreenWidth ;
        self.type = index;
        NSMutableDictionary * mdic = [[NSMutableDictionary alloc]init];
        [mdic setObject:[NSString stringWithFormat:@"%lu",index] forKey:@"endIndex"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"WeatherTableViewCellEndDecelerating" object:mdic userInfo:nil];
    }
}

-(void)setNarrowWeatherTableViewCellScrollToIndex:(NSNotification*)noti{
    NSDictionary *dic = noti.object;
    NSString *str = [dic objectForKey:@"endIndex"];
    int   YearCurrent = [[Datetime GetYear] intValue];
    int   MonthCurrent = [[Datetime GetMonth] intValue];
    int   DayCurrent = [[Datetime GetDay] intValue];
    int index1 = [Datetime GetOneDayIndexInOneYear:YearCurrent andMonth:MonthCurrent andDay: DayCurrent];
    [self.topScrollView setContentOffset:CGPointMake(([str intValue]-index1+1)*ScreenWidth, 0) animated:YES];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.topScrollView]) {
        self.collectionView.contentOffset = self.topScrollView.contentOffset;
        NSInteger index = self.topScrollView.contentOffset.x / ScreenWidth ;
        self.type = index;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CalendarTableViewCellEndDecelerating" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NarrowCalendarTableViewCellEndDecelerating" object:nil];
    
}
@end
