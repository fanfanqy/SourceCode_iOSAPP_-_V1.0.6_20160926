//
//  JSNet.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/7/21.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "JSNet.h"
#import "AppDelegate.h"
#import "DBModel.h"
#import "Utils.h"
//#import "AppDelegate.h"
#import "SqlDataBase.h"
#import "Help.h"
@interface JSNet ()
@end

@implementation JSNet
- (NSString *)token{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *token =  [userDefaultes objectForKey:@"TOKEN"];
    return token;
}
- (void)startWithURLstring:(NSString *)URLstring type:(NSString *)type parmaters:(NSDictionary *)parmaters finishBlock:(void (^)(NSData * data))block{
    self.finishDataBlock = block;
    NSMutableURLRequest *request = [self setRequestWithUrl:URLstring Parmaters:parmaters Type:type];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [delegate addLoadView];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                [delegate removeLoadView];
                self.finishDataBlock(data);
            }else{
                [delegate removeLoadView];
                [delegate addRequestErrorView];
            
            }
        });
    }];
    [dataTask resume];
}

- (void)startWithURLstring:(NSString *)URLstring type:(NSString *)type parmaters:(NSDictionary *)parmaters successBlock:(NetSuccessCall)successBlock  failureBlock:(NetFailureCall)failureBlock{

    NSMutableURLRequest *request = [self setRequestWithUrl:URLstring Parmaters:parmaters Type:type];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [delegate addLoadView];

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                [delegate removeLoadView];
                successBlock(data);
            }else{
                NSLog(@"%s,%@",__func__,error.localizedDescription);
                failureBlock(error);
                [delegate removeLoadView];
                [delegate addRequestErrorView];
            }
        });
    }];
    [dataTask resume];
}

- (NSMutableURLRequest *)setRequestWithUrl:(NSString *)urlString Parmaters:(NSDictionary *)parmaters Type:(NSString *)type{
    NSMutableURLRequest *request = nil;
    if ([type isEqualToString:@"POST"]) {
        NSURL *url = [NSURL URLWithString:urlString];
        request = [NSMutableURLRequest requestWithURL:url];
        request.timeoutInterval = 15;
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parmaters options:0 error:nil]];
    } else {
        if (parmaters != nil) {
            NSString *par = [self parmatersToString:parmaters];
            urlString = [NSString stringWithFormat:@"%@%@", urlString, par];
        }
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        request = [NSMutableURLRequest requestWithURL:url];
        request.timeoutInterval = 15;
        [request setHTTPMethod:@"GET"];
    }
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return request;
}
- (NSString *)parmatersToString:(NSDictionary *)parmaters{
    NSString *par = @"";
    for (NSString *key in parmaters) {
        if ([par length] == 0) {
            par = [NSString stringWithFormat:@"?%@=%@",key, [parmaters objectForKey:key]];
        }else
        {
            par = [NSString stringWithFormat:@"%@&%@=%@", par, key, [parmaters objectForKey:key]];
        }
    }
    return par;
}

// 请求壁纸列表请求
+ (void)handleWallPaperListFinishDataBlock:(void (^)(NSData * data))block{
    // 返回的格林治时间
    NSDate *dateUtc = nil;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (![user objectForKey:@"RequestDataTime"]) {
        dateUtc = nil;
        
    }else{
        NSDate *date1 = [user objectForKey:@"RequestDataTime"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //输入格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *str = [dateFormatter stringFromDate:date1];
        NSDate *dateFormatted = [dateFormatter dateFromString:str];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        //输出格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
        dateUtc = [dateFormatter dateFromString:dateString];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // HH是24进制，hh是12进制
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *string = nil;
    if (dateUtc!=nil) {
        string = [formatter stringFromDate:dateUtc];
    }else{
        string = @"1970-01-01 00:00:00";
    }
    
    JSNet * net = [[JSNet alloc]init];
    NSString * par = [NSString stringWithFormat:@"%@?token='%@'&hash=%d&updatedDateUtc='%@'&minWidth=%d&maxWidth=%0.f&minHeight=%d&maxHeight=%0.0f",WallPaperList, net.token, 999, string,0,WallPaper_width,0,WallPaper_height];

    [net startWithURLstring:par type:@"GET" parmaters:nil finishBlock:^(NSData *data) {
        net.finishDataBlock = block;

        net.finishDataBlock(data);
    }];
}

+ (void)handleWallPaperListSuccess:(NetSuccessCall )success Failure:(NetFailureCall )failure{
    // 返回的格林治时间
    NSDate *dateUtc = nil;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if (![user objectForKey:@"RequestDataTime"]) {
        dateUtc = nil;
    }else{
        NSDate *date1 = [user objectForKey:@"RequestDataTime"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //输入格式
        NSDate *dateFormatted = [dateFormatter dateFromString:[dateFormatter stringFromDate:date1]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"]; //输出格式
        dateUtc = [dateFormatter dateFromString:[dateFormatter stringFromDate:dateFormatted]];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *string = nil;
    if (dateUtc!=nil) {
        string = [formatter stringFromDate:dateUtc];
    }else{
        string = @"1970-01-01 00:00:00";
    }

    JSNet * net = [[JSNet alloc]init];
    NSString * par = [NSString stringWithFormat:@"%@?token='%@'&hash=%d&updatedDateUtc='%@'&minWidth=%d&maxWidth=%0.f&minHeight=%d&maxHeight=%0.0f",WallPaperList, net.token, 999, string,0,WallPaper_width,0,WallPaper_height];
    [net startWithURLstring:par type:@"GET" parmaters:nil successBlock:^(NSData *data) {
        success(data);
    } failureBlock:^(id error) {
        failure(error);
    }
    ];

}
// 请求Aqi
+ (void)handlAqiWithCityModel:(DBModel * )cityModel Mark:(NSInteger)mark finishAqiBlock:(void (^)(NSUInteger mark,NSInteger aqi))block{
    JSNet * net = [[JSNet alloc]init];
    net.finishAqiBlock = block;
    net.mark = mark;
    
    NSString * cityName = cityModel.cityCC;
    cityName = [cityName stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    if ([cityName isEqual:nil] || [cityName isEqualToString:@""] || ![Utils isAllChineseInString:cityName]) {
        net.finishAqiBlock(mark, 0);
        return;
    }
    NSString *name = [cityName substringWithRange:NSMakeRange(([cityName length] - 1), 1)];
    if ([name compare:@"市"] == 0) {
        cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    NSString * urlstr = [NSString stringWithFormat:WeatherAqi,net.token,cityName];
    [net startWithURLstring:urlstr type:@"GET" parmaters:nil finishBlock:^(NSData *data) {
        NSInteger aqi = [net getAqi:data ];
        net.finishAqiBlock(mark, aqi);
    }];
}
- (NSString *)culture{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *culture = delegate.languageCode;
    if ([delegate.languageCode isEqualToString:@"zh"]) {
        culture = @"'zh-cn'";
    }else{
        culture = @"'en-us'";
    }
    return culture;
}
// 请求天气
+ (void)handleWeatherWithCityModel:(DBModel *)cityModel Mark:(NSInteger)mark FinishBlock:(void(^)(NSData *data, NSUInteger mark))block{

    JSNet * net = [[JSNet alloc]init];
    net.finishBlock = block;
    net.mark = mark;
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    SqlDataBase *sqldata = [[SqlDataBase alloc]init];
//    [sqldata configDatabase];
    NSArray * arr = [sqldata searchAllSaveCity];
    NSMutableDictionary * parmaters;
    parmaters = [@{@"token":[NSString stringWithFormat:@"'%@'", net.token],
                   @"sourceId":[NSString stringWithFormat:@"%ld", (long)delegate.meteorologicalSource],
                   @"culture":[net culture]
                   } mutableCopy];
    if (arr.count == 0 || [[cityModel.qwz substringWithRange:NSMakeRange(0, 3)] isEqualToString:@"qwz"]) {
        int temp = [cityModel.lat intValue];
        if (!temp) {
            return;
        }
        [parmaters setObject:[NSString stringWithFormat:WeatherUrlPart,[cityModel.lat doubleValue],[cityModel.lon doubleValue]] forKey:@"urlPart"];
    }else{
        [parmaters setObject:[NSString stringWithFormat:WeatherUrlAccordingL,cityModel.qwz] forKey:@"urlPart"];
    }
    [net startWithURLstring:WeatherUrl type:@"GET" parmaters:parmaters finishBlock:^(NSData *data) {
        net.finishBlock(data, mark);
    }];
    
}
+ (void)searchCityWithString:(NSString *)cityString FinishBlock:(void (^)(NSData * data))block{
    
    JSNet * net = [[JSNet alloc]init];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *culture = [net culture];
    NSMutableString *str = [[NSMutableString alloc]initWithString:cityString];
    [str replaceOccurrencesOfString:@" " withString:@"_" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
    
    NSDictionary * parmaters = @{@"token":[NSString stringWithFormat:@"'%@'",net.token],
                                 @"sourceId":[NSString stringWithFormat:@"%ld", (long)delegate.meteorologicalSource],
                                 @"urlPart":[NSString stringWithFormat:SearchCityUrlPart,str],
                                 @"culture":culture
                                 };
    [net startWithURLstring:WeatherUrl type:@"GET" parmaters:parmaters finishBlock:^(NSData *data) {
        net.finishDataBlock = block;
        net.finishDataBlock(data);
    }];
}
+ (void)handleFeedBackCategoriesFinishBlock:(void(^)(NSData *data))block{
    JSNet * net = [[JSNet alloc]init];
    net.finishDataBlock = block;
    NSDictionary * parmaters = @{@"CultureName":[net culture]};
    
    [net startWithURLstring:GetFeedBackCategories type:@"GET" parmaters:parmaters finishBlock:^(NSData *data) {
        net.finishDataBlock = block;
        net.finishDataBlock(data);
    }];
}
+(void)submitFeedBackWithCategory:(NSString *)category Contents:(NSString *)contents finishBlock:(void (^)(NSData * data))block{
    JSNet * net = [[JSNet alloc]init];
    NSDictionary * dic = @{@"Token":net.token,
                           @"Category":category,
                           @"Contents":contents};
    
    [net startWithURLstring:FeedbackUrl type:@"POST" parmaters:dic finishBlock:^(NSData *data) {
        net.finishDataBlock = block;
        net.finishDataBlock(data);
    }];
}
+ (void)appRegisterWithFinishBlock:(void (^)(BOOL))block{
    JSNet * net = [[JSNet alloc]init];
    net.finishRegister = block;
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    NSString *tokenString =[NSString stringWithFormat:@"%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
//    NSDictionary * parmaters = @{@"token":tokenString};
//    [net startWithURLstring:TOKENURL type:@"GET" parmaters:parmaters finishBlock:^(NSData *data) {
//        [userDefaultes setObject:tokenString forKey:@"TOKEN"];
//        [userDefaultes synchronize];
//        net.finishRegister(YES);
//    }];
    /****************/
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *tokenString =[NSString stringWithFormat:@"%@",[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    Help *help = [[Help alloc]init];
    tokenString =[help md5String:tokenString];
    NSMutableURLRequest *request = nil;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jyjs.hk/service/sq/user.asmx/AppRegister?token=%@",tokenString]];
    request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 15;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //            NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error == nil) {
                NSLog(@"请求成功");
                [userDefaultes setObject:tokenString forKey:@"TOKEN"];
                [userDefaultes synchronize];
                net.finishRegister(YES);
            }else{
                NSLog(@"各种请求失败:%@", error.localizedDescription);
                net.finishRegister(NO);
            }
        });
    }];
    [dataTask resume];
    
    
}
- (NSInteger)getAqi:(NSData *)data{
    NSError * error = nil;
    NSDictionary * finishDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (!error) {
        NSString * dataString = [finishDic objectForKey:@"d"];
        if ((NSNull *)dataString != [NSNull null]) {
            NSData * finishData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
            NSError * error = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:finishData options:NSJSONReadingMutableContainers error:&error];
            NSInteger temp = 0;
            if (!error) {
                NSDictionary * dictionary = [dic objectForKey:@"retData"];
                if ([dictionary isKindOfClass:[NSDictionary class]]) {
                    NSInteger aqi = [[dictionary objectForKey:@"aqi"] integerValue];
                    if (aqi >= 0 && aqi <= 50) {
                        temp = 1; // 优
                    } else if(aqi >= 51 && aqi <= 100) {
                        temp = 2; // 良
                    }else if(aqi >= 101 && aqi <= 150) {
                        temp = 3; // 轻度污染
                    }else if(aqi >= 151 && aqi <= 200) {
                        temp = 4; // 中度污染
                    }else if(aqi >= 201 && aqi <= 300) {
                        temp = 5; // 重度污染
                    }else if(aqi >= 301) {
                        temp = 6; // 严重污染
                    }else{
                        temp = 0; // 无空气质量
                    }
                }
                return temp;
            }
           
        }
    }
    return 0;
}
+ (BOOL)hasRegister{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    if (![userDefaultes objectForKey:@"TOKEN"]) {
        return NO;
    }else{
        return YES;
    }
}
+ (void)handleSunTimesInPeriodWithCityModel:(DBModel *)cityModel FinishBlock:(void (^)(NSData * data))block{
    JSNet * net = [[JSNet alloc]init];
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * datatime = [formatter stringFromDate:date];

    NSDictionary * dic = @{@"token":[NSString stringWithFormat:@"'%@'",net.token],
                           @"lat":cityModel.lat,
                           @"lon":cityModel.lon,
                           @"date":[NSString stringWithFormat:@"'%@'", datatime],
                           @"period":@"10"
                           };
    [net startWithURLstring:SunTimesInPeriod type:@"GET" parmaters:dic finishBlock:^(NSData *data) {
        net.finishDataBlock = block;
        net.finishDataBlock(data);
    }];
}
@end
