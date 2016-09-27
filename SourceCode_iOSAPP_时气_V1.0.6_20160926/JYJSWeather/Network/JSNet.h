//
//  JSNet.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/7/21.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBModel;

@interface JSNet : NSObject
@property (nonatomic, strong)void (^finishDataBlock)(NSData * data);
@property (nonatomic, strong)void (^finishBlock)(NSData * data ,NSUInteger mark);
@property (nonatomic, strong)void (^finishRegister)(BOOL isFinishRegister);
@property (nonatomic, strong)void (^finishAqiBlock)(NSUInteger mark,NSInteger aqi);
@property (nonatomic , assign) NSInteger mark;
@property (nonatomic , readonly) NSString * token;

//网络成功的回调
typedef void (^NetSuccessCall)(id response);
//网络失败的回调
typedef void (^NetFailureCall)(id error);

+ (void)handleWallPaperListFinishDataBlock:(void (^)(NSData * data))block;
+ (void)handleWallPaperListSuccess:(NetSuccessCall )success Failure:(NetFailureCall )failure;

+ (void)handlAqiWithCityModel:(DBModel * )cityModel Mark:(NSInteger)mark finishAqiBlock:(void (^)(NSUInteger mark,NSInteger aqi))block;

+ (void)handleWeatherWithCityModel:(DBModel *)cityModel Mark:(NSInteger)mark FinishBlock:(void(^)(NSData *data, NSUInteger mark))block;

+ (void)handleFeedBackCategoriesFinishBlock:(void(^)(NSData *data))block;

+(void)submitFeedBackWithCategory:(NSString *)category Contents:(NSString *)contents finishBlock:(void (^)(NSData * data))block;

+ (void)appRegisterWithFinishBlock:(void (^)(BOOL))block;
+(BOOL)hasRegister;

+ (void)handleSunTimesInPeriodWithCityModel:(DBModel *)cityModel FinishBlock:(void (^)(NSData * data))block;
+ (void)searchCityWithString:(NSString *)cityString FinishBlock:(void (^)(NSData * data))block;
@end
