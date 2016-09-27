//
//  CacheDataManager.h
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/6/2.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheDataManager : NSObject
// 创建目录
-(instancetype)initFile;

-(BOOL)isExistCacheFile;

//创建壁纸列表缓存文件,此时需要提供一个文件名,
-(void)createWallpaperFileWithFileName:(NSString *)fileName andData:(NSArray *)dic;

//创建天气列表缓存文件,此时需要提供一个文件名,
-(void)createWeatherFileWithFileName:(NSString *)fileName andData:(NSDictionary *)dic;

//提供文件名,读取壁纸列表缓存文件,传回文件数据
-(NSArray *)requestLocalWallperData:(NSString *)fileName;

//提供文件名,读取城市天气缓存文件,传回文件数据
-(NSDictionary *)requestLocalWeatherData:(NSString *)fileName;

//删除文件,即清除缓存,此时可删除整个存储请求来的数据文件夹
-(void)clearCache;

//删除文件
-(void)deleteFileWithName:(NSString *)fileName;
@end
