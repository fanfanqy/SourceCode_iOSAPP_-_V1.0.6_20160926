
//  Tool_ChineseCalendar.m
//  XJAudiobooks
//
//  Created by chris on 14-5-26.
//  Copyright (c) 2014年 chris. All rights reserved.
//

#import "Tool_ChineseCalendar.h"
#import <EventKit/EventKit.h>
#import "NSDate+BeeExtension.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface Tool_ChineseCalendar ()

@property(nonatomic,strong) NSArray *lunarInfo;
@property(nonatomic,strong) NSArray *solarTerm;
@property(nonatomic,strong) NSArray *sTermInfo;
@property(nonatomic,strong) NSMutableArray *solarMonth;
@property(nonatomic,strong) NSArray *gan;
@property(nonatomic,strong) NSArray *zhi;
@property(nonatomic,strong) NSArray *animals;
@property(nonatomic,strong) NSArray *army_animals;
@property(nonatomic,strong) NSArray *nStr1;
@property(nonatomic,strong) NSArray *nStr2;
@property(nonatomic,strong) NSArray *monthName;
@property(nonatomic,strong) NSDictionary *sFtv;
@property(nonatomic,strong) NSDictionary *lDFtv;
@property(nonatomic,strong) NSArray *zhi_ji_xiong;
@property(nonatomic,strong) NSArray *wFtv;
@property(nonatomic,strong) NSArray *jx_name;
@property(nonatomic,strong) NSDictionary *jx_yj_map;
@property(nonatomic,strong) NSArray *xin_su;
@property(nonatomic,strong) NSArray *nongli_yues;
@property(nonatomic,strong) NSArray *yiji_case;

@property(nonatomic,assign) NSInteger year;
@property(nonatomic,assign) NSInteger month;
@property(nonatomic,strong) NSDate *tDate;

-(NSString*)cDay:(NSInteger)d;
-(NSString*) get_nongli_yue:(NSInteger)month;
-(NSInteger)Ymd2Jd:(NSInteger)yy mm:(NSInteger)mm dd:(NSInteger)dd;
-(NSInteger)monthDays:(NSInteger)y m:(NSInteger)m;
-(NSInteger)leapMonth:(NSInteger)y;
-(NSInteger)lunarYY:(NSInteger)yy;
-(NSString*)cyclical:(NSInteger)year;
-(NSInteger)lYearDays:(NSInteger)y;
-(NSInteger)leapDays:(NSInteger)y;
-(NSInteger)sTerm:(NSInteger)y n:(NSInteger)n;
-(NSString*)anything_bad:(NSInteger)offset_ly
               offset_lm:(NSInteger)offset_lm
               offset_ld:(NSInteger)offset_ld
                      lm:(NSInteger)lm
                      ld:(NSInteger)ld;
-(NSDictionary*)yearToEaster:(NSInteger)y;

@end

@implementation Tool_ChineseCalendar

-(id) init{
    if (self=[super init]) {
        _lunarInfo = @[@(0x04bd8),@(0x04ae0),@(0x0a570),@(0x054d5),@(0x0d260),@(0x0d950),@(0x16554),@(0x056a0),@(0x09ad0),@(0x055d2),@(
                       0x04ae0),@(0x0a5b6),@(0x0a4d0),@(0x0d250),@(0x1d255),@(0x0b540),@(0x0d6a0),@(0x0ada2),@(0x095b0),@(0x14977),@(
                       0x04970),@(0x0a4b0),@(0x0b4b5),@(0x06a50),@(0x06d40),@(0x1ab54),@(0x02b60),@(0x09570),@(0x052f2),@(0x04970),@(
                       0x06566),@(0x0d4a0),@(0x0ea50),@(0x06e95),@(0x05ad0),@(0x02b60),@(0x186e3),@(0x092e0),@(0x1c8d7),@(0x0c950),@(
                       0x0d4a0),@(0x1d8a6),@(0x0b550),@(0x056a0),@(0x1a5b4),@(0x025d0),@(0x092d0),@(0x0d2b2),@(0x0a950),@(0x0b557),@(
                       0x06ca0),@(0x0b550),@(0x15355),@(0x04da0),@(0x0a5b0),@(0x14573),@(0x052b0),@(0x0a9a8),@(0x0e950),@(0x06aa0),@(
                       0x0aea6),@(0x0ab50),@(0x04b60),@(0x0aae4),@(0x0a570),@(0x05260),@(0x0f263),@(0x0d950),@(0x05b57),@(0x056a0),@(
                       0x096d0),@(0x04dd5),@(0x04ad0),@(0x0a4d0),@(0x0d4d4),@(0x0d250),@(0x0d558),@(0x0b540),@(0x0b6a0),@(0x195a6),@(
                       0x095b0),@(0x049b0),@(0x0a974),@(0x0a4b0),@(0x0b27a),@(0x06a50),@(0x06d40),@(0x0af46),@(0x0ab60),@(0x09570),@(
                       0x04af5),@(0x04970),@(0x064b0),@(0x074a3),@(0x0ea50),@(0x06b58),@(0x055c0),@(0x0ab60),@(0x096d5),@(0x092e0),@(
                       0x0c960),@(0x0d954),@(0x0d4a0),@(0x0da50),@(0x07552),@(0x056a0),@(0x0abb7),@(0x025d0),@(0x092d0),@(0x0cab5),@(
                       0x0a950),@(0x0b4a0),@(0x0baa4),@(0x0ad50),@(0x055d9),@(0x04ba0),@(0x0a5b0),@(0x15176),@(0x052b0),@(0x0a930),@(
                       0x07954),@(0x06aa0),@(0x0ad50),@(0x05b52),@(0x04b60),@(0x0a6e6),@(0x0a4e0),@(0x0d260),@(0x0ea65),@(0x0d530),@(
                       0x05aa0),@(0x076a3),@(0x096d0),@(0x04bd7),@(0x04ad0),@(0x0a4d0),@(0x1d0b6),@(0x0d250),@(0x0d520),@(0x0dd45),@(
                       0x0b5a0),@(0x056d0),@(0x055b2),@(0x049b0),@(0x0a577),@(0x0a4b0),@(0x0aa50),@(0x1b255),@(0x06d20),@(0x0ada0),@(
                       0x14b63)];
        
        _solarTerm = @[@"小寒",@"大寒",@"立春",
                       @"雨水",@"惊蛰",@"春分",
                       @"清明",@"谷雨",@"立夏",
                       @"小满",@"芒种",@"夏至",
                       @"小暑",@"大暑",@"立秋",
                       @"处暑",@"白露",@"秋分",
                       @"寒露",@"霜降",@"立冬",
                       @"小雪",@"大雪",@"冬至[冬节]"];
        
        
        _sTermInfo = @[@0,@21208,@42467,@63836,@85337,@107014,@128867,
                       @150921,@173149,@195551,@218072,@240693,@263343,
                       @285989,@308563,@331033,@353350,@375494,@397447,
                       @419210,@440795,@462224,@483532,@504758];
        
        NSArray *solarMonthAry = @[@31,@28,@31,@30,@31,@30,@31,@31,@30,@31,@30,@31];
        _solarMonth = [solarMonthAry mutableCopy];
        
        _gan= @[@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸"];
        
        _zhi = @[@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥"];
        
        _animals = @[@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪"];
        
        _army_animals = @[@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇"];
        
        _nStr1 = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十"];
        
        _nStr2 = @[@"初",@"十",@"廿",@"卅",@"□"];
        
        _monthName = @[@"JAN",@"FEB",@"MAR",@"APR",@"MAY",@"JUN",@"JUL",@"AUG",@"SEP",@"OCT",@"NOV",@"DEC"];
        
        //国历节日
        _sFtv = @{
                  @"0101":@"*元旦节",
                  @"0202":@"世界湿地日",
                  @"0210":@"国际气象节",
                  @"0214":@"情人节",
                  @"0301":@"国际海豹日",
                  @"0303":@"全国爱耳日",
                  @"0305":@"学雷锋纪念日",
                  @"0308":@"妇女节",
                  @"0312":@"植树节 孙中山逝世纪念日",
                  @"0314":@"国际警察日",
                  @"0315":@"消费者权益日",
                  @"0317":@"中国国医节 国际航海日",
                  @"0321":@"世界森林日 消除种族歧视国际日 世界儿歌日",
                  @"0322":@"世界水日",
                  @"0323":@"世界气象日",
                  @"0324":@"世界防治结核病日",
                  @"0325":@"全国中小学生安全教育日",
                  @"0330":@"巴勒斯坦国土日",
                  @"0401":@"愚人节 全国爱国卫生运动月(四月) 税收宣传月(四月)",
                  @"0407":@"世界卫生日",
                  @"0422":@"世界地球日",
                  @"0423":@"世界图书和版权日",
                  @"0424":@"亚非新闻工作者日",
                  @"0501":@"*劳动节",
                  @"0504":@"青年节",
                  @"0505":@"碘缺乏病防治日",
                  @"0508":@"世界红十字日",
                  @"0512":@"国际护士节",
                  @"0515":@"国际家庭日",
                  @"0517":@"世界电信日",
                  @"0518":@"国际博物馆日",
                  @"0520":@"全国学生营养日",
                  @"0522":@"国际生物多样性日",
                  @"0523":@"国际牛奶日",
                  @"0531":@"世界无烟日",
                  @"0601":@"国际儿童节",
                  @"0605":@"世界环境日",
                  @"0606":@"全国爱眼日",
                  @"0617":@"防治荒漠化和干旱日",
                  @"0623":@"国际奥林匹克日",
                  @"0625":@"全国土地日",
                  @"0626":@"国际禁毒日",
                  @"0701":@"香港回归纪念日 中共诞辰 世界建筑日",
                  @"0702":@"国际体育记者日",
                  @"0707":@"抗日战争纪念日",
                  @"0711":@"世界人口日",
                  @"0730":@"非洲妇女日",
                  @"0801":@"建军节",
                  @"0808":@"中国男子节(爸爸节)",
                  @"0815":@"抗日战争胜利纪念",
                  @"0908":@"国际扫盲日 国际新闻工作者日",
                  @"0909":@"毛泽东逝世纪念",
                  @"0910":@"中国教师节",
                  @"0914":@"世界清洁地球日",
                  @"0916":@"国际臭氧层保护日",
                  @"0918":@"九·一八事变纪念日",
                  @"0920":@"国际爱牙日",
                  @"0927":@"世界旅游日",
                  @"0928":@"孔子诞辰",
                  @"1001":@"*国庆节 世界音乐日 国际老人节",
                  @"1002":@"国际和平与民主自由斗争日",
                  @"1004":@"世界动物日",
                  @"1006":@"老人节",
                  @"1008":@"全国高血压日 世界视觉日",
                  @"1009":@"世界邮政日 万国邮联日",
                  @"1010":@"辛亥革命纪念日 世界精神卫生日",
                  @"1013":@"世界保健日 国际教师节",
                  @"1014":@"世界标准日",
                  @"1015":@"国际盲人节(白手杖节)",
                  @"1016":@"世界粮食日",
                  @"1017":@"世界消除贫困日",
                  @"1022":@"世界传统医药日",
                  @"1024":@"联合国日 世界发展信息日",
                  @"1031":@"世界勤俭日",
                  @"1107":@"十月社会主义革命纪念日",
                  @"1108":@"中国记者日",
                  @"1109":@"全国消防安全宣传教育日",
                  @"1110":@"世界青年节",
                  @"1111":@"国际科学与和平周(本日所属的一周)",
                  @"1112":@"孙中山诞辰纪念日",
                  @"1114":@"世界糖尿病日",
                  @"1117":@"国际大学生节 世界学生节",
                  @"1121":@"世界问候日 世界电视日",
                  @"1129":@"国际声援巴勒斯坦人民国际日",
                  @"1201":@"世界艾滋病日",
                  @"1203":@"世界残疾人日",
                  @"1205":@"国际经济和社会发展志愿人员日",
                  @"1208":@"国际儿童电视日",
                  @"1209":@"世界足球日",
                  @"1210":@"世界人权日",
                  @"1212":@"西安事变纪念日",
                  @"1213":@"南京大屠杀(1937年)纪念日！紧记血泪史！",
                  @"1220":@"澳门回归纪念",
                  @"1221":@"国际篮球日",
                  @"1224":@"平安夜",
                  @"1225":@"圣诞节",
                  @"1226":@"毛泽东诞辰纪念"
                  };
        
        _zhi_ji_xiong = @[@[@1,@1,@0,@1,@0,@0,@0,@0,@1,@1,@0,@0],
                          @[@0,@0,@1,@1,@0,@1,@0,@0,@1,@0,@1,@1],
                          @[@1,@1,@0,@0,@1,@1,@0,@1,@0,@0,@1,@1],
                          @[@1,@0,@1,@1,@0,@0,@1,@1,@0,@0,@0,@0],
                          @[@0,@0,@1,@0,@1,@1,@0,@0,@1,@1,@0,@1],
                          @[@0,@1,@0,@0,@1,@0,@1,@1,@0,@0,@1,@0],
                          @[@0,@1,@0,@1,@0,@0,@1,@0,@1,@1,@0,@0],
                          @[@0,@0,@1,@1,@0,@1,@0,@0,@1,@0,@1,@1],
                          @[@1,@1,@0,@0,@1,@1,@0,@1,@0,@0,@1,@0],
                          @[@1,@0,@1,@0,@0,@0,@1,@1,@0,@1,@0,@0],
                          @[@0,@0,@1,@0,@0,@1,@0,@0,@1,@1,@0,@1],
                          @[@0,@1,@0,@0,@1,@0,@1,@1,@0,@0,@1,@1]];
        
        _lDFtv = @{@"0101":@[@1,@1,@"春节",@"*"],
                   @"0102":@[@1,@2,@"初二",@"*"],
                   @"0103":@[@1,@3,@"初三",@"*"],
                   @"0115":@[@1,@15,@"元宵节",@"*"],
                   @"0202":@[@2,@2,@"龙抬头节",@""],
                   @"0323":@[@3,@23,@"妈祖生辰",@""],
                   @"0505":@[@5,@5,@"端午节",@""],
                   @"0707":@[@7,@7,@"七夕情人节",@""],
                   @"0715":@[@7,@15,@"中元节",@""],
                   @"0815":@[@8,@15,@"中秋节",@""],
                   @"0909":@[@9,@9,@"重阳节",@""],
                   @"1208":@[@12,@8,@"腊八节",@""],
                   @"1223":@[@12,@23,@"小年",@""],
                   @"0100":@[@1,@0,@"除夕",@""]};
        
        //某月的第几个星期几
        //一月的最后一个星期日（月倒数第一个星期日）
        _wFtv = @[@[@1,@1,@0, @"黑人日"],
                  @[@1,@5,@0,@"世界麻风日"],
                  @[@5,@2,@0,@"国际母亲节"],
                  @[@5,@3,@0,@"全国助残日"],
                  @[@6,@3,@0,@"父亲节"],
                  @[@7,@3,@0,@"被奴役国家周"],
                  @[@9,@3,@2,@"国际和平日"],
                  @[@9,@4,@0,@"国际聋人节 世界儿童日"],
                  @[@9,@5,@0,@"世界海事日"],
                  @[@10,@1,@1,@"国际住房日"],
                  @[@10,@1,@3,@"国际减轻自然灾害日(减灾日]"],
                  @[@11,@4,@4,@"感恩节"]];
        
        /**
         * 董公黑黄道十二吉凶日：建、除、满、平、定、执、破、危、成、收、开、闭
         * 十二黑黄道吉凶日大体如此，不一定“成、开、满、定”就一定吉，“危、破、执、闭”就一定凶。因为神煞流行占宫不同，若要选择使用，还须具体分析，结合各个月建神煞占宫综合推论，以及与家主命理相符等等。
         * 又有杨公十三忌日：正月十三、二月十一、三月初九、四月初七、五月初五、六月初三、七月初一二十九、八月当中二十七、九月二十五、十月二十三、冬月最忌二十一、腊月二十九最凶。神仙留下十三日，婚姻嫁娶皆不宜；一切兴工与起造，举动应防有损失。
         * 又有三娘孤煞日：初三初七与十三，十八、二十二和二十七。迎亲嫁娶无儿女，孤儿寡妇不成双。
         * 还防天地转煞日：春乙卯辛卯，夏丙午戊午，秋辛酉癸酉，冬壬子丙子。
         * 还要躲开四绝（四立前一日），四离（四分前一日），四废（春庚申辛酉、夏壬子癸亥、秋甲寅乙卯、冬丙午丁巳日）等。
         * @var array
         */
        _jx_name = @[@"建",@"除",@"满",@"平",@"定",@"执",@"破",@"危",@"成",@"收",@"开",@"闭"];
        
        _jx_yj_map = @{@"建":@[@"出行 上任 会友 上书 见工",@"动土 开仓 嫁娶 纳采"],
                       @"除":@[@"除服 疗病 出行 拆卸 入宅",@"求官 上任 开张 搬家 探病"],
                       @"满":@[@"祈福 祭祀 结亲 开市 交易",@"服药 求医 栽种 动土 迁移"],
                       @"平":@[@"祭祀 修墳 涂泥 餘事 勿取",@"移徙 入宅 嫁娶 开市 安葬"],
                       @"定":@[@"交易 立券 会友 签約 納畜",@"种植 置业 卖田 掘井 造船"],
                       @"执":@[@"祈福 祭祀 求子 结婚 立约",@"开市 交易 搬家 远行"],
                       @"破":@[@"求医 赴考 祭祀 餘事 勿取",@"动土 出行 移徙 开市 修造"],
                       @"危":@[@"经营 交易 求官 納畜 動土",@"登高 行船 安床 入宅 博彩"],
                       @"成":@[@"祈福 入学 开市 求医 成服",@"词讼 安門 移徙"],
                       @"收":@[@"祭祀 求财 签约 嫁娶 订盟",@"开市 安床 安葬 入宅 破土"],
                       @"开":@[@"疗病 结婚 交易 入仓 求职",@"安葬 动土 针灸"],
                       @"闭":@[@"祭祀 交易 收财 安葬",@"宴会 安床 出行 嫁娶 移徙"]};
        
        
        /**
         * 28星宿
         * @var array
         */
        _xin_su = @[@"角",@"亢",@"氐",@"房",
                    @"心",@"尾",@"箕",@"斗",
                    @"牛",@"女",@"虚",@"危",
                    @"室",@"壁",@"奎",@"娄",
                    @"胃",@"昴",@"毕",@"觜",
                    @"参",@"井",@"鬼",@"柳",
                    @"星",@"张",@"翼",@"轸"];
        
        
        /**
         * 农历一年分十二个月，依次为：孟春、仲春、季春，孟夏、仲夏、季夏，孟秋、仲秋、季秋，孟冬、仲冬、季冬。
         * @var array
         */
        _nongli_yues = @[@"孟春",@"仲春",@"季春",@"孟夏",@"仲夏",@"季夏",@"孟秋",@"仲秋",@"季秋",@"孟冬",@"仲冬",@"季冬"];

        _yiji_case = @[@"缘起不成,大事勿用",@"婚嫁",@"移徙",@"搬家",@"开业",@"动土",@"出行",@"解缚",@"除秽",@"交易",@"订盟",@"签约",@"招财",@"谋望",@"手术",@"针灸",@"诉讼",@"投诉",@"上任",@"安门",@"置业",@"安葬",@"求学",@"追捕",@"修造",@"拆卸",@"栽种",@"祭祀",@"祈福",@"凃泥",@"修坟"];
        
    }
    
    return self;
}

/**
 * 获取农历月份的农历名称
 * 农历一年分十二个月，依次为：孟春、仲春、季春，孟夏、仲夏、季夏，孟秋、仲秋、季秋，孟冬、仲冬、季冬。
 */
-(NSString*) get_nongli_yue:(NSInteger)month{
    return _nongli_yues[month - 1];
}

/**
 * 28星宿
 * get_xin_su(Ymd2Jd(cld[d].sYear,cld[d].sMonth,cld[d].sDay))
 */

-(NSString*)get_xin_su:(NSInteger)d
{
    NSInteger s = (d+12) % 28;
    return _xin_su[s];
}

-(NSInteger)Ymd2Jd:(NSInteger)yy mm:(NSInteger)mm dd:(NSInteger)dd
{
    NSInteger yym1 = yy -1;
    NSInteger days = 1721422;
    _solarMonth[1] = @28;
    if (yy % 4 == 0) {
        _solarMonth[1] = @29;
        if (yy > 1582) {
            if (yy % 100 == 0) {
                _solarMonth[1] = @28;
                if (yy %400 == 0) {
                    _solarMonth[1] = @29;
                }
            }
        }
    }
    days += (int)(365.25 * yym1 + 0.1);
    for (NSInteger m = 0; m < (mm - 1) ; m++) {
        days += [_solarMonth[m] intValue];
    }
    days += dd;
    if (days >= 2299160) days -= 10;
    if (yym1 >= 1600) {
        days -= (int)((yym1 - 1600 + 0.1) / 100);
        days += (int)((yym1 - 1600 + 0.1) / 400);
    }
    return days;
}


/**
 * 诸事不宜
 * //CalConv2(lY2%12,lM2%12,(lD2)%12,lY2%10,(lD2)%10,lM,lD-1,m+1,cs1);
 */
-(NSString*)anything_bad:(NSInteger)offset_ly
               offset_lm:(NSInteger)offset_lm
               offset_ld:(NSInteger)offset_ld
                      lm:(NSInteger)lm
                      ld:(NSInteger)ld
{
    NSInteger yy = (int)(offset_ly % 12);
    NSInteger mm = (int)(offset_lm % 12);
    NSInteger dd = (int)(offset_ld % 12);
    NSInteger y = (int)(offset_ly % 10);
    NSInteger d = (int)(offset_ld % 10);
    NSString* s_d =[NSString stringWithFormat:@"%ld",(long)d];
    NSString* s_dd=[NSString stringWithFormat:@"%ld",(long)dd];
    NSString *dy = [NSString stringWithFormat:@"%@%@",s_d,s_dd];
    NSInteger m = lm;
    NSInteger dt = ld;
    
    if (
        (yy==0 && dd==6)||
        (yy==6 && dd==0)||
        (yy==1 && dd==7)||
        (yy==7 && dd==1)||
        (yy==2 && dd==8)||
        (yy==8 && dd==2)||
        (yy==3 && dd==9)||
        (yy==9 && dd==3)||
        (yy==4 && dd==10)||
        (yy==10 && dd==4)||
        (yy==5 && dd==11)||
        (yy==11 && dd==5)
        ) {
        return @"日值岁破 大事不宜";
    }
    else if (
             (mm==0 && dd==6)||
             (mm==6 && dd==0)||
             (mm==1 && dd==7)||
             (mm==7 && dd==1)||
             (mm==2 && dd==8)||
             (mm==8 && dd==2)||
             (mm==3 && dd==9)||
             (mm==9 && dd==3)||
             (mm==4 && dd==10)||
             (mm==10 && dd==4)||
             (mm==5 && dd==11)||
             (mm==11 && dd==5)
             ) {
        return @"日值月破 大事不宜";
    }
    else if (
             (y==0 && [dy isEqual:@"911"])||
             (y==1 && [dy isEqual:@"55"])||
             (y==2 && [dy isEqual:@"111"])||
             (y==3 && [dy isEqual:@"75"])||
             (y==4 && [dy isEqual:@"311"])||
             (y==5 && [dy isEqual:@"95"])||
             (y==6 && [dy isEqual:@"511"])||
             (y==7 && [dy isEqual:@"15"])||
             (y==8 && [dy isEqual:@"711"])||
             (y==9 && [dy isEqual:@"35"])
             ) {
        return @"日值上朔 大事不宜";
    }
    else if (
             (m==1 && dt==13)||
             (m==2 && dt==11)||
             (m==3 && dt==9)||
             (m==4 && dt==7)||
             (m==5 && dt==5)||
             (m==6 && dt==3)||
             (m==7 && dt==1)||
             (m==7 && dt==29)||
             (m==8 && dt==27)||
             (m==9 && dt==25)||
             (m==10 && dt==23)||
             (m==11 && dt==21)||
             (m==12 && dt==19)
             ) {
        return @"日值杨公十三忌 大事不宜";
    }
    else{
        return false;
    }
    
}


/**
 * 返回农历 y年闰哪个月 1-12 , 没闰返回 0
 */
-(NSInteger)monthDays:(NSInteger)y m:(NSInteger)m
{
    return ([self lunarYY:(y-1900)] & (0x10000>>m)) ? 30 : 29;
}

/**
 * 返回农历 y年闰月的天数
 */
-(NSInteger)leapMonth:(NSInteger)y
{
    return [self lunarYY:(y-1900)] & 0xf;
}

/**
 * 返回农历 y年闰月的天数
 */
-(NSInteger)leapDays:(NSInteger)y
{
    if([self leapMonth:y])
    {
        return ([self lunarYY:(y-1900)] & 0x10000)? 30 : 29;
    }else
    {
        return 0;
    }
}


-(NSInteger)lunarYY:(NSInteger)yy
{
    NSNumber * num =  _lunarInfo[yy];
    NSInteger ll = [num integerValue];
    return ll;
}

/**
 * 返回农历 y年的总天数
 */
-(NSInteger)lYearDays:(NSInteger)y
{
    NSInteger sum = 348;
    for(NSInteger i=0x8000;i>0x8; i>>=1){
        sum +=([self lunarYY:(y-1900)]& i) ? 1 : 0;
    }
    return sum + [self leapDays:y];
}


/**
 * 返回公历 y年某m+1月的天数
 */
+(NSInteger)solarDays:(NSInteger)y m:(NSInteger)m
{
    NSArray *solarMonth = @[@31,@28,@31,@30,@31,@30,@31,@31,@30,@31,@30,@31];
    if(m == 2){
        return (((y % 4 == 0) && ( y % 100 != 0 )) ||
                (y % 400 == 0)) ? 29 : 28;
    } else {
        return [solarMonth[m-1] intValue];
    }
}

/**
 * 传入 offset 返回干支, 0=甲子
 * 把公历年减去3(干支纪年法是从公元4年开始的)除于10,余数为天干的字,减去3除于12为地支的字，这样合起来变成了该年的年柱
 */
-(NSString*)cyclical:(NSInteger)year
{
    NSString *ganStr = [NSString stringWithFormat:@"%@%@",_gan[year%10],_zhi[year%12]];
    return ganStr;
}

/**
 * 某年的第n个节气为几日(从0小寒起算)
 */
-(NSInteger)sTerm:(NSInteger)y n:(NSInteger)n
{
    NSString *str=@"1900-01-06 02:05:00 UTC";
    long long dTime = [self strToDate1970:str];// 将double转为long long型
    long long times =31556925.9747* (y-1900) + [_sTermInfo[n] intValue]*60 + dTime;
    NSDate* dt = [NSDate dateWithTimeIntervalSince1970:times];
    return [dt day];
}


//字符转换成DATE
-(NSDate*)strToDate:(NSString*)str
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate *date=[dateFormatter dateFromString:str];
    return date;
}

//DATE转换成时间戳
-(long long)dateToDate1970:(NSDate*)date
{
    NSTimeInterval time = [date timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    //    NSNumber *times = [NSNumber numberWithFloat:dTime] ;
    return dTime;
}

//字符转换成时间戳
-(long long)strToDate1970:(NSString*)str
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate *date=[dateFormatter dateFromString:str];
    NSTimeInterval time = [date timeIntervalSince1970];
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    //    NSNumber *times = [NSNumber numberWithFloat:dTime] ;
    return dTime;
}



/**
 * 对称矩阵
 */
-(NSInteger)two_dim_array:(NSInteger)x y:(NSInteger)y m:(NSInteger)m
{
    
    NSInteger criteria = (x % m) - (y % m);
    if(criteria < 0)
    {
        criteria += m;
    }
    return criteria;
}

/**
 *    0    1    2   3    4   5    6    7   8    9   10   11
 * 0 '建','除','满','平','定','执','破','危','成','收','开','闭'
 * 1 '闭','建','除','满','平','定','执','破','危','成','收','开'
 * 2 '开','闭','建','除','满','平','定','执','破','危','成','收'
 * 3 '收','开','闭','建','除','满','平','定','执','破','危','成'
 * 4 '成','收','开','闭','建','除','满','平','定','执','破','危'
 * 5 '危','成','收','开','闭','建','除','满','平','定','执','破'
 * 6 '破','危','成','收','开','闭','建','除','满','平','定','执'
 * 7 '执','破','危','成','收','开','闭','建','除','满','平','定'
 * 8 '定','执','破','危','成','收','开','闭','建','除','满','平'
 * 9 '平','定','执','破','危','成','收','开','闭','建','除','满'
 * 10'满','平','定','执','破','危','成','收','开','闭','建','除'
 * 11'除','满','平','定','执','破','危','成','收','开','闭','建'
 *
 * 根据月 和 日 用 12 取模的结果做上面二位数组的坐标找对应的值（月纵坐标，日横坐标）
 *
 * 本函数通过 一位数组 推算 二位数组对应的值
 *    0    1    2   3    4   5    6    7   8    9   10   11
 *   '建','除','满','平','定','执','破','危','成','收','开','闭'
 */
-(NSString*)jx_xiong_name:(NSInteger)lm ld:(NSInteger)ld
{
    NSInteger criteria = [self two_dim_array:ld y:lm m:12];
    return _jx_name[criteria];
}

-(NSString*)wu_xing:(NSString*)dd
{
    NSString *wx = @"";
    //    NSString *dd = [NSString stringWithFormat:@"%d",d];
    if([dd isEqual:@"00"] || [dd isEqual:@"11"]) wx=@"金";
    if([dd isEqual:@"22"] || [dd isEqual:@"33"]) wx=@"火";
    if([dd isEqual:@"44"] || [dd isEqual:@"55"]) wx=@"木";
    if([dd isEqual:@"66"] || [dd isEqual:@"77"]) wx=@"土";
    if([dd isEqual:@"88"] || [dd isEqual:@"99"]) wx=@"金";
    if([dd isEqual:@"010"]|| [dd isEqual:@"111"]) wx=@"火";
    if([dd isEqual:@"20"] || [dd isEqual:@"31"]) wx=@"水";
    if([dd isEqual:@"42"] || [dd isEqual:@"53"]) wx=@"土";
    if([dd isEqual:@"64"] || [dd isEqual:@"75"]) wx=@"金";
    if([dd isEqual:@"86"] || [dd isEqual:@"97"]) wx=@"木";
    if([dd isEqual:@"08"] || [dd isEqual:@"19"]) wx=@"水";
    if([dd isEqual:@"210"]|| [dd isEqual:@"311"]) wx=@"土";
    if([dd isEqual:@"40"] || [dd isEqual:@"51"]) wx=@"火";
    if([dd isEqual:@"62"] || [dd isEqual:@"73"]) wx=@"木";
    if([dd isEqual:@"84"] || [dd isEqual:@"95"]) wx=@"水";
    if([dd isEqual:@"06"] || [dd isEqual:@"17"]) wx=@"金";
    if([dd isEqual:@"28"] || [dd isEqual:@"39"]) wx=@"火";
    if([dd isEqual:@"410"]|| [dd isEqual:@"511"]) wx=@"木";
    if([dd isEqual:@"60"] || [dd isEqual:@"71"]) wx=@"土";
    if([dd isEqual:@"82"] || [dd isEqual:@"93"]) wx=@"金";
    if([dd isEqual:@"04"] || [dd isEqual:@"15"]) wx=@"火";
    if([dd isEqual:@"26"] || [dd isEqual:@"37"]) wx=@"水";
    if([dd isEqual:@"48"] || [dd isEqual:@"59"]) wx=@"土";
    if([dd isEqual:@"610"]|| [dd isEqual:@"711"]) wx=@"金";
    if([dd isEqual:@"80"] || [dd isEqual:@"91"]) wx=@"木";
    if([dd isEqual:@"02"] || [dd isEqual:@"13"]) wx=@"水";
    if([dd isEqual:@"24"] || [dd isEqual:@"35"]) wx=@"土";
    if([dd isEqual:@"46"] || [dd isEqual:@"57"]) wx=@"火";
    if([dd isEqual:@"68"] || [dd isEqual:@"79"]) wx=@"木";
    if([dd isEqual:@"810"]|| [dd isEqual:@"911"]) wx=@"水";
    return wx;
}


/**
 * 算出农历, 传入日期控件, 返回农历日期控件
 */
-(NSDictionary*)lunar:(NSDate*)date
{

    NSString *str= [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld UTC",[date year],[date month],[date day],[date hour],[date minute],[date second]];
    long long request_time = [self strToDate1970:str];
    long long start_time = [self strToDate1970:@"1900-01-31 00:00:00 UTC"];
    long long offset = (request_time - start_time)/ 86400;
    NSInteger tmp = 0;
    NSInteger i = 1900;
    for(i = 1900; i < 2050 && offset > 0; i++){
        
        tmp = [self lYearDays:i];
        
        offset -= tmp;
    }
    if (offset < 0 ){
        offset += tmp;
        i--;
    }
    
    //年
    NSInteger year = i;
    //闰哪个月
    NSInteger leap = [self leapMonth:i];
    BOOL is_leap = false;
    
    for(i = 1; i < 13 && offset > 0; i++){
        //闰月
        if ( leap > 0 && i == (leap + 1) && is_leap == false){
            --i;
            is_leap = true;
            tmp = [self leapDays:year];
        } else {
            tmp = [self monthDays:year m:i];
        }
        //解除闰月
        if(is_leap == true && i == (leap + 1)){
            is_leap =  false;
        }
        offset -= tmp;
    }
    
    if ( offset == 0 && i == leap + 1 && leap>0){
        if (is_leap == true){
            is_leap = false;
        } else {
            is_leap = true;
            --i;
        }
    }
    if (offset < 0 ) {
        offset += tmp;
        --i;
    }
    
    NSInteger month = i;
    long long day = offset + 1;
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%ld",year],@"year",
                                [NSString stringWithFormat:@"%ld",month],@"mon",
                                [NSString stringWithFormat:@"%llu",day],@"mday",
                                [NSString stringWithFormat:@"%d",is_leap],@"isLeap",
                                nil];
    return dictionary;
}




/**
 * 功能说明: 返回整个月的日期资料控件
 * 返回阴历控件 (y年,m+1月) => 年,零起算月
 *
 */

-(NSMutableArray*)calendar:(NSInteger)y m:(NSInteger)m tDate:(NSDate*)tDate
{

    _year  = y;
    _month = m;
    _tDate = tDate;
    
    
    //$date//当月一日日期
    NSString *str = [NSString stringWithFormat:@"%d-%d-01 00:00:00 UTC",y,m];
    NSDate *date = [self strToDate:str];
    //公历当月天数
    NSInteger length = [Tool_ChineseCalendar solarDays:y m:m];
    //公历当月1日星期几 星期天1 ... 星期六7
    NSInteger firstWeek = [date weekday] - 1; //php 0-6 objc 1-7
    //年柱 1900年立春后为庚子年(60进制36)
    NSString *cY;
    NSInteger offset_ly;
    if(m < 3 ) {
        cY = [self cyclical:(y - 1900 + 36 -1)];
        offset_ly = y-1900+36-1;
    } else {
        cY = [self cyclical:(y-1900 +36)];
        offset_ly = y - 1900 + 36;
    }
    //立春日期
    NSInteger term2 = [self sTerm:y n:2];
    
    //月柱 1900年1月小寒以前为 丙子月(60进制12)
    //返回当月「节」为几日开始
    NSInteger firstNode = [self sTerm:y n:(m-1)*2];
    //1900到目前的总的农历月数量
    
    NSInteger offset_lm = (y - 1900) * 12 + m + 11;
    NSString *cM = [self cyclical:offset_lm];
    
    //当月一日与 1900/1/1 相差天数
    //1900/1/1与 1970/1/1 相差25567日, 1900/1/1 日柱为甲戌日(60进制10)
    long long gmmk = [self strToDate1970:str];
    long long dayCyclical = gmmk / 86400 + 25567 +10;
    
    
    NSInteger lD = 1;
    NSInteger lX = 0;
    NSInteger lY = 0;
    NSInteger lM = 0;
    BOOL lL = false;
    NSInteger n = 0;
    NSInteger firstLM = 0;
    NSMutableArray *lDPOS = [NSMutableArray array];
    NSMutableArray *days = [[NSMutableArray alloc]init];
    NSInteger i;
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd"];
    for(i=1; i <= length; i++){
        if(lD > lX){
            
            NSString *sDateStr = [NSString stringWithFormat:@"%d-%d-%d 00:00:00 UTC",y,m,i];
            NSDate *sDate = [self strToDate:sDateStr];//当月一日日期
            NSDictionary * lDate = [self lunar:sDate];//农历
            lY = [lDate[@"year"] intValue];           //农历年
            lM = [lDate[@"mon"] intValue];           //农历月
            lD = [lDate[@"mday"] intValue];           //农历日
            lL = [[lDate objectForKey:@"isLeap"] intValue] ;//农历是否闰月
            lX = lL ? [self leapDays:lY] : [self monthDays:lY m:lM];//农历当月最后一天
            if(n == 0) {
                firstLM = lM;
            }
            
            lDPOS[n++] = [NSString stringWithFormat:@"%d",i-lD];
            
        }
        //依节气调整二月分的年柱, 以立春为界
        if (m == 2 && i == term2) {
            offset_ly = y - 1900 + 36;
            cY = [self cyclical:offset_lm];
        }
        //依节气月柱, 以「节」为界
        if (i == firstNode) {
            offset_lm = (y - 1900) * 12 + m + 12;
            cM = [self cyclical:offset_lm];
        }
        //日柱
        NSString *cD = [self cyclical:((int)dayCyclical +i -1)];
        NSInteger offset_ld =(int)dayCyclical+i-1;
        
        NSInteger mod_ld = offset_ld % 12;
        NSString *tmply = [NSString stringWithFormat:@"%d%d",offset_ly % 10,offset_ly % 12];
        NSString *tmplm = [NSString stringWithFormat:@"%d%d",offset_lm % 10,offset_lm % 12];
        NSString *tmpld = [NSString stringWithFormat:@"%d%d",offset_ld % 10,mod_ld];
        
        NSString *tmpStr = [NSString stringWithFormat:@"%.2d%.2d",m,i];
        
        //公历节日
        NSString *gl = @"";
        NSString *lunarFestival = @"";
        NSString *color = @"";
        if ([_sFtv objectForKey:tmpStr]) {
            gl = [_sFtv objectForKey:tmpStr];
        }
        
        //农历节日
        NSArray * ftv;
        tmpStr = [NSString stringWithFormat:@"%.2d%.2d",lM,lD];
        if ([_lDFtv objectForKey:tmpStr]) {
            ftv = [_lDFtv objectForKey:tmpStr];
            NSInteger tmp1 = [ftv[0] intValue] - firstLM;
            if (tmp1 == -11)
            {
                tmp1 = 1;
            }
            if(tmp1 >= 0 && tmp1 < n)
            {
                NSInteger idx = [lDPOS[tmp1] intValue] + [ftv[1] intValue] -1;
                if (idx >= 0 && idx < length && lL != TRUE){
                    lunarFestival =[NSString stringWithFormat:@"%@",ftv[2]];
                    if ([ftv[3]  isEqual: @"*"]){
                        color = @"red";
                    }
                }
            }
        }
        //         NSLog(@"----start----%d--%d---%d---%d----%d-----%d-----%d",y,m,i,lY,lM,lD,lL);
        
        
        NSMutableDictionary *day =  [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSString stringWithFormat:@"%d",y],@"sYear",
                                     [NSString stringWithFormat:@"%d",m],@"sMonth",
                                     [NSString stringWithFormat:@"%d",i],@"sDay",
                                     [NSString stringWithFormat:@"%d",(i-1+firstWeek)%7],@"sWeek",
                                     [NSString stringWithFormat:@"%@",_nStr1[(i-1+firstWeek)%7]],@"week",
                                     [NSString stringWithFormat:@"%d",lY],@"lYear",
                                     [NSString stringWithFormat:@"%d",lM],@"lMonth",
                                     [NSString stringWithFormat:@"%d",lD],@"lDay",
                                     [NSString stringWithFormat:@"%@",[self cDay:lD]],@"lcDay",
                                     [NSString stringWithFormat:@"%@",[self get_nongli_yue:lM]],@"lMonthCName",
                                     [NSString stringWithFormat:@"%d",lL],@"isLeap",
                                     [NSString stringWithFormat:@"%@",cY],@"cYear",
                                     [NSString stringWithFormat:@"%@",cM],@"cMonth",
                                     [NSString stringWithFormat:@"%@",cD],@"cDay",
                                     _jx_yj_map[[self jx_xiong_name:offset_lm ld:offset_ld]],@"jxyjMap",
                                     [NSString stringWithFormat:@"%@",[self jx_xiong_name:offset_lm ld:offset_ld]],@"ji_xiong",
                                     [NSString stringWithFormat:@"%@",[self anything_bad:offset_ly offset_lm:offset_lm offset_ld:offset_ld lm:m ld:i]],@"anything_bad",
                                     [NSString stringWithFormat:@"%@",[self wu_xing:tmply]],@"wxYear",
                                     [NSString stringWithFormat:@"%@",[self wu_xing:tmplm]],@"wxMonth",
                                     [NSString stringWithFormat:@"%@",[self wu_xing:tmpld]],@"wxDay",
                                     [NSString stringWithFormat:@"%@",[self get_xin_su:[self Ymd2Jd:y mm:m dd:i]]],@"xin_su",
                                     [NSString stringWithFormat:@"%@",_animals[mod_ld]],@"animal_day",
                                     [NSString stringWithFormat:@"%@",_army_animals[mod_ld]],@"chong_animal",
                                     _zhi_ji_xiong[mod_ld],@"xiong_ji_shi_cheng",
                                     [NSString stringWithFormat:@"%@",gl],@"solarFestival",
                                     [NSString stringWithFormat:@"%@",lunarFestival],@"lunarFestival",
                                     [NSString stringWithFormat:@"%@",color],@"color",
                                     UIColorFromRGB(0xf6f6f6),@"colorNote",
                                     [NSDate dateWithString:[NSString stringWithFormat:@"%d-%d-%d UTC",y,m,i]],@"DateNow",
                                     nil];
        lD++;
        days[i-1] = day;
    }
    
   
    
    //节气
    NSInteger jie_qi_day_one = [self sTerm:y n:(m-1)*2];
    NSInteger jie_qi_day_two = [self sTerm:y n:(m-1)*2 + 1];
    days[jie_qi_day_one][@"solarTerms"] = _solarTerm[(m-1)*2];
    days[jie_qi_day_two][@"solarTerms"] = _solarTerm[(m-1)*2+1];
    if(m == 3) {
        days[jie_qi_day_one][@"color"] = @"red"; //清明颜色
    }
    
    
    NSInteger  idx;
    NSInteger lastWeek;
    //月周节日
    for (NSMutableArray *ftv in _wFtv) {
        if([ftv[0] intValue] == m){
            if ([ftv[1] intValue] < 5){
                
                idx = (firstWeek > [ftv[2] intValue]?7:0) + 7*([ftv[1] intValue]-1) + [ftv[2] intValue] - firstWeek;
                
            } else {
                ////当月最后一天星期?
                lastWeek = (firstWeek + length -1)%7;
                idx = length - lastWeek - 7 * ([ftv[1] intValue] - 5)  + [ftv[2] intValue] - ([ftv[2] intValue]>lastWeek ? 7:0) - 1;
            }
            if (days[idx]){
                if (days[idx][@"solarFestival"]!=NULL){
                    days[idx][@"solarFestival"] = [NSString stringWithFormat:@"%@  %@",days[idx][@"solarFestival"],ftv[3]];
                } else{
                    days[idx][@"solarFestival"] = [NSString stringWithFormat:@"%@  ",ftv[3]];
                }
            }
        }
    }
    
    
    //复活节只出现在3或4月
    NSInteger easterMonth =[[[self yearToEaster:y] objectForKey:@"month"] intValue];
    NSInteger easterDay =[[[self yearToEaster:y] objectForKey:@"day"] intValue] -1; //数组下标
    if ((m== 3 || m == 4) && m ==  easterMonth){
        if (days[easterDay]){
            if ([days[easterDay][@"solarFestival"] isEqual: @""]){
                days[easterDay][@"solarFestival"] = @"复活节 Easter Sunday";
            }else
            {
                days[easterDay][@"solarFestival"] = [NSString stringWithFormat:@"复活节 Easter Sunday  %@",days[easterDay][@"solarFestival"]];
            }
        }
    }
    
    if (m == 3) {
        if (days[20][@"solarFestival"]){
            days[20][@"solarFestival"] = [NSString stringWithFormat:@"%@ 洵賢生日",days[20][@"solarFestival"]];
        } else {
            days[20][@"solarFestival"] = @"洵賢生日";
        }
    }
    //黑色星期五
    if ((firstWeek+ 12)%-7 == 5){
        if ([days[12][@"solarFestival"] isEqualToString:@""])
        {
            days[12][@"solarFestival"] = [NSString stringWithFormat:@"%@ 黑色星期五",days[12][@"solarFestival"]];
        }
        else
        {
            days[12][@"solarFestival"] = @"黑色星期五";
        }
    }
    
    //今日
    NSDate * nowDay = [NSDate now];
    if (y == [nowDay year] && m == [nowDay month]) {
        days[[nowDay day]-1][@"isToday"] = @"TRUE";
    }
    return days;
}

//返回复活节月份百度百科提供的算法
-(NSDictionary*)yearToEaster:(NSInteger)year
{
    NSInteger tmpY = year;
    NSInteger tmpN = tmpY - 1900;
    NSInteger tmpA = tmpN%19;
    NSInteger tmpQ = tmpN/4;
    NSInteger tmpB = floor(7*tmpA+1)/19;
    NSInteger tmpM = (11*tmpA+4-tmpB)%29;
    NSInteger tmpW = (tmpN+tmpQ+31-tmpM)%7;
    NSInteger tmpD = 25-tmpM-tmpW;
    NSInteger easterM = 0;
    NSInteger easterD = 0;
    if(tmpD <0)
    {
        easterM = 3;
        easterD = 31+tmpD;
    }if (tmpD>0) {
        easterM = 4;
        easterD = tmpD;
    }if (tmpD == 0) {
        easterM = 3;
        easterD = 31;
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSString stringWithFormat:@"%d",easterM],@"month",
            [NSString stringWithFormat:@"%d",easterD],@"day", nil];
}


/**
 * 中文日期
 */
-(NSString*)cDay:(NSInteger)d
{
    NSString *s = @"";
    NSInteger idx;
    switch (d){
        case 10:
            s = @"初十";break;
        case 20:
            s = @"二十";break;
        case 30:
            s = @"三十";break;
        default:
            idx = (int)(floor(d/10));
            s = [NSString stringWithFormat:@"%@%@",_nStr2[idx],_nStr1[d%10]];
    }
    return s;
}


+(NSString*)replaceUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}







@end
