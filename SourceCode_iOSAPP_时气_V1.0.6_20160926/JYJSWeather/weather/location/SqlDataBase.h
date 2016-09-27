//
//  SqlDataBase.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/18.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBModel;

@interface SqlDataBase : NSObject

// 初始化SelectedWallpaperListDB数据库
- (void)configSelectedWallpaperListDB;
// 初始化非SelectedWallpaperListDB数据库
- (void)configDatabase;
// 清空SelectedWallpaperListDB 表数据
- (void)eraseTableInSelectedWallpaperListDB;
// 根据输入搜索相应城市
-(NSMutableArray *)searchWithString:(NSString *)searchString andIsPinyin:(BOOL)isPinyin andLocationCityModel:(DBModel *)locationCitymodel;

// 定位后,根据定位信息搜索当前城市
- (DBModel *)searchWithCityName:(NSString *)cityName;

// 搜索所有保存的城市
- (NSMutableArray *)searchAllSaveCity;
// 删除保存的城市
- (void)deleateCityFromSaveCity:(DBModel *)model;
// 保存想要查询天气的城市
- (void)saveCityToDB:(DBModel *)model;
// 根据条件,查询是否含有单个的城市
- (DBModel *)searchOneCity:(DBModel *)model;

//获取"10张"壁纸
- (NSArray *)achieveTenWallper:(int)beginPages andWallpaperKind:(int)wallpaperKind;
//添加壁纸到ServerWallPaperList
-(void)addWallperToServerWallPaperList:(NSArray *)array;
//添加壁纸
- (void)addWallper:(NSArray *)array;
//获取数据库中表中数据总数
- (int)achieveTableDataNum:(NSString *)tableName;

@end
