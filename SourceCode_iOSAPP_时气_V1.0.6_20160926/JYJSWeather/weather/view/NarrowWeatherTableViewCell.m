//
//  NarrowWeatherTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "NarrowWeatherTableViewCell.h"
#import "NarrowWeatherCollectionViewCell.h"
#import "WeatherInsidePagesVC.h"
#import "WeatherModel.h"
#import "DBModel.h"
@interface NarrowWeatherTableViewCell ()
{
    NSString * tomorrow;
    NSString * dayAfterTomorrow;
    NSMutableArray *_dateArray;
}
@end

@implementation NarrowWeatherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        tomorrow = @"明天";
        dayAfterTomorrow = @"后天";
        self.array = [NSMutableArray array];
        _dateArray = [self receiveDate];

        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flow];
        [self.contentView addSubview:self.collectionView];
         self.collectionView.backgroundColor = UIColorFromRGB(0xcccccc);
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        UINib *nib = [UINib nibWithNibName:@"NarrowWeatherCollectionViewCell" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"NARROWWEATHERCOLLECTIONCELL"];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.pagingEnabled = YES;
         self.collectionView.bounces = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;

        self.collectionView.frame = CGRectMake(0, 0, ScreenWidth, ModuleNarrowWeatherHeight);
        flow.sectionInset = UIEdgeInsetsMake(-1*GapHeight, 0, 0, 0);
        flow.itemSize = CGSizeMake(ScreenWidth, ModuleNarrowWeatherHeight-GapHeight);
        flow.minimumLineSpacing = 0;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setNarrowWeatherTableViewCellScrollToIndex:) name:@"CalendarTableViewCellEndDecelerating" object:nil];
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setNarrowWeatherTableViewCellScrollToIndex:) name:@"NarrowCalendarTableViewCellEndDecelerating" object:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

                if (self.type) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView scrollRectToVisible:CGRectMake(self.type * ScreenWidth,0,self.frame.size.width,self.frame.size.height) animated:NO];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [self.collectionView scrollRectToVisible:CGRectMake(0,0,self.frame.size.width,self.frame.size.height) animated:NO];
                    });
                }

     _dateArray = [self receiveDate];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.array.count == 0) {
        return 10;
    }
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NarrowWeatherCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NARROWWEATHERCOLLECTIONCELL" forIndexPath:indexPath];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *culture = delegate.languageCode;
    if (self.array.count > 0) {

    WeatherModel * model = [self.array objectAtIndex:indexPath.row];
    NSString * strBasePath =[[NSBundle mainBundle] pathForResource:@"day_weather" ofType:@"plist"];    NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
    NSDictionary * dictionary = [dic objectForKey:model.icon];
    cell.city.text = self.cityModel.cityCC;
    if ([model.maxtemp isEqualToString:@""]) {
        cell.max_mintemp.text = [NSString stringWithFormat:@"%@˚", model.mintemp];
    } else {
        cell.max_mintemp.text = [NSString stringWithFormat:@"%@/%@˚", model.maxtemp, model.mintemp];
        
    }
    if ([model.directionOfwind isEqualToString:@""]) {
        cell.windAndwet.text = [NSString stringWithFormat:@"无风|湿度%ld%%",(long)model.humidity];
        
    } else {
        cell.windAndwet.text = [NSString stringWithFormat:@"%@|湿度%ld%%",model.directionOfwind, (long)model.humidity];
    }
    cell.weather_txt.text = model.weather_txt;
    cell.icon_up.image = [UIImage imageNamed:[dictionary objectForKey:@"icon"]];
    // 是否有当前温度
    if (model.nowtemp) {
        cell.nowtemp.text = [NSString stringWithFormat:@"%@˚", model.nowtemp];
        cell.nowtemp.font = [UIFont fontWithName:CALENDARFONTKAITI size:52];
    }else{
        cell.nowtemp.text = [NSString stringWithFormat:@"%@/%@˚", model.maxtemp,model.mintemp];
        cell.nowtemp.font = [UIFont fontWithName:CALENDARFONTKAITI size:24];
    }
    // 改变下标题日期
    if (indexPath.row < self.array.count - 1) {
        WeatherModel * leftModel = [self.array objectAtIndex:(indexPath.row + 1)];
        if ([culture isEqualToString:@"zh"]) {
            cell.date_left.text = [NSString stringWithFormat:@"%ld月%ld日", leftModel.month, leftModel.day];
        }else{
            cell.date_left.text = [NSString stringWithFormat:@"%ld/%ld",leftModel.day, leftModel.month ];
        }

        cell.max_mintemp_left.text = [NSString stringWithFormat:@"%@/%@˚", leftModel.maxtemp, leftModel.mintemp];
        NSString * left_strBasePath =[[NSBundle mainBundle] pathForResource:@"day_weather" ofType:@"plist"];
        NSDictionary *left_dic =[NSDictionary dictionaryWithContentsOfFile:left_strBasePath];
        NSDictionary * left_dictionary = [left_dic objectForKey:leftModel.icon];
        cell.icon_dwn_left.image = [UIImage imageNamed:[left_dictionary objectForKey:@"icon"]];
        
    }else{
        cell.date_left.text = @"";
        cell.max_mintemp_left.text = @"";
        cell.icon_dwn_left.image = nil;
    }
    if (indexPath.row < self.array.count - 2) {
        WeatherModel * rightModel = [self.array objectAtIndex:(indexPath.row + 2)];
        if ([culture isEqualToString:@"zh"]) {
            cell.date_right.text = [NSString stringWithFormat:@"%ld月%ld日", rightModel.month, rightModel.day];
        }else{
            cell.date_right.text = [NSString stringWithFormat:@"%ld/%ld", rightModel.month, rightModel.day];
        }

        cell.max_mintemp_right.text = [NSString stringWithFormat:@"%@/%@˚", rightModel.maxtemp, rightModel.mintemp];
        
        NSString * right_strBasePath =[[NSBundle mainBundle] pathForResource:@"day_weather" ofType:@"plist"];
        NSDictionary *right_dic =[NSDictionary dictionaryWithContentsOfFile:right_strBasePath];
        NSDictionary * right_dictionary = [right_dic objectForKey:rightModel.icon];
        cell.icon_dwn_right.image = [UIImage imageNamed:[right_dictionary objectForKey:@"icon"]];
    }else{
        cell.date_right.text = @"";
        cell.max_mintemp_right.text = @"";
        cell.icon_dwn_right.image = nil;
    }
    // 明天,后天
        cell.pollution.image = nil;
        if (indexPath.row == 0) {
            cell.date_left.text = tomorrow;
            cell.date_right.text = dayAfterTomorrow;
            cell.pollution.image = [Help getImageWithAqi:self.aqi Icon:model.icon];
        }

    if (indexPath.row == 1) {
        cell.date_left.text = dayAfterTomorrow;
    }

    }else{
                            cell.city.text = self.cityModel.cityCC;
                            cell.nowtemp.text = @"-";
                            cell.icon_up.image = nil;
                            cell.weather_txt.text = @"--";
                            cell.max_mintemp.text = @"-/-˚";
                            cell.pollution.image = nil;
                            cell.windAndwet.text = @"-|湿度-%";
                            cell.icon_dwn_left.image = nil;
                            cell.icon_dwn_right.image = nil;
                            cell.max_mintemp_left.text = @"-/-˚";
                            cell.max_mintemp_right.text = @"-/-˚";
                            // 改变下标题日期
                            if (indexPath.row < 9){

                                NSString  *month = [_dateArray[indexPath.row+1] substringWithRange:NSMakeRange(4, 2)];
                                if ([[month substringWithRange:NSMakeRange(0, 1)] intValue]==0) {
                                    month = [month substringWithRange:NSMakeRange(1, 1)];
                                }
                                NSString *day = [_dateArray[indexPath.row+1] substringWithRange:NSMakeRange(6, 2)];
                                if ([[day substringWithRange:NSMakeRange(0, 1)] intValue]==0){
                                    day = [day substringWithRange:NSMakeRange(1, 1)];
                                }

                                if ([culture isEqualToString:@"zh"]) {
                                    cell.date_left.text = [NSString stringWithFormat:@"%d月%d日", [month intValue], [day intValue]];
                                }else{
                                    cell.date_left.text = [NSString stringWithFormat:@"%d/%d",[month intValue], [day intValue] ];
                                }
                            }else{
                                cell.date_left.text = @"";
                                cell.max_mintemp_left.text = @"";
                                cell.icon_dwn_left.image = nil;

                            }

                            if (indexPath.row < 8){

                                NSString  *month = [_dateArray[indexPath.row + 2] substringWithRange:NSMakeRange(4, 2)];
                                if ([[month substringWithRange:NSMakeRange(0, 1)] intValue]==0) {
                                    month = [month substringWithRange:NSMakeRange(1, 1)];
                                }
                                NSString *day = [_dateArray[indexPath.row + 2] substringWithRange:NSMakeRange(6, 2)];
                                if ([[day substringWithRange:NSMakeRange(0, 1)] intValue]==0){
                                    day = [day substringWithRange:NSMakeRange(1, 1)];
                                }
                                if ([culture isEqualToString:@"zh"]) {
                                    cell.date_right.text = [NSString stringWithFormat:@"%d月%d日", [month intValue], [day intValue]];
                                }else{
                                    cell.date_right.text = [NSString stringWithFormat:@"%d/%d",[month intValue], [day intValue] ];
                                }
                            }else{
                                cell.date_right.text = @"";
                                cell.max_mintemp_right.text = @"";
                                cell.icon_dwn_right.image = nil;
                            }

                            if (indexPath.row == 0) {
                                cell.date_left.text = tomorrow;
                                cell.date_right.text = dayAfterTomorrow;

                            }

                            if (indexPath.row == 1) {
                                cell.date_left.text = dayAfterTomorrow;
                            }


    }
    return cell;
}
-(NSMutableArray *)receiveDate{
    NSString  *year = [Datetime GetYear];
    NSString  *month =  [Datetime GetMonth];
    NSString *day = [Datetime GetDay];
    if ([[month substringWithRange:NSMakeRange(0, 1)] intValue]==0) {
        month = [month substringWithRange:NSMakeRange(1, 1)];
    }
    if ([[day substringWithRange:NSMakeRange(0, 1)] intValue]==0){
        day = [day substringWithRange:NSMakeRange(1, 1)];
    }
    return  [Datetime  GetTenDaysInFutureByYear:[year intValue] andByMonth:[month intValue] andByDay:[day intValue] andCount:10];

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeatherInsidePagesVC * weatherInsidePagesVC = [[WeatherInsidePagesVC alloc]init];
    weatherInsidePagesVC.array = self.array;


    if (self.array.count == 0 ) {
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

    }else{
    weatherInsidePagesVC.type = indexPath.row;
   
    weatherInsidePagesVC.aqi = self.aqi;
    weatherInsidePagesVC.cityArray = self.otherArray;
    weatherInsidePagesVC.nowCityModel = self.cityModel;
    weatherInsidePagesVC.locationCityModel = self.locationCityModel;
    [self.viewControllerDelegate.navigationController pushViewController:weatherInsidePagesVC animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if ([scrollView isEqual:self.collectionView]) {
        NSInteger index = self.collectionView.contentOffset.x / ScreenWidth ;
        NSMutableDictionary * mdic = [[NSMutableDictionary alloc]init];
        [mdic setObject:[NSString stringWithFormat:@"%lu",index] forKey:@"endIndex"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NarrowWeatherTableViewCellEndDecelerating" object:mdic userInfo:nil];
    }
}

-(void)setNarrowWeatherTableViewCellScrollToIndex:(NSNotification*)noti{
    NSDictionary *dic = noti.object;
    NSString *str = [dic objectForKey:@"endIndex"];
    
    int   YearCurrent = [[Datetime GetYear] intValue];
    int   MonthCurrent = [[Datetime GetMonth] intValue];
    int   DayCurrent = [[Datetime GetDay] intValue];
    int index1 = [Datetime GetOneDayIndexInOneYear:YearCurrent andMonth:MonthCurrent andDay: DayCurrent];
    [self.collectionView setContentOffset:CGPointMake(([str intValue]-index1+1)*ScreenWidth, 0) animated:YES];
    NSInteger index = self.collectionView.contentOffset.x / ScreenWidth ;
    self.type = index;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CalendarTableViewCellEndDecelerating" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NarrowCalendarTableViewCellEndDecelerating" object:nil];
}
@end
