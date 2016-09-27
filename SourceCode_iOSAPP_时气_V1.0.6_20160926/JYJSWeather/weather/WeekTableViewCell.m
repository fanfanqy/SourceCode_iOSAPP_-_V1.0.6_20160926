//
//  WeekTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "WeekTableViewCell.h"
#import "WeekCollectionCell.h"
#import "WeatherModel.h"
#import "AppDelegate.h"

@implementation WeekTableViewCell
{
    NSArray *_weekArray;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.array = [NSMutableArray array];
        _weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flow];
        [self.contentView addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        UINib *nib = [UINib nibWithNibName:@"WeekCollectionCell" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"WEEKCOLLECTIONCELL"];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.pagingEnabled = NO;
        self.collectionView.bounces = NO;


    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
     _weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
//    CGRect fream = [UIScreen mainScreen].bounds;
    self.collectionView.frame = CGRectMake(0, 0, ScreenWidth, self.contentView.frame.size.height);
    UICollectionViewFlowLayout *ff  = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    ff.itemSize = CGSizeMake(self.collectionView.frame.size.width/5, self.collectionView.frame.size.height);
    ff.minimumLineSpacing = 0;
    self.collectionView.contentSize = CGSizeMake(2 * ScreenWidth, self.collectionView.frame.size.height);
    if (self.type > 4) {
        self.collectionView.contentOffset = CGPointMake(ScreenWidth, 0);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.array.count==0) {
        return 10;
    }
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeekCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WEEKCOLLECTIONCELL" forIndexPath:indexPath];
    if (self.array.count > 0) {
        WeatherModel * model = [self.array objectAtIndex:indexPath.row];
        if ([model.maxtemp isEqualToString:@""]) {
            cell.maxtemp.text = [NSString stringWithFormat:@"%@˚", model.nowtemp];
        } else {
            
            cell.maxtemp.text = [NSString stringWithFormat:@"%@˚", model.maxtemp];
        }

        if ([model.directionOfwind isEqualToString:@""]) {
            cell.directionOfwind.text = @"无风";
            cell.sizeOfwind.text = @"0级";
        } else {
        
        cell.directionOfwind.text = model.directionOfwind;
        cell.sizeOfwind.text = [NSString stringWithFormat:@"%ld级",(long)model.wind];
        }
    
        cell.mintemp.text = [NSString stringWithFormat:@"%@˚", model.mintemp];
        cell.week.text = model.week;
        cell.date.text = [NSString stringWithFormat:@"%ld/%ld", model.month, model.day];
            
        [cell.weather_txt setVerticalAlignment:VerticalAlignmentTop];
        cell.weather_txt.text = model.weather_txt;

        NSString * strBasePath = [[NSBundle mainBundle] pathForResource:@"day_weather" ofType:@"plist"];
        NSDictionary *dic =[NSDictionary dictionaryWithContentsOfFile:strBasePath];
        NSDictionary * dictionary = [dic objectForKey:model.icon];
        cell.weather_image.image = [UIImage imageNamed:[dictionary objectForKey:@"icon"]];
    }else{
        NSMutableArray *arrayDate = [self receiveDate];
        NSString *year = [arrayDate[indexPath.row] substringWithRange:NSMakeRange(0, 4)];
        NSString  *month = [arrayDate[indexPath.row] substringWithRange:NSMakeRange(4, 2)];
        if ([[month substringWithRange:NSMakeRange(0, 1)] intValue]==0) {
            month = [month substringWithRange:NSMakeRange(1, 1)];
        }
        NSString *day = [arrayDate[indexPath.row] substringWithRange:NSMakeRange(6, 2)];
        if ([[day substringWithRange:NSMakeRange(0, 1)] intValue]==0){
            day = [day substringWithRange:NSMakeRange(1, 1)];
        }
        cell.date.text = [NSString stringWithFormat:@"%d/%d", [month intValue], [day intValue]];
        int i = [Datetime GetTheWeekOfDayByYera:[year intValue] andByMonth:[month intValue] andByDay:[day intValue]];
        cell.week.text = [NSString stringWithFormat:@"星期%@", _weekArray[i]];
         cell.maxtemp.text = @"-";
        cell.weather_image.image = nil;
        cell.weather_txt.text = @"-";
        cell.maxtemp.text = @"-˚";
        cell.mintemp.text = @"-˚";
        cell.directionOfwind.text = @"-";
        cell.sizeOfwind.text = @"-";
        cell.pollution.image = nil;

    }

    if (indexPath.row == self.type) {
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    } else {
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row == 0 && self.aqi != 0) {
        WeatherModel * model = [self.array objectAtIndex:indexPath.row];
        cell.pollution.image = [Help getImageWithAqi:self.aqi Icon:model.icon];    }else{
        cell.pollution.image = nil;
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
    self.type = indexPath.row;
    for (WeekCollectionCell * cell in collectionView.visibleCells) {
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    WeekCollectionCell * cell = (WeekCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    [self.delegate didSelectItemAtIndexPath:indexPath];


}
@end
