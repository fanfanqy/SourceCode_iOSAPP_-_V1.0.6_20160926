//
//  WanNianLiDate.m
//  FaLv
//
//  Created by mac on 14-12-5.
//  Copyright (c) 2014年 xjkjmac01. All rights reserved.
//

#import "WanNianLiDate.h"
#import "ZipArchive.h"
#import "Help.h"
@implementation WanNianLiDate
{
    NSFileManager  *_fileManager;
}

// 获取 jyjscalendar.db FMDatabase
+ (FMDatabase*) getDataBase
{
    NSString *rootPath      = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseDoc   = [rootPath stringByAppendingPathComponent:@"jyjs"];
    NSString *databasePath  = [databaseDoc stringByAppendingPathComponent:[NSString stringWithFormat:JYJSCALENDARDB]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:databasePath])
    {
        NSArray* arr = [JYJSCALENDAR componentsSeparatedByString:@"."];
        databasePath = [[NSBundle mainBundle] pathForResource:[arr objectAtIndex:0] ofType:[arr objectAtIndex:1]];
        
        ZipArchive* zipFile = [[ZipArchive alloc] init];
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            if([zipFile UnzipOpenFile:databasePath])
            {
                BOOL ret = [zipFile UnzipFileTo:databaseDoc overWrite:YES];
                if(ret)
                {
                     NSLog(@"解压成功");
                }else
                {
                    NSLog(@"解压失败");
                }
                [zipFile UnzipCloseFile];
            }
        });
    }
    FMDatabase* database = [FMDatabase databaseWithPath:databasePath];
    if (![database open]) {
        return nil;
    }
    return  database;
}

+(void)updateJYJSFile{
    NSString *rootPath                          = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseDoc                       = [rootPath    stringByAppendingPathComponent:@"jyjs"];
    NSString *databasePathSelectedWallpaperList = [databaseDoc stringByAppendingPathComponent:[NSString stringWithFormat:SelectedWallpaperListDB]];
    NSString *databasePathJYJSCALENDARDB        = [databaseDoc stringByAppendingPathComponent:[NSString stringWithFormat:JYJSCALENDARDB]];
    if ([Help  hasAppUpdated]){
        //检测文件是否存在,删除文件
        if([[NSFileManager defaultManager]      fileExistsAtPath:databasePathJYJSCALENDARDB]){
            [[NSFileManager defaultManager]     removeItemAtPath:databasePathJYJSCALENDARDB error:nil];
        }
        if([[NSFileManager defaultManager]      fileExistsAtPath:databasePathSelectedWallpaperList]){
            [[NSFileManager defaultManager]     removeItemAtPath:databasePathSelectedWallpaperList error:nil];
        }
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:APP_VERSION forKey:@"LAST_APP_VERSION"];
        [user setObject:nil forKey:@"RequestDataTime"];
    }

    if(![[NSFileManager defaultManager] fileExistsAtPath:databasePathJYJSCALENDARDB])
    {
        NSArray* arr                = [JYJSCALENDAR componentsSeparatedByString:@"."];
        databasePathJYJSCALENDARDB  = [[NSBundle mainBundle] pathForResource:[arr objectAtIndex:0] ofType:[arr objectAtIndex:1]];

        ZipArchive* zipFile         = [[ZipArchive alloc] init];
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            if([zipFile UnzipOpenFile:databasePathJYJSCALENDARDB])
            {
                BOOL ret = [zipFile UnzipFileTo:databaseDoc overWrite:YES];
                if(ret)
                {
                    NSLog(@"解压成功");
                }else
                {
                    NSLog(@"解压失败");
                }
                [zipFile UnzipCloseFile];
            }
        });
    }

    //如果文件不存在 SelectedWallpaperList 文件,就解压一份
    if(![[NSFileManager defaultManager] fileExistsAtPath:databasePathSelectedWallpaperList]){
        NSArray* arr = [SelectedWallpaperList componentsSeparatedByString:@"."];
        databasePathSelectedWallpaperList = [[NSBundle mainBundle] pathForResource:[arr objectAtIndex:0] ofType:[arr objectAtIndex:1]];
        
        ZipArchive* zipFile = [[ZipArchive alloc] init];
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            if([zipFile UnzipOpenFile:databasePathSelectedWallpaperList])
            {
                BOOL ret = [zipFile UnzipFileTo:databaseDoc overWrite:YES];
                if(ret)
                {
                    NSLog(@"解压成功");
                }else
                {
                    NSLog(@"解压失败");
                }
                [zipFile UnzipCloseFile];
            }
        });
    }
}

@end
