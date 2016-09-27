//
//  liSuanCalendarView.m
//  
//
//  Created by han on 15/3/6.
//
//

#import "liSuanCalendarView.h"
#import "Datetime.h"
#import "DateSource.h"
#import "ConvertLunarOrSolar.h"
@interface  liSuanCalendarView(){

    NSMutableArray * _dayArray;
    NSMutableArray * _lunarDayArray;
    NSMutableArray * colorArray;
    NSMutableArray * lunarColorArray;
    UILabel * _dayLabel;

    int  blockNr;
    int strYear;
    int strMonth;
    int strDay;
   int selectedYear;
   int selectedMonth;
   int selectedDay;
       NSString *fresh1Date;
    NSString *fresh2Date;
    BOOL selected;//这个决定是否
    BOOL isAnimating;
    UIImageView *animationView_A;
    UIImageView *animationView_B;
    NSInteger indexDay;
    float currentImageOriginY;
    float currentImageFrameHeight;
}
@end
@implementation liSuanCalendarView

-(instancetype)initWithFrame:(CGRect)frame andYear:(int)year andMonth:(int)month andDay:(int)day
{
    if (self = [super initWithFrame:frame]) {
        //存储字体颜色的数组
        colorArray = [[NSMutableArray alloc] init];
        lunarColorArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [self numRows] * 7; i++) {
            [colorArray addObject:UIColorFromRGB(0x000000)];
        }
        //得到当前天在日历上的位置,以便初始时变为选中状态
        [self backTodayActionandYear:year andMonth:month andDay:day];
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipe:)];
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightHandleSwipe:)];
        //对手势识别器进行属性设定
        [swipeLeft setNumberOfTouchesRequired:1];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [swipeRight setNumberOfTouchesRequired:1];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
        //把手势识别器加到view中去
        [self addGestureRecognizer:swipeLeft];
        [self addGestureRecognizer:swipeRight];
        //添加单击按钮
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectOneDay:)];
        [self addGestureRecognizer:tap];
        [tap requireGestureRecognizerToFail:swipeLeft];
        [tap requireGestureRecognizerToFail:swipeRight];
    }
    return self;
}

/**
 *  今天按钮点击事件,回到当前日期
 */
-(void)backTodayActionandYear:(int)year andMonth:(int)month andDay:(int)day
{
//    //得到当前的 年 月 日
    strYear = [[Datetime GetYear] intValue];
    strMonth = [[Datetime GetMonth] intValue];
    strDay = [[Datetime GetDay] intValue];

    strYear = year;
    strMonth = month;
    strDay = day;
    blockNr = [Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth];
    [self reloadDataWithDate:strDay andMonth:strMonth andYear:strYear andIsSelected:YES andIsSwipe:NO];
}

/**
 *  计算某个月在日历中占几行
 *
 *  @return 返回行数
 */
-(int)numRows {
    int lastBlock = [Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth]+([Datetime GetNumberOfDayByYera:strYear andByMonth:strMonth]);
    int chu = lastBlock / 7;
    int yu = lastBlock % 7;
    if (yu == 0) {
        return chu;
    }else{
        return chu + 1;
    }
}

-(void)drawRect:(CGRect)rect
{
    _dayArray = (NSMutableArray *)[Datetime GetDayArrayByYear:strYear andMonth:strMonth];
//    NSLog(@"//获取指定年份指定月份的星期排列表:_dayArray:%@,strYear:%d,strMonth:%d",_dayArray,strYear,strMonth);

    _lunarDayArray = (NSMutableArray *)[Datetime GetLunarDayArrayByYear:strYear andMonth:strMonth];
//    NSLog(@"//获取指定年份指定月份的农历排列表:_lunarDayArray:%@,strYear:%d,strMonth:%d",_dayArray,strYear,strMonth);

    [self selectColor:blockNr + strDay];
    int row = [self numRows];
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    CGContextRef context = UIGraphicsGetCurrentContext();
    /**
     *  画出日历主体
     */
    CGContextSetFillColorWithColor(context,[UIColor blackColor].CGColor);
    for (int i = 0; i < row * 7; i++) {
        int targetDate = [_dayArray[i] intValue];
        int targetColumn = i%7;
        int targetRow = i/7;
        int targetX = targetColumn * 2 * CALENDARBTNPADDING+ 0.5 * CALENDARBTNPADDING;
        int targetY = CALENDARBTNPADDING+ targetRow *CALENDARBTNPADDING*2 / row * 5 + TOPBUTTONHEIGHT;
        if (i==0) {
            currentImageOriginY = targetY;
        }
        if ((i+1)/7==row) {
            currentImageFrameHeight = targetY+0.8*CALENDARBTNPADDING;
        }
       CGContextSetFillColorWithColor(context,[UIColor blackColor].CGColor);

        if(strDay + blockNr == i + 1 && selected){
                UIImage * today = [UIImage imageNamed:@"circle"];
                [today drawInRect:CGRectMake(targetX -0.4 * CALENDARBTNPADDING, targetY, CALENDARBTNPADDING * 1.8,CALENDARBTNPADDING * 1.8 ) blendMode:kCGBlendModeNormal alpha:1.0];
        }
        if (targetDate != 0) {
            //zhouxuewen /藏历日历字体大小
            UIFont * fontName1;
            UIFont * fontName2;
        
                fontName1 = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERONE];//16号
                fontName2 = [UIFont fontWithName:CALENDARFONTHEITI size:TEXTNUMBERFOUR];//14号

            NSString *date = [NSString stringWithFormat:@"%i",targetDate];
            NSString * lunar = [NSString stringWithFormat:@"%@",_lunarDayArray[i]];
            //7月1日做特殊处理，显示  建党节
            if ([[lunar substringToIndex:2] isEqualToString:@"香港"]) {
                lunar = @"建党节";
            }
            /* 长度大于3的做省略显示处理 */
            if (lunar.length>3) {
                 lunar = [NSString stringWithFormat:@"%@…",[lunar substringToIndex:2]];
                [lunar drawInRect:CGRectMake(targetX - 0.5 * CALENDARBTNPADDING, targetY+CALENDARBTNPADDING, CALENDARBTNPADDING * 2.0, CALENDARBTNPADDING * 0.7) withAttributes:@{NSFontAttributeName:fontName2,NSForegroundColorAttributeName:lunarColorArray[i],NSParagraphStyleAttributeName:style}];
            }else{
                //节日,节气
            [lunar drawInRect:CGRectMake(targetX - 0.5 * CALENDARBTNPADDING, targetY+CALENDARBTNPADDING  , CALENDARBTNPADDING * 2, CALENDARBTNPADDING * 0.7) withAttributes:@{NSFontAttributeName:fontName2,NSForegroundColorAttributeName:lunarColorArray[i],NSParagraphStyleAttributeName:style}];
            }
            [date drawInRect:CGRectMake(targetX, targetY + 2 , CALENDARBTNPADDING , CALENDARBTNPADDING * 0.8) withAttributes:@{NSFontAttributeName:fontName1,NSForegroundColorAttributeName:colorArray[i],NSParagraphStyleAttributeName:style}];
            UIColor *dataColor = colorArray[i];
            [dataColor set];
            UIColor *lunarColor = lunarColorArray[i];
            [lunarColor set];
            }
        }
}


/**
 *  左滑动作事件
 *
 *  @param gestureRecognizer 左滑手势
 */
-(void)leftHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (isAnimating) return;
            isAnimating = YES;
            UIImage *imageCurrentMonth = [self drawCurrentState];
    if (strYear>2048 && strMonth>11) {

    }else{
            strMonth = strMonth+1;
            if(strMonth == 13){
                strYear++;
                strMonth = 1;
            }
            blockNr = [Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth];
         }

            BOOL isTemp = nil;

            isTemp = ((strMonth==selectedMonth) &&(strYear == selectedYear))?YES:NO;
            
            if (isTemp) {
                strDay = selectedDay;
            }

        [self reloadDataWithDate:strDay  andMonth:strMonth andYear:strYear andIsSelected:isTemp andIsSwipe:YES];


            UIImage * imagePreviousMonth = [self drawCurrentState];
            UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0,currentImageOriginY , self.frame.size.width , currentImageFrameHeight)];
            [animationHolder setClipsToBounds:YES];
            [self addSubview:animationHolder];
            
            animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
            animationView_B = [[UIImageView alloc] initWithImage:imagePreviousMonth];
            animationView_A.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calendarTopBack"]];
            animationView_B.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calendarTopBack"]];

            [animationHolder addSubview:animationView_A];
            [animationHolder addSubview:animationView_B];
            
            animationView_A.frame = CGRectMake(0, 0, self.frame.size.width, currentImageFrameHeight);
            animationView_B.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, currentImageFrameHeight-7 );
    if (strYear>2048 && strMonth>11) {
        CGRect frameA = animationView_A.frame;
        frameA.origin.x -= self.frame.size.width;
        animationView_A.frame = frameA;

        CGRect frameB = animationView_B.frame;
        frameB.origin.x -= self.frame.size.width;
        animationView_B.frame = frameB;
        [animationView_A removeFromSuperview];
        [animationView_B removeFromSuperview];
        isAnimating=NO;
        [animationHolder removeFromSuperview];

    }else{
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 CGRect frameA = animationView_A.frame;
                                 frameA.origin.x -= self.frame.size.width;
                                 animationView_A.frame = frameA;
                                 
                                 CGRect frameB = animationView_B.frame;
                                 frameB.origin.x -= self.frame.size.width;
                                 animationView_B.frame = frameB;
                             }
                             completion:^(BOOL finished) {
                                 [animationView_A removeFromSuperview];
                                 [animationView_B removeFromSuperview];
                                 isAnimating=NO;
                                 [animationHolder removeFromSuperview];
                             }
             ];
    }
}
/**
 *  右滑动作事件
 *
 *  @param gestureRecognizer 右滑手势
 */
- (void)rightHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (isAnimating) return;
    isAnimating = YES;
    UIImage *imageCurrentMonth = [self drawCurrentState];
    if (strYear<1902 && strMonth<=1) {

    }else{
    strMonth = strMonth-1;
    if(strMonth == 0){
        strYear--;strMonth = 12;
    }
    }
    blockNr = [Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth];
    BOOL isTemp = nil;
    isTemp = ((strMonth==selectedMonth) && (strYear==selectedYear))?YES:NO;
    if (isTemp) {
        strDay = selectedDay;
    }

    [self reloadDataWithDate:strDay andMonth:strMonth andYear:strYear andIsSelected:isTemp andIsSwipe:YES];

    UIImage * imagePreviousMonth = [self drawCurrentState];
//    NSLog(@"%@",imagePreviousMonth);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, currentImageOriginY , self.frame.size.width , currentImageFrameHeight)];
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    
    animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    animationView_B = [[UIImageView alloc] initWithImage:imagePreviousMonth];
    animationView_A.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calendarTopBack"]];
    animationView_B.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calendarTopBack"]];
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    
    animationView_A.frame = CGRectMake(0, 0, self.frame.size.width, currentImageFrameHeight);
    animationView_B.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width,currentImageFrameHeight);
    if (strYear<1902 && strMonth<=1) {
        CGRect frameA = animationView_A.frame;
        frameA.origin.x += self.frame.size.width;
        animationView_A.frame = frameA;

        CGRect frameB = animationView_B.frame;
        frameB.origin.x += self.frame.size.width;
        animationView_B.frame = frameB;
        [animationView_A removeFromSuperview];
        [animationView_B removeFromSuperview];
        isAnimating=NO;
        [animationHolder removeFromSuperview];

    }else{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         CGRect frameA = animationView_A.frame;
                         frameA.origin.x += self.frame.size.width;
                         animationView_A.frame = frameA;
    
                         CGRect frameB = animationView_B.frame;
                         frameB.origin.x += self.frame.size.width;
                         animationView_B.frame = frameB;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                     }
     ];
    }
}

-(UIImage *)drawCurrentState {
    CGSize s = CGSizeMake(self.frame.size.width, currentImageFrameHeight );
    UIGraphicsBeginImageContextWithOptions(s, NO, self.layer.contentsScale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, -currentImageOriginY );    // <-- shift everything up by 40px when drawing.
    [self.layer renderInContext:c];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

/**
 *  点击日历按钮事件
 *
 *  @param tap 单击手势
 */
-(void)selectOneDay:(UITapGestureRecognizer *)tap{
    CGPoint touchPoint = [tap locationInView:self];
    int numRow = [self numRows];
    int day = [Datetime GetNumberOfDayByYera:strYear andByMonth:strMonth];
    //单击一天,计算出point所处日期的位置
    if ((touchPoint.y > CALENDARBTNPADDING  + TOPBUTTONHEIGHT) && (touchPoint.y < 12 * CALENDARBTNPADDING+ TOPBUTTONHEIGHT) && (touchPoint.x > + 0.5 * CALENDARBTNPADDING) && (touchPoint.x <  ScreenWidth - CALENDARBTNPADDING)){
        float xLocation = touchPoint.x;
        float yLocation = touchPoint.y-CALENDARBTNPADDING - TOPBUTTONHEIGHT;
        
        int column = floorf(xLocation/( 2 * CALENDARBTNPADDING));
        int row = floorf(yLocation/(CALENDARBTNPADDING*2 / numRow * 5));
        
        int block = (column+1)+row*7;
        int firstWeekDay = [Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth]; //-1 because weekdays begin at 1, not 0
        int date = block-firstWeekDay;
        if (date > 0 && date <= day) {
            strDay = date;
            selectedDay = strDay;
            selectedMonth = strMonth;
            selectedYear  = strYear;
           [self reloadDataWithDate:strDay andMonth:strMonth andYear:strYear  andIsSelected:YES andIsSwipe:NO];
        }
        return;
    }
}
/**
 *  存储日历字体颜色的数组
 *  节日/气 替换农历
 *  @param num blockNr :选中日期在日历中的位置
 */
-(void)selectColor:(int)num
{
        for (int i = 0; i < [self numRows] * 7; i++) {
            calendarDBModel * model;
            colorArray[i] = UIColorFromRGB(0x000000); //日历在未被选中的数字字体颜色
            lunarColorArray[i] = UIColorFromRGB(0x000000); // 日历在未被选中的数字下面的字体颜色
            if ( i<[Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth]) {

               if (_calendarArray.count >0) {
                 model = _calendarArray[0][i];
                }
                
                 colorArray[i] = UIColorFromRGB(0xcccccc);
                 lunarColorArray[i] = UIColorFromRGB(0xcccccc);

                if (model != nil) {

                    if ([model.lDayName isEqualToString:@"初一"]) {
                        NSArray * monthArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
                        NSString * lunarMonth;
                        int lunarIndex;
                        if (model.lMonth.intValue == 0) {
                            lunarIndex = [[[model.lMonth componentsSeparatedByString:@"闰"] objectAtIndex:1] intValue] - 1;
                            lunarMonth = [NSString stringWithFormat:@"闰%@",[monthArray objectAtIndex:lunarIndex]];
                        }else {
                            lunarIndex = [model.lMonth intValue] - 1;
                            lunarMonth = [monthArray objectAtIndex:lunarIndex];
                        }
                        _lunarDayArray[i] = [NSString stringWithFormat:@"%@月",lunarMonth];
                    }
                }


            }else if (  i>=[Datetime GetNumberOfDayByYera:strYear andByMonth:strMonth]+[Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth]){

                if (_calendarArray.count >0) {
                    int count = (int)[_calendarArray[0] count]+(int)[_calendarArray[1] count];
//                    if (i-count<[_calendarArray[2] count]) {
                          model = _calendarArray[2][i-count];
//                    }
                }

                colorArray[i] = UIColorFromRGB(0xcccccc);
                lunarColorArray[i] = UIColorFromRGB(0xcccccc);

                if (model != nil) {

                    if ([model.lDayName isEqualToString:@"初一"]) {
                        NSArray * monthArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
                        NSString * lunarMonth;
                        int lunarIndex;
                        if (model.lMonth.intValue == 0) {
                            lunarIndex = [[[model.lMonth componentsSeparatedByString:@"闰"] objectAtIndex:1] intValue] - 1;
                            lunarMonth = [NSString stringWithFormat:@"闰%@",[monthArray objectAtIndex:lunarIndex]];
                        }else {
                            lunarIndex = [model.lMonth intValue] - 1;
                            lunarMonth = [monthArray objectAtIndex:lunarIndex];
                        }
                        _lunarDayArray[i] = [NSString stringWithFormat:@"%@月",lunarMonth];

                    }
                    /* 显示优先权：节气 > 阴历 > 阳历 */
                    if (model.gongLiJieRi.length > 0) {
                        _lunarDayArray[i] = model.gongLiJieRi;

                    }

                    if (![[Datetime GetLunarFestival:[model.lYear intValue] andMonth:[model.lMonth intValue] andDay:[model.lDay intValue]] isEqualToString:@" "]) {
                        _lunarDayArray[i] = [Datetime GetLunarFestival:[model.lYear intValue] andMonth:[model.lMonth intValue] andDay:[model.lDay intValue]];
                    }

                    if (model.jieQi.length != 0) {
                        _lunarDayArray[i] = model.jieQi;
                    }

                }

            }else{

                if (_calendarArray.count >0) {
                    int count = (int)[_calendarArray[0] count];
                    model = _calendarArray[1][i-count];
                }

                if (model != nil) {

                    if ([model.lDayName isEqualToString:@"初一"]) {
                        NSArray * monthArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
                        NSString * lunarMonth;
                        int lunarIndex;
                        if (model.lMonth.intValue == 0) {
                            lunarIndex = [[[model.lMonth componentsSeparatedByString:@"闰"] objectAtIndex:1] intValue] - 1;
                            lunarMonth = [NSString stringWithFormat:@"闰%@",[monthArray objectAtIndex:lunarIndex]];
                        }else {
                            lunarIndex = [model.lMonth intValue] - 1;
                            lunarMonth = [monthArray objectAtIndex:lunarIndex];
                        }
                        _lunarDayArray[i] = [NSString stringWithFormat:@"%@月",lunarMonth];
                        lunarColorArray[i] = UIColorFromRGB(0xd20000);
                    }
                    /* 显示优先权：节气 > 阴历 > 阳历 */
                    if (model.gongLiJieRi.length > 0) {
                        _lunarDayArray[i] = model.gongLiJieRi;
                        //zhouxuewen /藏历今天日期下面公历节日label的颜色//未选中状态
                        lunarColorArray[i] = UIColorFromRGB(0xd20000);
                    }

                    if (![[Datetime GetLunarFestival:[model.lYear intValue] andMonth:[model.lMonth intValue] andDay:[model.lDay intValue]] isEqualToString:@" "]) {
                        _lunarDayArray[i] = [Datetime GetLunarFestival:[model.lYear intValue] andMonth:[model.lMonth intValue] andDay:[model.lDay intValue]];
                        lunarColorArray[i] = UIColorFromRGB(0xd20000);
                    }

                    if (model.jieQi.length != 0) {
                        _lunarDayArray[i] = model.jieQi;
                        lunarColorArray[i] = UIColorFromRGB(0xd20000);
                    }
                    
                    if ([model.weekName isEqualToString:@"六"]  ||  [model.weekName isEqualToString:@"日"]) {
                        colorArray[i] = UIColorFromRGB(0xd20000);
                    }

                }

            }
        }
}

-(void)markDataWithYear:(int)year month:(int)month day:(int)day andIsSwipe:(BOOL)isSwipe
{

    strYear = year;
    strMonth = month;
    strDay = day;
    NSLog(@"%s,_strYear,_strMonth,_strDay:%d,%d,%d",__func__,strYear,strMonth,strDay);
    NSLog(@"%s,strYear,strMonth,strDay:%d,%d,%d",__func__,year,month,day);
    blockNr = [Datetime GetTheWeekOfDayByYera:strYear andByMonth:strMonth];
    selectedYear = strYear;
    selectedMonth = strMonth;
    selectedDay = strDay;
    [self reloadDataWithDate:strDay andMonth:strMonth andYear:strYear andIsSelected:YES andIsSwipe:NO];
}

-(void)reloadDataWithDate:(int)date andMonth:(int)month andYear:(int)year andIsSelected:(BOOL)isSelected andIsSwipe:(BOOL)isSwipe;

{
    /**
     *  从数据库读取新数据 更新整个界面数据
     *
     *  @param reloadDataWithYear:month:day: 根据选中日期更新数据
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(reloadDataWithYear:month:day:andIsSelected: andIsSwipe:)]) {
                [self.delegate reloadDataWithYear:year month:month day:date andIsSelected:isSelected andIsSwipe:isSwipe];
            }
           NSLog(@"isSelected:%d",isSelected);
            //直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect:，但是有个前提条件是rect不能为0.
            if (isSelected) {
                selected = YES;
            }
            else{
                selected = NO;
            }
            [self setNeedsDisplay];
            
        });
    });

}


@end
