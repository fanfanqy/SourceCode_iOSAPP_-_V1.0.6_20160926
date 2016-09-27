//
//  IndexViewController.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/16.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "IndexViewController.h"
#import "DBModel.h"
#import "WeatherModel.h"
#import "IndexCollectionViewCell_down.h"

@interface IndexViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@end

@implementation IndexViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.array = [NSMutableArray array];
        
        self.otherArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setFlowLayout];
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
    
    [self setbackgroundImage];
}
- (void)handleSunTime:(NSInteger)index
{
    WeatherModel * model = [self.array objectAtIndex:index];
    if (index == 0) {
         self.nowtemp.text = [NSString stringWithFormat:@"%@°", model.nowtemp];
         NSLog(@"当天温度范围:%@%@",model.maxtemp,model.mintemp);
        self.pollution.image = [Help getImageWithAqi:self.aqi Icon:model.icon];
    }else{
        self.pollution.image = nil;        if ([model.maxtemp isEqualToString:@""]) {
            self.nowtemp.text = [NSString stringWithFormat:@"%@˚", model.mintemp];
        }else{
        self.nowtemp.text = [NSString stringWithFormat:@"%@/%@°", model.maxtemp,model.mintemp];
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
    self.info.text = [self.otherArray objectAtIndex:index];

}

- (void)setbackgroundImage
{
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
    
    CGRect frame = [UIScreen mainScreen].bounds;
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.view addSubview:backgroundImage];
    backgroundImage.image = self.image;
    [self.view sendSubviewToBack:backgroundImage];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
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
    self.info.text = [self.otherArray objectAtIndex:_indexpath];
    [self handleSunTime:_indexpath];
    
}
- (void)goBackViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareAction
{
    NSLog(@"分享给好友");
    UIImage *image = [Help captureView:self.view];
    NSArray *activityItems = [[NSArray alloc]initWithObjects:image, nil];
    UIActivityViewController *avc = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
    UIActivityViewControllerCompletionHandler myblock = ^(NSString *type,BOOL completed){
        NSLog(@"completed:%d type:%@",completed,type);
    };
    avc.completionHandler = myblock;
}
@end
