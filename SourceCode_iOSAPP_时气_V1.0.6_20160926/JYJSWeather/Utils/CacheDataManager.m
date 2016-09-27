//
//  CacheDataManager.m
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/6/2.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "CacheDataManager.h"

#define CACHEFILEPATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation CacheDataManager
{
    NSFileManager *_fileManager;
}

// 创建目录
-(instancetype)initFile
{
    if (self = [super init]) {
        _fileManager = [NSFileManager defaultManager];
        if ([_fileManager fileExistsAtPath:[CACHEFILEPATH stringByAppendingPathComponent:@"DIR"]]){
            NSLog(@"createDirectoryAtPath------存在");
        }
        else{
            NSError *error;
#pragma mark  warning Documents 
            [_fileManager createDirectoryAtPath:[CACHEFILEPATH stringByAppendingPathComponent:@"DIR"]withIntermediateDirectories:YES attributes:nil error:&error];

            NSLog(@"%@",[CACHEFILEPATH stringByAppendingPathComponent:@"DIR"]);

            if (error) {
                NSLog(@"createDirectoryAtPath---Error:%@",error);
                exit(0);
            }
        }
    }
    return self;
}

-(BOOL)isExistCacheFile{
    if ([_fileManager fileExistsAtPath:[CACHEFILEPATH stringByAppendingPathComponent:@"DIR"]]){
        return YES;
    }
    return NO;

}
//创建文件,此时需要提供一个文件名,
-(void)createWallpaperFileWithFileName:(NSString *)fileName andData:(NSArray *)array
{
    NSString *string = [NSString stringWithFormat:@"DIR/%@",fileName];
    NSString *filePath = [CACHEFILEPATH stringByAppendingPathComponent:string];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    if ([_fileManager fileExistsAtPath:filePath])
    { NSLog(@"---------createFileWithFileName---andData---存在");
        //如果文件已经存在,需要先进行删除操作
        [self deleteFileWithName:fileName];
        BOOL result = [_fileManager createFileAtPath:filePath contents:data attributes:nil];
        if (result) {
             NSLog(@"---------createFileWithFileName---andData---成功");
            NSLog(@"%@",filePath);
        }
//        else
//            exit(-1);
    }

    else {
        NSLog(@"不存在");
        BOOL result = [_fileManager createFileAtPath:filePath contents:data attributes:nil];
        NSLog(@"%@",filePath);
        if (result) {
            NSLog(@"---------createFileAtPath---成功");

        }
        else
            NSLog(@"文件创建失败");
    }
}

//创建天气缓存文件,此时需要提供一个文件名,
-(void)createWeatherFileWithFileName:(NSString *)fileName andData:(NSDictionary *)dic{
    NSString *string = [NSString stringWithFormat:@"DIR/%@",fileName];
    NSString *filePath = [CACHEFILEPATH stringByAppendingPathComponent:string];
//     NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
     NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    if ([_fileManager fileExistsAtPath:filePath])
    { NSLog(@"---------createFileWithFileName---andData---存在");
        //如果文件已经存在,需要先进行删除操作
        [self deleteFileWithName:fileName];
        BOOL result = [_fileManager createFileAtPath:filePath contents:data attributes:nil];
        if (result) {
            NSLog(@"---------createFileWithFileName---andData---成功");
            NSLog(@"%@",filePath);
        }
//        else
//            exit(-1);
    }

    else {
        NSLog(@"不存在");

        BOOL result = [_fileManager createFileAtPath:filePath contents:data attributes:nil];
        NSLog(@"%@",filePath);
        if (result) {
            NSLog(@"---------createFileAtPath---成功");

        }
        else
            NSLog(@"文件创建失败");
    }

}
//提供文件名,读取文件,传回文件数据,作为缓存
-(NSArray *)requestLocalWallperData:(NSString *)fileName
{
    NSString *string = [NSString stringWithFormat:@"DIR/%@",fileName];
    NSString *filePath = [CACHEFILEPATH stringByAppendingPathComponent:string];
    NSLog(@"%@",filePath);
    if ([_fileManager fileExistsAtPath:filePath])
    { NSLog(@"requestLocalWallperData---存在");
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return array;
    }else{
        NSLog(@"requestLocalWallperData---不存在");
    }
    return nil;
}

//提供文件名,读取文件,传回文件数据,作为缓存
-(NSDictionary *)requestLocalWeatherData:(NSString *)fileName
{
    NSString *string = [NSString stringWithFormat:@"DIR/%@",fileName];
    NSString *filePath = [CACHEFILEPATH stringByAppendingPathComponent:string];
    NSLog(@"%@",filePath);
    if ([_fileManager fileExistsAtPath:filePath])
    { NSLog(@"requestLocalWeatherData---------存在");
        NSData *data = [NSData dataWithContentsOfFile:filePath];
//        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return dictionary;
    }else{
        NSLog(@"requestLocalWeatherData---------不存在");
    }
    return nil;
}

//删除文件夹,即清除缓存,此时可删除整个存储请求来的数据文件夹
-(void)clearCache
{
    NSError *error;
    [_fileManager removeItemAtPath:[CACHEFILEPATH stringByAppendingPathComponent:@"DIR"] error:&error];
    if (error) {
        NSLog(@"removeItemAtPath----Error:%@",error);

    }
}

//删除文件,
-(void)deleteFileWithName:(NSString *)fileName
{
    NSError *error;
    NSString *string = [NSString stringWithFormat:@"DIR/%@",fileName];
    NSString *filePath = [CACHEFILEPATH stringByAppendingPathComponent:string];
    [_fileManager removeItemAtPath:filePath error:&error];
    if (error) {
        NSLog(@"removeItemAtPath----Error:%@",error);
    }
}


@end
