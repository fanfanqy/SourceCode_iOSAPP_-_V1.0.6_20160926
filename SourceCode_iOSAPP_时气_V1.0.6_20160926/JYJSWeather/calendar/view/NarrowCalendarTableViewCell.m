//
//  NarrowCalendarTableViewCell.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/13.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "NarrowCalendarTableViewCell.h"
#import "NarrowCalendarCollectionViewCell.h"

#import "CalendarViewController1.h"
#import "CalendarMainPagesModel.h"
@implementation NarrowCalendarTableViewCell
{
    CalendarMainPagesModel *calendarMainPagesModel;
    BOOL    isInit;
    CalendarModel *calendarModel;
    NarrowCalendarCollectionViewCell * cell;
    NSMutableArray *_arrayYi;
    NSMutableArray *_arrayJi;
    int labelIndexYi;
    int labelIndexJi;
    int  YearScroll;
    BOOL isPre;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xcccccc);
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
        UINib *nib = [UINib nibWithNibName:@"NarrowCalendarCollectionViewCell" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"NARROWCALENDARCOLLECTIONVIEWCELL"];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.pagingEnabled = YES;
        isInit = YES;



        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setNarrowCalendarTableViewCellScrollToIndex:) name:@"WeatherTableViewCellEndDecelerating" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setNarrowCalendarTableViewCellScrollToIndex:) name:@"NarrowWeatherTableViewCellEndDecelerating" object:nil];
    }
    return self;
}

- (void)layoutSubviews
 {

        [super layoutSubviews];
        CGRect fream = [UIScreen mainScreen].bounds;
        self.collectionView.frame = CGRectMake(0, 0, fream.size.width, self.contentView.frame.size.height);
        UICollectionViewFlowLayout *ff  = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        ff.sectionInset = UIEdgeInsetsMake(-1*GapHeight, 0, 0, 0);
        ff.itemSize = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height-GapHeight);
        ff.minimumLineSpacing = 0;

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
                            int index1 = [Datetime GetOneDayIndexInOneYear:YearCurrent andMonth:MonthCurrent andDay:DayCurrent];
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
                            if (self.array.count>0) {
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

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.countRows;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NARROWCALENDARCOLLECTIONVIEWCELL" forIndexPath:indexPath];
    calendarModel          = [[CalendarModel alloc]init];
    
    if (self.array.count > 0) {
    calendarModel = self.array[indexPath.row];
#pragma mark 待修改
    if (calendarModel) {
    cell.luckyImageView.image = [UIImage imageNamed:calendarModel.luckyImageType];
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
        //当前语言code判断
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        NSString *culture = delegate.languageCode;
        if ([culture isEqualToString:@"zh"]) {
            cell.dateLabel.text = [NSString stringWithFormat:@"%@年%@月%@日",str1,str2,str3];
        }else{
            cell.dateLabel.text = [NSString stringWithFormat:@"%@/%@/%@",str3,str2,str1];
        }

    cell.lunarCalendarLabel.text =calendarModel.lunarStr;
    cell.weekLabel.text = calendarModel.weekStr;
//丙申年 等等,这里理发和理发结果分开的控件,非NSMutableAttributedString,不怕为空
    cell.hairCurStrLabel.text = @"理发";
    cell.avoidImageView.image = [UIImage imageNamed:@"ji"];
    cell.appropriteImageView.image = [UIImage imageNamed:@"yi"];
        NSString *hairCutStr = nil;
        if (calendarModel.HaircutStrArray>0) {
            hairCutStr = calendarModel.HaircutStrArray[indexPath.row];
        }else{
            hairCutStr = @" ";
        }

    if (IS_IPHONE4 || IS_IPHONE5 || IS_IPHONE6) {
        if (hairCutStr.length>6) {
            hairCutStr = [hairCutStr substringWithRange:NSMakeRange(0, 5)];
            hairCutStr = [hairCutStr stringByAppendingString:@"…"];
        }
    }
    cell.haircutLabel.text =  hairCutStr;


    NSString *hairWashStr = nil;
    if (calendarModel.hairWashArray.count > 0) {
        NSString *hairWashObj = calendarModel.hairWashArray[indexPath.row];
        if ([hairWashObj isEqualToString:@"吉"]) {
            //纪年位置放洗发
            hairWashStr = @"剪指甲,洗头 吉";
        }else if ([hairWashObj isEqualToString:@"凶"]) {
            //纪年位置放洗发
            hairWashStr = @"剪指甲,洗头 凶";
        }else{
            hairWashStr = hairWashObj;
        }
    }
    else{
            hairWashStr = @"剪指甲,洗头";
    }
       

    NSMutableAttributedString *strHairWash = [[NSMutableAttributedString alloc]initWithString:hairWashStr];
    [strHairWash addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xB60201) range:NSMakeRange(0,6)];
    [strHairWash addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xE7E3E1) range:NSMakeRange(6,strHairWash.length-6)];
    [strHairWash addAttribute:NSFontAttributeName value:[UIFont fontWithName:CALENDARFONTHEITI size:14] range:NSMakeRange(0,strHairWash.length)];
    cell.hairWashLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    cell.hairWashLabel.attributedText = strHairWash;

        //宜忌
        //宜
        if (calendarModel.YiStrArray.count > 0) {
            NSString *yi = calendarModel.YiStrArray[indexPath.row];
            _arrayYi = [Help getArrayWithContent:yi andCount:0  andIsNarrow:YES];

            labelIndexYi = 0;
            if (_arrayYi.count > 1) {
                cell.YiImageView.hidden = NO;
            }else{
                cell.YiImageView.hidden = YES;
            }
            if (_arrayYi.count>0) {
                 cell.appropriteLabel.text =  _arrayYi[0];
            }
            cell.appropriteLabel.numberOfLines = 0;
        }

        if (calendarModel.JiStrArray.count > 0) {
        //忌
            NSString *ji = calendarModel.JiStrArray[indexPath.row];
            _arrayJi = [Help getArrayWithContent:ji andCount:0  andIsNarrow:YES];

            labelIndexJi = 0;

            if (_arrayJi.count > 1) {
                cell.JiImageView.hidden = NO;
            }else{
                cell.JiImageView.hidden = YES;
            }
            if (_arrayJi.count>0) {
                 cell.avoidLabel.text = _arrayJi[0];
            }
            cell.avoidLabel.numberOfLines = 0;
        }
        [self addTap];
    cell.memorialDayLabel.text = calendarModel.religionFestivalStr;
    if (calendarModel.LuckyhourStr) {
        NSMutableAttributedString *strGoodTime = [[NSMutableAttributedString alloc]initWithString:calendarModel.LuckyhourStr];
        [strGoodTime addAttribute:NSFontAttributeName value:[UIFont fontWithName:CALENDARFONTHEITI size:14] range:NSMakeRange(0,str.length)];
        [strGoodTime addAttribute:NSForegroundColorAttributeName
                            value:UIColorFromRGB(0xB60201)
                            range:NSMakeRange(0, 2)];
        cell.goodtimeLabel.attributedText = strGoodTime;
    }

    if (calendarModel.badhouStr) {

    NSMutableAttributedString *strBadTime = [[NSMutableAttributedString alloc]initWithString:calendarModel.badhouStr];
    [strBadTime addAttribute:NSFontAttributeName value:[UIFont fontWithName:CALENDARFONTHEITI size:14] range:NSMakeRange(0,str.length)];
    [strBadTime addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x33497a) range:NSMakeRange(0, 2)];
    cell.badtimeLabel.attributedText = strBadTime;
    }
//金斗执·冲兔 {小寒05:23:56}

        if ([calendarModel.jieqiStr isEqualToString:@" "]) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:calendarModel.ChongAnimalStr];
            [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xB60201) range:NSMakeRange(4,2)];
             [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:CALENDARFONTHEITI size:14] range:NSMakeRange(0,str.length)];
            cell.xingxiuFestival.attributedText = str;

        }else{
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ {%@}",calendarModel.ChongAnimalStr,calendarModel.jieqiStr]];
            [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xB60201) range:NSMakeRange(4,2)];
             [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:CALENDARFONTHEITI size:14] range:NSMakeRange(0,str.length)];
            cell.xingxiuFestival.attributedText = str;

        }
    }
    }else{
        cell.luckyImageView.image = [UIImage imageNamed:@""];
        cell.dateLabel.text = @"";
        cell.lunarCalendarLabel.text = @"";
        cell.weekLabel.text = @"";
        //丙申年 等等
        cell.hairCurStrLabel.text = @"";
        cell.avoidImageView.image = [UIImage imageNamed:@""];
        cell.appropriteImageView.image = [UIImage imageNamed:@""];
        cell.haircutLabel.text =  @"";
        cell.appropriteLabel.text = @"";
        cell.avoidLabel.text = @"";
        cell.memorialDayLabel.text = @"";
        cell.goodtimeLabel.text = @"";
        cell.badtimeLabel.text = @"";
        cell.xingxiuFestival.text = @"";
        cell.goodtimeLabel.attributedText = [[NSAttributedString alloc]initWithString:@""];
        cell.badtimeLabel.attributedText = [[NSAttributedString alloc]initWithString:@""];
        cell.hairWashLabel.attributedText =[[NSAttributedString alloc]initWithString:@""];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CalendarViewController1 *calendarVC = [[CalendarViewController1 alloc]init];
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

-(void)setNarrowCalendarTableViewCellScrollToIndex:(NSNotification*)noti{

    int   YearCurrent = [[Datetime GetYear] intValue];
    int   MonthCurrent = [[Datetime GetMonth] intValue];
    int   DayCurrent = [[Datetime GetDay] intValue];
    int index1 = [Datetime GetOneDayIndexInOneYear:YearCurrent andMonth:MonthCurrent andDay:DayCurrent];
     if (self.array.count > 0) {
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

        if (self.array.count>0) {
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
            [[NSNotificationCenter defaultCenter]postNotificationName:@"NarrowCalendarTableViewCellEndDecelerating" object:mdic userInfo:nil];

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
}


-(void)receiveBeforeData{

    int countDay = [Datetime GetOneYearCountDay:(YearScroll-1)];
    [self.array removeAllObjects];
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

#pragma mark 向右宜忌的箭头
-(void)addTap{
    UITapGestureRecognizer *tapYi = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapYi)];
    cell.YiImageView.image = [UIImage imageNamed:@"next_white"];
    cell.YiImageView.userInteractionEnabled = YES;
    [cell.YiImageView addGestureRecognizer:tapYi];


    UITapGestureRecognizer *tapJi = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapJi)];
    cell.JiImageView.image = [UIImage imageNamed:@"next_white"];
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
        } else if (isPre) {
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
            cell.appropriteLabel.text = newText;
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
        }else  if (labelIndexJi == 0 ) {
            labelIndexJi++;
            cell.JiImageView.image = [UIImage imageNamed:@"next_white"];
            isPre = NO;

            if (labelIndexJi == _arrayJi.count-1 && isPre==NO) {
                cell.JiImageView.image = [UIImage imageNamed:@"pre_white"];
                isPre = YES;
            }

        }else  if (isPre) {
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
            cell.avoidLabel.text = newText;
        }];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WeatherTableViewCellEndDecelerating" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NarrowWeatherTableViewCellEndDecelerating" object:nil];
}
@end
