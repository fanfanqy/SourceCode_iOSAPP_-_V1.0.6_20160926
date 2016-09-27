//
//  Help.h
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/5/30.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Help : NSObject
//#pragma mark fqy  含有视图的delegate,不能用继承nsobject的类,来接收消息
//-(void)versionCheckUpdate;
//返回 过去某一个时间距离现在有几个小时
-(int)getTimeHourIntervalByDate1;
//根据高度度求宽度  content 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font fontName:(NSString *)fontName;

//根据屏幕宽度,自己留的间距,字体和大小,计算显示的字符数组,这里做滑动label条件
+ (NSMutableArray *)getArrayWithContent:(NSString *)content andCount:(int)count andIsNarrow:(BOOL)isNarrow;

//截取scrollView 长图也支持
+(UIImage *)captureScrollView:(UIScrollView *)scrollView;

//屏幕截图,scrollview 长的图,会缩放成一个屏幕大小
+(UIImage*)captureView:(UIView *)theView;

//md5
-( NSString *)md5String:( NSString *)str;

//理发数据
+(NSDictionary *)getJianFa;

//是否已经更新
+(BOOL)hasAppUpdated;
// 根据aqi选择相应图片路径
+ (NSString *)getAqiImage:(NSInteger)aqi;
// 根据aqi和天气,判断空气质量图片(主要解决雾霾天空气质量良)
+ (UIImage *)getImageWithAqi:(NSInteger)aqi Icon:(NSString *)icon;
@end
