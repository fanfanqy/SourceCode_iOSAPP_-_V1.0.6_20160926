//
//  Help.m
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/5/30.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "Help.h"
#import <CommonCrypto/CommonDigest.h>

#define IPHONESMALLCALENDAR 23
#define IPHONEMEDIUMCALENDAR 35
#define IPHONEBIGCALENDAR 41

#define IPHONESMALLCALENDARNARROW 35
#define IPHONEMEDIUMCALENDARNARROW 41
#define IPHONEBIGCALENDARNARROW 47
@implementation Help

-(int)getTimeHourIntervalByDate1{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *string = [userDefaultes objectForKey:@"lastCacheDate"];
    NSDate *date1 = [dateFormatter dateFromString:string];
     //创建了两个日期对象
    NSDate  *date=[NSDate date];
    NSString *currentDateStr=[dateFormatter stringFromDate:date];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    //取两个日期对象的时间间隔：
    NSTimeInterval time=[currentDate timeIntervalSinceDate:date1];
    int hours=((int)time)%(3600*24)/3600;
    return hours;
}

+ (NSString*)timeFormatted:(NSString *)dateString
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: 1000];
    return [NSDateFormatter localizedStringFromDate:date  dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

//根据高度度求宽度  content 计算的内容  Height 计算的高度 font字体大小
+(CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font fontName:(NSString *)fontName{

    CGRect rect = [content boundingRectWithSize:CGSizeMake(999, height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:fontName size:font]}
                                        context:nil];
    return rect.size.width;
}

//根据屏幕宽度,自己留的间距,字体和大小,计算显示的字符数组,这里做滑动label条件(这里只针对汉字)
+ (NSMutableArray *)getArrayWithContent:(NSString *)content andCount:(int)count  andIsNarrow:(BOOL)isNarrow{
    NSMutableArray *array = [NSMutableArray array];
    int  separatesLocation = 0;
    if (IS_IPHONE4 || IS_IPHONE5) {
        if (isNarrow) {
            separatesLocation = IPHONESMALLCALENDARNARROW;
            if (content.length >0 && content.length <=IPHONESMALLCALENDARNARROW) {
                count = 1;
            }else if (content.length > IPHONESMALLCALENDARNARROW && content.length <=2*IPHONESMALLCALENDARNARROW) {
                count = 2;
            }else if (content.length>2*IPHONESMALLCALENDARNARROW && content.length <=3*IPHONESMALLCALENDARNARROW){
                count = 3;
            }else if (content.length>3*IPHONESMALLCALENDARNARROW && content.length <=4*IPHONESMALLCALENDARNARROW){
                count = 4;
            }

        }else{
            separatesLocation = IPHONESMALLCALENDAR;
            if (content.length >0 && content.length <=IPHONESMALLCALENDAR) {
                count = 1;
            }else if (content.length > IPHONESMALLCALENDAR && content.length <=2*IPHONESMALLCALENDAR) {
                count = 2;
            }else if (content.length>2*IPHONESMALLCALENDAR && content.length <=3*IPHONESMALLCALENDAR){
                count = 3;
            }else if (content.length>3*IPHONESMALLCALENDAR && content.length <=4*IPHONESMALLCALENDAR){
                count = 4;
            }

        }
    }else if (IS_IPHONE6){
        if (isNarrow) {
            separatesLocation = IPHONEMEDIUMCALENDARNARROW;
            if (content.length >0 && content.length <=IPHONEMEDIUMCALENDARNARROW) {
                count = 1;
            }else if (content.length > IPHONEMEDIUMCALENDARNARROW && content.length <=2*IPHONEMEDIUMCALENDARNARROW) {
                count = 2;
            }else if (content.length>2*IPHONEMEDIUMCALENDARNARROW && content.length <=3*IPHONEMEDIUMCALENDARNARROW){
                count = 3;
            }else if (content.length>3*IPHONEMEDIUMCALENDARNARROW && content.length <=4*IPHONEMEDIUMCALENDARNARROW){
                count = 4;
            }

        }else{
            separatesLocation = IPHONEMEDIUMCALENDAR;
            if (content.length >0 && content.length <=IPHONEMEDIUMCALENDAR) {
                count = 1;
            }else if (content.length > IPHONEMEDIUMCALENDAR && content.length <=2*IPHONEMEDIUMCALENDAR) {
                count = 2;
            }else if (content.length>2*IPHONEMEDIUMCALENDAR && content.length <=3*IPHONEMEDIUMCALENDAR){
                count = 3;
            }else if (content.length>3*IPHONEMEDIUMCALENDAR && content.length <=4*IPHONEMEDIUMCALENDAR){
                count = 4;
            }

        }
    }else{
        if (isNarrow) {
            separatesLocation = IPHONEBIGCALENDARNARROW;
            if (content.length >0 && content.length <=IPHONEBIGCALENDARNARROW) {
                count = 1;
            }else if (content.length > IPHONEBIGCALENDARNARROW && content.length <=2*IPHONEBIGCALENDARNARROW) {
                count = 2;
            }else if (content.length>2*IPHONEBIGCALENDARNARROW && content.length <=3*IPHONEBIGCALENDARNARROW){
                count = 3;
            }else if (content.length>3*IPHONEBIGCALENDARNARROW && content.length <=4*IPHONEBIGCALENDARNARROW){
                count = 4;
            }
        }else{
            separatesLocation = IPHONEBIGCALENDAR;
            if (content.length >0 && content.length <=IPHONEBIGCALENDAR) {
                count = 1;
            }else if (content.length > IPHONEBIGCALENDAR && content.length <=2*IPHONEBIGCALENDAR) {
                count = 2;
            }else if (content.length>2*IPHONEBIGCALENDAR && content.length <=3*IPHONEBIGCALENDAR){
                count = 3;
            }else if (content.length>3*IPHONEBIGCALENDAR && content.length <=4*IPHONEBIGCALENDAR){
                count = 4;
        }
        }
    }

    //一行能显示多少个字符
        if (count == 1) {

            NSMutableString *string = [[NSMutableString alloc]initWithString:content] ;
            if ((IS_IPHONE4 || IS_IPHONE5) && !isNarrow) {
                NSRange range = NSMakeRange(11, 1);
                if (string.length>11) {
                    [string replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }
            if (IS_IPHONE6_PLUS && isNarrow) {
                NSRange range = NSMakeRange(23, 1);
                if (string.length>23) {
                    [string replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }
            [array addObject:string];

        }
        if(count == 2){

            NSString *s1 = [content substringWithRange:NSMakeRange(0, separatesLocation)];
            NSString *s2 = [content substringWithRange:NSMakeRange(separatesLocation+1, [content length]-separatesLocation-1)];
            s2 = [s2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];


            NSMutableString *string = [[NSMutableString alloc]initWithString:s1] ;
            if ((IS_IPHONE4 || IS_IPHONE5) && !isNarrow) {
                NSRange range = NSMakeRange(11, 1);
                if (string.length>11) {
                [string replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }
            if (IS_IPHONE6_PLUS && isNarrow) {
                NSRange range = NSMakeRange(23, 1);
                if (string.length>24) {
                [string replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }


            NSMutableString *string1 = [[NSMutableString alloc]initWithString:s2] ;
            if ((IS_IPHONE4 || IS_IPHONE5) && !isNarrow) {
                NSRange range = NSMakeRange(11, 1);
                if (string1.length>11) {
                [string1 replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }
            if (IS_IPHONE6_PLUS && isNarrow) {
                NSRange range = NSMakeRange(23, 1);
                if (string1.length>23) {
                [string1 replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }

            [array addObject:string];
            [array addObject:string1];

        }

        if (count == 3){
            NSString *s1 = [content substringWithRange:NSMakeRange(0, separatesLocation)];
            NSString *s2 = [content substringWithRange:NSMakeRange(separatesLocation+1, separatesLocation)];
             s2 = [s2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *s3 = [content substringWithRange:NSMakeRange(2*separatesLocation+1, [content length]-2*separatesLocation-1)];
             s3 = [s3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSMutableString *string = [[NSMutableString alloc]initWithString:s1] ;
            if ((IS_IPHONE4 || IS_IPHONE5) && !isNarrow) {
                NSRange range = NSMakeRange(11, 1);
                if (string.length>11) {
                [string replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }
            if (IS_IPHONE6_PLUS && isNarrow) {
                NSRange range = NSMakeRange(23, 1);
                if (string.length>23) {
                [string replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }

            NSMutableString *string1 = [[NSMutableString alloc]initWithString:s2] ;
            if ((IS_IPHONE4 || IS_IPHONE5) && !isNarrow) {
                NSRange range = NSMakeRange(11, 1);
                if (string1.length>11) {
                [string1 replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }
            if (IS_IPHONE6_PLUS && isNarrow) {
                NSRange range = NSMakeRange(23, 1);
                if (string1.length>23) {
                [string1 replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }

            NSMutableString *string2 = [[NSMutableString alloc]initWithString:s3] ;
            if ((IS_IPHONE4 || IS_IPHONE5) && !isNarrow) {
                NSRange range = NSMakeRange(11, 1);
                if (string2.length>11) {
                [string2 replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }
            if (IS_IPHONE6_PLUS && isNarrow) {
                NSRange range = NSMakeRange(23, 1);
                if (string2.length>23) {
                [string2 replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }
            
            [array addObject:string];
            [array addObject:string1];
            if ([[string2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) {
                [array addObject:string2];
            }

        }
        if (count == 4){
            NSString *s1 = [content substringWithRange:NSMakeRange(0, separatesLocation)];
            NSString *s2 = [content substringWithRange:NSMakeRange(separatesLocation+1, separatesLocation)];
             s2 = [s2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *s3 = [content substringWithRange:NSMakeRange(2*separatesLocation+1, separatesLocation)];
             s3 = [s3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *s4 = [content substringWithRange:NSMakeRange(3*separatesLocation+1, [content length]-3*separatesLocation-1)];
             s4 = [s4 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSMutableString *string = [[NSMutableString alloc]initWithString:s1] ;
            if ((IS_IPHONE4 || IS_IPHONE5) && !isNarrow) {
                NSRange range = NSMakeRange(11, 1);
                if (string.length>11) {
                [string replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }
            if (IS_IPHONE6_PLUS && isNarrow) {
                NSRange range = NSMakeRange(23, 1);
                if (string.length>23) {
                [string replaceOccurrencesOfString:@" " withString:@"   " options:NSCaseInsensitiveSearch range:range];
                }
            }

            NSMutableString *string1 = [[NSMutableString alloc]initWithString:s2] ;
            if ((IS_IPHONE4 || IS_IPHONE5) && !isNarrow) {
                NSRange range = NSMakeRange(11, 1);
                if (string1.length>11) {
                [string replaceOccurrencesOfString:@" " withString:@"   " options:NSCaseInsensitiveSearch range:range];
                }
            }
            if (IS_IPHONE6_PLUS && isNarrow) {
                NSRange range = NSMakeRange(23, 1);
                 if (string1.length>23) {
                [string1 replaceOccurrencesOfString:@" " withString:@"   " options:NSCaseInsensitiveSearch range:range];
                 }
            }

            NSMutableString *string2 = [[NSMutableString alloc]initWithString:s3] ;
            if ((IS_IPHONE4 || IS_IPHONE5) && !isNarrow) {
                NSRange range = NSMakeRange(11, 1);
                if (string2.length>11) {
                [string2 replaceOccurrencesOfString:@" " withString:@"  " options:NSCaseInsensitiveSearch range:range];
                }
            }
            if (IS_IPHONE6_PLUS && isNarrow) {
                NSRange range = NSMakeRange(23, 1);
                if (string2.length>23) {
                [string2 replaceOccurrencesOfString:@" " withString:@"   " options:NSCaseInsensitiveSearch range:range];
                }
            }

            NSMutableString *string3 = [[NSMutableString alloc]initWithString:s4] ;
            if ((IS_IPHONE4 || IS_IPHONE5) && !isNarrow) {
                NSRange range = NSMakeRange(11, 1);
                if (string3.length>11) {
                [string3 replaceOccurrencesOfString:@" " withString:@"   " options:NSCaseInsensitiveSearch range:range];
                }
            }
            if (IS_IPHONE6_PLUS && isNarrow) {
                NSRange range = NSMakeRange(23, 1);
                if (string3.length>23) {
                [string3 replaceOccurrencesOfString:@" " withString:@"   " options:NSCaseInsensitiveSearch range:range];
                }
            }
            [array addObject:string];
            [array addObject:string1];
            if ([[string2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) {
                [array addObject:string2];
            }
            if ([[string3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]>0) {
                [array addObject:string3];
            }
        }
    return array;
}

//截取scrollView 长图也支持
+(UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    //0.0高质量
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);

        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();

        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();

    if (image != nil) {
        return image;
    }
    return nil;
}

//屏幕截图
+(UIImage*)captureView:(UIView *)theView{
    CGRect rect = theView.frame;
    if ([theView isKindOfClass:[UIScrollView class]]) {
        rect.size = ((UIScrollView *)theView).contentSize;
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+(NSDictionary *)getJianFa{
 NSDictionary *dic  = @{@"初一":@"生命短",@"初二":@"病多,麻烦多",@"初三":@"变成富裕人家",@"初四":@"怀业增广,气色好",@"初五":@"增长财物",@"初六":@"气色转衰",@"初七":@"易招闲言，麻烦多",@"初八":@"长寿",@"初九":@"易遇年轻女子",@"初十":@"增长快乐",@"十一":@"增长出世间的智慧与世间的聪明",@"十二":@"招病,生命危险",@"十三":@"精进于佛法，最好",@"十四":@"东西增多",@"十五":@"增上福报",@"十六":@"得病",@"十七":@"容易失明,皮肤变绿",@"十八":@"丢失财物",@"十九":@"佛法增长",@"二十":@"容易挨饿，不好",@"二十一":@"易招传染病",@"二十二":@"病情加重",@"二十三":@"家族富裕",@"二十四":@"遇传染病",@"二十五":@"得沙眼，出迎风泪",@"二十六":@"得安乐",@"二十七":@"吉祥",@"二十八":@"易发生打架",@"二十九":@"掉魂,声音变哑",@"三十":@"预见被争讼及死人",@"十月初八":@"忏净罪孽",@"十一月初八":@"忏净罪孽",@"十二月二十五":@"增长智慧"};
    return dic;
}


/** md5加密 */
-( NSString *)md5String:( NSString *)str
{
    const char *myPasswd = [str UTF8String ];
    unsigned char mdc[ 16 ];
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    NSMutableString *md5String = [ NSMutableString string ];
    for ( int i = 0 ; i< 16 ; i++) {
        [md5String appendFormat : @"%02x" ,mdc[i]];
    }
    return md5String;
}

+(BOOL)hasAppUpdated{
    
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    NSLog(@"%@",[userDefaultes objectForKey:@"APP_VERSION"]);
//    NSLog(@"%@",[userDefaultes objectForKey:@"LAST_APP_VERSION"]);
//
//    if ([  [userDefaultes objectForKey:@"APP_VERSION"] isEqualToString:[userDefaultes objectForKey:@"Last_APP_VERSION"]]) {
//        return NO;
//    }else{
//
//        return YES;
//    }

    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[userDefaultes objectForKey:@"APP_VERSION"]);
    NSLog(@"%@",[userDefaultes objectForKey:@"LAST_APP_VERSION"]);
    NSString *strAPP_VERSION = [userDefaultes objectForKey:@"APP_VERSION"];
    NSString *strLast_APP_VERSION = [userDefaultes objectForKey:@"LAST_APP_VERSION"];
    strAPP_VERSION = [strAPP_VERSION stringByReplacingOccurrencesOfString:@"." withString:@""];
    strLast_APP_VERSION = [strLast_APP_VERSION stringByReplacingOccurrencesOfString:@"." withString:@""];

    if ([strAPP_VERSION intValue] == [strLast_APP_VERSION intValue]) {
        return NO;
    }else{
        return YES;
    }
}

//
//-(CGFloat)getBlankSpaceWidthwithFont:(CGFloat)font fontName:(NSString *)fontName{
//    NSString *str = @"空                              格";//30个空格
//    NSString *str1 = @"空格";
//    CGFloat width1 = [Help getWidthWithContent:str height:35 font:font fontName:fontName];
//    CGFloat width2 = [Help getWidthWithContent:str1 height:35 font:font fontName:fontName];
//    return (width1 - width2)/30;
//}
//
//-(int)getCountWithString:(NSString *)string{
//
//    int count = 0;
//    for (int i = 0; i<[string length]; i++) {
//        //截取字符串中的每一个字符
//        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
//        NSLog(@"string is %@",s);
//        if ([s isEqualToString:@" "]) {
//            count++;
//        }
//    }
//    return count;
//
//}
+ (UIImage *)getImageWithAqi:(NSInteger)aqi Icon:(NSString *)icon{
    if (aqi == 0) {
        return nil;
    }else{
        NSString * path = [Help getAqiImage:aqi];
        if (path) {
            // 空气质量小于3并且天气为雾霾时,不显示空气质量
            if (aqi < 3 && [icon isEqualToString:@"hazy"]) {
                return [UIImage imageNamed:@"airMild.png"];
            } else {
                return [UIImage imageWithContentsOfFile:path];
            }
        }else{
            return nil;
        }
    }
}

+ (NSString *)getAqiImage:(NSInteger)aqi{
    NSString * path = nil;
    switch (aqi) {
        case 1:
            path = [[NSBundle mainBundle]pathForResource:@"airGood.png" ofType:nil];
            break;
        case 2:
            path = [[NSBundle mainBundle]pathForResource:@"airFine.png" ofType:nil];
            break;
        case 3:
            path = [[NSBundle mainBundle]pathForResource:@"airMild.png" ofType:nil];
            break;
        case 4:
            path = [[NSBundle mainBundle]pathForResource:@"airMidium.png" ofType:nil];
            break;
        case 5:
            path = [[NSBundle mainBundle]pathForResource:@"airSerious.png" ofType:nil];
            break;
        case 6:
            path = [[NSBundle mainBundle]pathForResource:@"airBad.png" ofType:nil];
            break;
        default:
            break;
    }
    return path;
}
@end












