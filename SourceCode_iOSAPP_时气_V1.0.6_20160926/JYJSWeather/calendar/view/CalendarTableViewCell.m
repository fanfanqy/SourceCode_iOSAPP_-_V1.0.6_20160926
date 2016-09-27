//
//  CalendarTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "CalendarTableViewCell.h"
#import "CalendarCollectionViewCell.h"
#import "CalendarViewController1.h"
#import "CalendarMainPagesModel.h"
#import "CalendarModel.h"

@implementation CalendarTableViewCell
{
    CalendarMainPagesModel *calendarMainPagesModel;
    BOOL    isInit;

    CalendarModel *calendarModel;
    NSMutableArray *_arrayYi;
   NSMutableArray *_arrayJi;
    int labelIndexYi;
    int labelIndexJi;
    CalendarCollectionViewCell * cell;
    int  YearScroll;
     BOOL isPre ;
     BOOL isClickCell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.array = [NSMutableArray array];
        _arrayYi = [NSMutableArray array];
        _arrayJi = [NSMutableArray array];
        labelIndexYi = 0;
        labelIndexJi = 0;
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flow];
        [self.contentView addSubview:self.collectionView];
        self.collectionView.backgroundColor = UIColorFromRGB(0xcccccc);
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        UINib *nib = [UINib nibWithNibName:@"CalendarCollectionViewCell" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"CALENDARCOLLECTIONVIEWCELL"];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView.frame = CGRectMake(0, 0, ScreenWidth, ModuleCalendarHeight);

        flow.sectionInset = UIEdgeInsetsMake(-1*GapHeight, 0, 0, 0);
        flow.itemSize = CGSizeMake(ScreenWidth, ModuleCalendarHeight -GapHeight);
        flow.minimumLineSpacing = 0;
        
        self.collectionView.pagingEnabled = YES;
        isInit = YES;
       
//        [self receiveCurrentData];

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setCalendarTableViewCellScrollToIndex:) name:@"WeatherTableViewCellEndDecelerating" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setCalendarTableViewCellScrollToIndex:) name:@"NarrowWeatherTableViewCellEndDecelerating" object:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.delegate = (id)self.viewControllerDelegate;

            if (self.type) {
                    //天气内页选择日期返回时候的判断
                    int   YearCurrent = [[Datetime GetYear] intValue];
                    int   MonthCurrent = [[Datetime GetMonth] intValue];
                    int   DayCurrent = [[Datetime GetDay] intValue];
                    int index1 = [Datetime GetOneDayIndexInOneYear:YearCurrent andMonth:MonthCurrent andDay:DayCurrent];
                    [self.collectionView setContentOffset:CGPointMake((index1-1+ self.type)*ScreenWidth, 0) animated:NO];
                    
            }else{

                        if (self.isRefresh) {
                            [self receiveCurrentData];
                            
                        }else{
                            if (isInit) {
                                int   YearCurrent = [[Datetime GetYear] intValue];
                                int   MonthCurrent = [[Datetime GetMonth] intValue];
                                int   DayCurrent = [[Datetime GetDay] intValue];
                                int   index1 = [Datetime GetOneDayIndexInOneYear:YearCurrent andMonth:MonthCurrent andDay:DayCurrent];
                                
                                calendarModel = self.array[index1-1];
                                NSString *str = calendarModel.solarStr;
                                NSString *strYear = [str substringWithRange:NSMakeRange(0, 4)];
                                YearScroll = [strYear intValue];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.collectionView scrollRectToVisible:CGRectMake((index1-1)*self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];
                                });

                            }
                            else{
                                int   YearCurrent = [[Datetime GetYear] intValue];
                                int   MonthCurrent = [[Datetime GetMonth] intValue];
                                int   DayCurrent = [[Datetime GetDay] intValue];
                                int index1 = [Datetime GetOneDayIndexInOneYear:YearScroll andMonth:MonthCurrent andDay:DayCurrent];

                            //再次判断今天是不是在这里的对象,如果是,才滚动到 ((index1-1)*width,0)
                                calendarModel = self.array[index1-1];
                                NSString *str = calendarModel.solarStr;
                                NSString *strYear = [str substringWithRange:NSMakeRange(0, 4)];
                                NSString *strMonth = [str substringWithRange:NSMakeRange(4, 2)];
                                NSString *strDay = [str substringWithRange:NSMakeRange(6, 2)];
                                if ([[strMonth substringWithRange:NSMakeRange(0, 1)] intValue]==0) {
                                    strMonth = [strMonth substringWithRange:NSMakeRange(1, 1)];
                                }
                                if ([[strDay substringWithRange:NSMakeRange(0, 1)] intValue]==0){
                                    strDay = [strDay substringWithRange:NSMakeRange(1, 1)];
                                }

                                if ([strYear intValue]==YearCurrent && [strMonth intValue]==MonthCurrent && [strDay intValue]==DayCurrent){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.collectionView scrollRectToVisible:CGRectMake((index1-1)*self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];
                                });

                                }
                            }
                        }

            }

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.countRows;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CALENDARCOLLECTIONVIEWCELL" forIndexPath:indexPath];

    calendarModel          = [[CalendarModel alloc]init];
    if (self.array.count > 0) {
    calendarModel = self.array[indexPath.row];


    NSString *str = calendarModel.solarStr;
    NSString *str1 = [str substringWithRange:NSMakeRange(0, 4)];
    NSString *str2 = [str substringWithRange:NSMakeRange(4, 2)];
    NSString *str3 = [str substringWithRange:NSMakeRange(6, 2)];
    if ([[str2 substringWithRange:NSMakeRange(0, 1)] intValue]==0) {
        str2 = [str2 substringWithRange:NSMakeRange(1, 1)];
    }
    if ([[str3 substringWithRange:NSMakeRange(0, 1)] intValue]==0){
        str3 = [str3 substringWithRange:NSMakeRange(1, 1)];
    }
    if (calendarModel) {
    cell.right_up_image.image = [UIImage imageNamed:calendarModel.luckyImageType];

        //当前语言code判断
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        NSString *culture = delegate.languageCode;

        if ([culture isEqualToString:@"zh"]) {
               cell.date.text = [NSString stringWithFormat:@"%@年%@月%@日",str1,str2,str3];
        }else{
            cell.date.text = [NSString stringWithFormat:@"%@/%@/%@",str3,str2,str1];
        }
   

    cell.lunarCalendar.text =calendarModel.lunarStr;

    //纪年换成剪指甲,下面的节日换成纪年
    /*
        if (calendarModel.hairWashArray.count > 0) {
                cell.goodOccasion.text = calendarModel.hairWashArray[indexPath.row];
        }else{
                cell.goodOccasion.text = @"剪指甲 洗头";
        }
     */
    if (calendarModel.hairWashArray.count > 0) {
        NSString *hairWashObj = calendarModel.hairWashArray[indexPath.row];
        if ([hairWashObj isEqualToString:@"吉"]) {
            //纪年位置放洗发
            cell.goodOccasion.text = @"吉   剪指甲,洗头";
        }else if ([hairWashObj isEqualToString:@"凶"]) {
            //纪年位置放洗发
            cell.goodOccasion.text = @"凶   剪指甲,洗头";
        }else{
            cell.goodOccasion.text = hairWashObj;
        }
    }else{
        cell.goodOccasion.text = @"剪指甲,洗头";
    }


    cell.week.text = calendarModel.weekStr;
    if (calendarModel.HaircutStrArray.count > 0) {
            cell.haircut.text = [NSString  stringWithFormat:@"理发 %@",calendarModel.HaircutStrArray[indexPath.row]];
    }else{
            cell.haircut.text = @"理发";
    }


    //宜忌
        //宜
        NSString *yi = calendarModel.YiStrArray[indexPath.row];
        _arrayYi = [Help getArrayWithContent:yi andCount:0  andIsNarrow:NO];

        labelIndexYi = 0;
        cell.approprite.text =  _arrayYi[0];
        cell.approprite.numberOfLines = 0;
        if (_arrayYi.count > 1) {
            cell.YiImageView.hidden = NO;
        }else{
            cell.YiImageView.hidden = YES;
        }

        //忌
        NSString *ji = calendarModel.JiStrArray[indexPath.row];
        _arrayJi = [Help getArrayWithContent:ji andCount:0  andIsNarrow:NO];

        labelIndexJi = 0;

        if (_arrayJi.count > 1) {
            cell.JiImageView.hidden = NO;
        }else{
            cell.JiImageView.hidden = YES;
        }
        cell.avoid.text = _arrayJi[0];
        cell.avoid.numberOfLines = 0;
        [self addTap];
    //节日换成纪年
    cell.memorialDay.text = calendarModel.JiNianStr;
    cell.collision.text = [NSString stringWithFormat:@"{%@}",calendarModel.ChongAnimalStr];
    cell.goodTime.text = calendarModel.LuckyhourStr;
    cell.fierceTime.text = calendarModel.badhouStr;
        
    }else{
        cell.right_up_image.image = [UIImage imageNamed:@""];
        cell.date.text = @"";
        cell.lunarCalendar.text = @"";
        cell.goodOccasion.text =  @"";
        cell.haircut.text =  @"";
        cell.approprite.text =  @"";
        cell.avoid.text =  @"";
        cell.memorialDay.text =  @"";
        cell.collision.text =  @"";
        cell.goodTime.text =  @"";
        cell.fierceTime.text =  @"";
    }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarViewController1 *calendarVC = [[CalendarViewController1 alloc]init];
    calendarModel          = [[CalendarModel alloc]init];
    if (self.array.count > 0) {
        calendarModel = self.array[indexPath.row];

        NSString *str = calendarModel.solarStr;
        NSString *str1 = [str substringWithRange:NSMakeRange(0, 4)];
        NSString *str2 = [str substringWithRange:NSMakeRange(4, 2)];
        NSString *str3 = [str substringWithRange:NSMakeRange(6, 2)];
        if ([[str2 substringWithRange:NSMakeRange(0, 1)] intValue]==0) {
            str2 = [str2 substringWithRange:NSMakeRange(1, 1)];
        }
        if ([[str3 substringWithRange:NSMakeRange(0, 1)] intValue]==0){
            str3 = [str3 substringWithRange:NSMakeRange(1, 1)];
        }
    calendarVC.strYearMain = [str1 intValue];
    calendarVC.strMonthMain = [str2 intValue];
    calendarVC.strDayMain = [str3 intValue];
    }
    
    [self.viewControllerDelegate.navigationController pushViewController:calendarVC animated:YES];
}

-(void)setCalendarTableViewCellScrollToIndex:(NSNotification*)noti{


    int   YearCurrent = [[Datetime GetYear] intValue];
    int   MonthCurrent = [[Datetime GetMonth] intValue];
    int   DayCurrent = [[Datetime GetDay] intValue];
    int index1 = [Datetime GetOneDayIndexInOneYear:YearCurrent andMonth:MonthCurrent andDay:DayCurrent];
    if (self.array.count>0) {
        calendarModel =  self.array[index1-1];
        NSString *str = calendarModel.solarStr;
        NSString *strYear = [str substringWithRange:NSMakeRange(0, 4)];
        NSString *strMonth = [str substringWithRange:NSMakeRange(4, 2)];
        NSString *strDay = [str substringWithRange:NSMakeRange(6, 2)];
        if ([[strMonth substringWithRange:NSMakeRange(0, 1)] intValue]==0) {
            strMonth = [strMonth substringWithRange:NSMakeRange(1, 1)];
        }
        if ([[strDay substringWithRange:NSMakeRange(0, 1)] intValue]==0){
            strDay = [strDay substringWithRange:NSMakeRange(1, 1)];
        }

        NSDictionary *dic = noti.object;
        int index =  [[dic objectForKey:@"endIndex"] intValue];

        if ([strYear intValue]==YearCurrent && [strMonth intValue]==MonthCurrent && [strDay intValue]==DayCurrent && index<=9 && index>=0) {
            [self.collectionView setContentOffset:CGPointMake((index1-1+index)*ScreenWidth, 0) animated:YES];

        }else{
            [self receiveCurrentData];
            [self.collectionView setContentOffset:CGPointMake((index1-1)*ScreenWidth, 0) animated:YES];
            
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    if ([scrollView isEqual:self.collectionView]) {
// scrollView.frame.size.width / (3),减去的这个内容,不能超过  scrollView.frame.size.width的一半
        int index = floor((scrollView.contentOffset.x - scrollView.frame.size.width / (3)) / scrollView.frame.size.width) +1 ;

        int   YearCurrent = [[Datetime GetYear] intValue];
        int   MonthCurrent = [[Datetime GetMonth] intValue];
        int   DayCurrent = [[Datetime GetDay] intValue];

        int index1 = [Datetime GetOneDayIndexInOneYear:YearCurrent andMonth:MonthCurrent andDay:DayCurrent];
        int countDay = [Datetime GetOneYearCountDay:YearScroll];


        calendarModel = self.array[index1-1];
        NSString *str = calendarModel.solarStr;
        NSString *strYear = [str substringWithRange:NSMakeRange(0, 4)];
        NSString *strMonth = [str substringWithRange:NSMakeRange(4, 2)];
        NSString *strDay = [str substringWithRange:NSMakeRange(6, 2)];
        if ([[strMonth substringWithRange:NSMakeRange(0, 1)] intValue]==0) {
            strMonth = [strMonth substringWithRange:NSMakeRange(1, 1)];
        }
        if ([[strDay substringWithRange:NSMakeRange(0, 1)] intValue]==0){
            strDay = [strDay substringWithRange:NSMakeRange(1, 1)];
        }

        YearScroll = [strYear intValue];

        if ([strYear intValue]==YearCurrent && [strMonth intValue]==MonthCurrent && [strDay intValue]==DayCurrent && index<index1+9 && index>=index1-1) {
            NSMutableDictionary * mdic = [[NSMutableDictionary alloc]init];
            [mdic setObject:[NSString stringWithFormat:@"%d",index] forKey:@"endIndex"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"CalendarTableViewCellEndDecelerating" object:mdic userInfo:nil];
        }else {
            if (index<index1-1 ) {
                NSMutableDictionary * mdic = [[NSMutableDictionary alloc]init];
                [mdic setObject:[NSString stringWithFormat:@"%d",index1-1] forKey:@"endIndex"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"CalendarTableViewCellEndDecelerating" object:mdic userInfo:nil];
            }else if(index>=index1+9){
                NSMutableDictionary * mdic = [[NSMutableDictionary alloc]init];
                [mdic setObject:[NSString stringWithFormat:@"%d",index1+9-1] forKey:@"endIndex"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"CalendarTableViewCellEndDecelerating" object:mdic userInfo:nil];
            }

        }

        if (index==0) {
            //go last but 1 page
            [self receiveBeforeData];
        } else if (index==countDay-1) { //如果是最后+1,也就是要开始循环的第一个
            [self receiveFutureData];
        }
    }
}


-(void)receiveBeforeData{


    int countDay = [Datetime GetOneYearCountDay:(YearScroll-1)];

    [self.array removeAllObjects];
    calendarMainPagesModel = [[CalendarMainPagesModel alloc]initWithReceiveData:countDay andYear:YearScroll-1];
    calendarMainPagesModel = [[CalendarMainPagesModel alloc]initWithReceiveData:countDay andYear:YearScroll-1];
    self.array = [calendarMainPagesModel readDataFromDB];

    if ([_delegate respondsToSelector:@selector(reloadCalendarTableViewCell:)]) {
        isInit = NO;
        [_delegate reloadCalendarTableViewCell:self.array];
    }

    [self.collectionView scrollRectToVisible:CGRectMake(self.frame.size.width * (countDay-2),0,self.frame.size.width,self.frame.size.height) animated:NO];
}


-(void)receiveFutureData{

    int countDay = [Datetime GetOneYearCountDay:(YearScroll+1)];
    [self.array removeAllObjects];
    calendarMainPagesModel = [[CalendarMainPagesModel alloc]initWithReceiveData:countDay andYear:YearScroll+1];
    self.array = [calendarMainPagesModel readDataFromDB];

    if ([_delegate respondsToSelector:@selector(reloadCalendarTableViewCell:)]) {
        isInit = NO;
        [_delegate reloadCalendarTableViewCell:self.array];
    }

    [self.collectionView scrollRectToVisible:CGRectMake(self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];

}


-(void)receiveCurrentData{

    int   YearCurrent = [[Datetime GetYear] intValue];
    int   MonthCurrent = [[Datetime GetMonth] intValue];
    int   DayCurrent = [[Datetime GetDay] intValue];
    int index1 = [Datetime GetOneDayIndexInOneYear:YearCurrent andMonth:MonthCurrent andDay:DayCurrent];
    int countDay = [Datetime GetOneYearCountDay:YearCurrent];

    YearScroll = YearCurrent;
   
    calendarMainPagesModel = [[CalendarMainPagesModel alloc]initWithReceiveData:countDay andYear:YearCurrent];
    self.array = [calendarMainPagesModel readDataFromDB];

    if ([_delegate respondsToSelector:@selector(reloadCalendarTableViewCell:)]) {
        isInit = YES;
        [_delegate reloadCalendarTableViewCell:self.array];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView scrollRectToVisible:CGRectMake((index1-1)*self.frame.size.width,0,self.frame.size.width,self.frame.size.height) animated:NO];
    });
}


-(void)addTap{
    UITapGestureRecognizer *tapYi = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapYi)];
    cell.YiImageView.userInteractionEnabled = YES;
      cell.YiImageView.image = [UIImage imageNamed:@"next_white"];
    [cell.YiImageView addGestureRecognizer:tapYi];


    UITapGestureRecognizer *tapJi = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapJi)];
    cell.YiImageView.image = [UIImage imageNamed:@"next_white"];
    cell.JiImageView.userInteractionEnabled = YES;
    [cell.JiImageView addGestureRecognizer:tapJi];
    isPre = YES;
}

-(void)tapYi{

    if (_arrayYi.count > 1) {

        if (labelIndexYi == _arrayYi.count-1) {
            labelIndexYi--;
            cell.YiImageView.image = [UIImage imageNamed:@"pre_white"];
            isPre = YES;
            if (labelIndexYi == 0 && isPre==YES) {
                cell.YiImageView.image = [UIImage imageNamed:@"next_white"];
                isPre = NO;
            }

        }else if (labelIndexYi == 0) {
            labelIndexYi++;
            cell.YiImageView.image = [UIImage imageNamed:@"next_white"];
            isPre = NO;
            if (labelIndexYi == _arrayYi.count-1 && isPre==NO) {
                cell.YiImageView.image = [UIImage imageNamed:@"pre_white"];
                isPre = YES;
            }
        }else if (isPre) {
            cell.YiImageView.image = [UIImage imageNamed:@"pre_white"];
            labelIndexYi--;
            if (labelIndexYi == 0 && isPre==YES) {
                cell.YiImageView.image = [UIImage imageNamed:@"next_white"];
                isPre = NO;
            }

        }else{
            cell.YiImageView.image = [UIImage imageNamed:@"next_white"];
            labelIndexYi++;
            if (labelIndexYi == _arrayYi.count-1 && isPre==NO) {
                cell.YiImageView.image = [UIImage imageNamed:@"pre_white"];
                isPre = YES;
            }
        }

        NSString *newText = [_arrayYi objectAtIndex:labelIndexYi];
        newText = [newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        [UIView animateWithDuration:1.0 animations:^{
            cell.approprite.text = newText;
        }];
    }
}

-(void)tapJi{
    if (_arrayJi.count > 1) {
        if (labelIndexJi == _arrayJi.count-1 ) {
            labelIndexJi--;
            cell.JiImageView.image = [UIImage imageNamed:@"pre_white"];
            isPre = YES;
            if (labelIndexJi == 0 && isPre==YES) {
                cell.JiImageView.image = [UIImage imageNamed:@"next_white"];
                isPre = NO;
            }
        }else if (labelIndexJi == 0 ) {
            labelIndexJi++;
            cell.JiImageView.image = [UIImage imageNamed:@"next_white"];
            isPre = NO;

            if (labelIndexJi == _arrayJi.count-1 && isPre==NO) {
                cell.JiImageView.image = [UIImage imageNamed:@"pre_white"];
                isPre = YES;
            }
        }else if (isPre) {
            cell.JiImageView.image = [UIImage imageNamed:@"pre_white"];
            labelIndexJi--;
            if (labelIndexJi == 0 && isPre==YES) {
                cell.JiImageView.image = [UIImage imageNamed:@"next_white"];
                isPre = NO;
            }

        }else{
            cell.JiImageView.image = [UIImage imageNamed:@"next_white"];
            labelIndexJi++;
            if (labelIndexJi == _arrayJi.count-1 && isPre==NO) {
                cell.JiImageView.image = [UIImage imageNamed:@"pre_white"];
                isPre = YES;
            }
        }
        
        NSString *newText = [_arrayJi objectAtIndex:labelIndexJi];
        [UIView animateWithDuration:1.0 animations:^{
            cell.avoid.text = newText;
        }];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WeatherTableViewCellEndDecelerating" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NarrowWeatherTableViewCellEndDecelerating" object:nil];
}

@end
