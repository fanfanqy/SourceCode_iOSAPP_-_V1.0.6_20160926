//
//  SqlDataBase.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/18.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "SqlDataBase.h"
#import "FMDatabase.h"
#import "DBModel.h"
#import "Image_Model.h"
#import <CoreLocation/CoreLocation.h>

@implementation SqlDataBase
{
    FMDatabase *_database;
    FMDatabase *_databaseSelectedWallpaperList;
    NSLock *_lock;
    NSFileManager *fileManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        //对线程锁对象初始化
        _lock = [[NSLock alloc] init];
        fileManager = [NSFileManager defaultManager];

    }
    return self;
}

// 初始化非SelectedWallpaperListDB数据库
- (void)configDatabase
{
    //加锁
    [_lock lock];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseDoc = [rootPath stringByAppendingPathComponent:@"jyjs"];
    NSString *databasePath = [databaseDoc stringByAppendingPathComponent:[NSString stringWithFormat:JYJSCALENDARDB]];
    
    NSLog(@"path:%@",databasePath);
    _database = [FMDatabase databaseWithPath:databasePath];
    BOOL a  = NO;
    a  = [_database open];
    if (a) {
         NSLog(@"success");
    }
    //解锁
    [_lock unlock];
}

// 初始化SelectedWallpaperListDB数据库
- (void)configSelectedWallpaperListDB{
    //加锁
    [_lock lock];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databaseDoc = [rootPath stringByAppendingPathComponent:@"jyjs"];
    NSString *databasePath = [databaseDoc stringByAppendingPathComponent:[NSString stringWithFormat:SelectedWallpaperListDB]];

    NSLog(@"_databaseSelectedWallpaperList path:%@",databasePath);
    _databaseSelectedWallpaperList = [FMDatabase databaseWithPath:databasePath];
    BOOL a  = NO;
    a  = [_databaseSelectedWallpaperList open];
    if (a) {
        NSLog(@"success");
    }
    //解锁
    [_lock unlock];
}
// 清空数据
- (void)eraseTableInSelectedWallpaperListDB{
    /*当SQLite数据库中包含自增列时，会自动建立一个名为 sqlite_sequence 的表。这个表包含两个列：name和seq。name记录自增列所在的表，seq记录当前序号（下一条记录的编号就是当前序号加1）。如果想把某个自增列的序号归零，只需要修改 sqlite_sequence表就可以了。*/
    //这里SET seq=0,WallpaperList 表的id是从1开始

    [_lock lock];
    NSString *sql = @"DELETE FROM WallpaperList";
    [_databaseSelectedWallpaperList executeUpdate:sql];
    [_databaseSelectedWallpaperList executeUpdate:@"UPDATE sqlite_sequence SET seq=0 WHERE name='WallpaperList'"];
    [_lock unlock];
}
//搜索城市
-(NSMutableArray *)searchWithString:(NSString *)searchString andIsPinyin:(BOOL)isPinyin andLocationCityModel:(DBModel *)locationCitymodel{
    [_lock lock];
    NSString *sql = nil;
    //    注意：name like ‘西门’,相当于是name = ‘西门’。
    //    name like ‘%西%’,为模糊搜索，搜索字符串中间包含了’西’，左边可以为任意字符串，右边可以为任意字符串，的字符串。
    //    但是在 stringWithFormat:中%是转义字符，两个%才表示一个%。
    
    if (isPinyin) {
        sql = [NSString stringWithFormat:@"select * from cityList where cityPinyin like '%%%@%%'",searchString];
    }else{
        sql = [NSString stringWithFormat:@"select * from cityList where cityCC like '%%%@%%'",searchString];
    }

    NSLog(@"sql:%@",sql);
    FMResultSet *set = [_database executeQuery:sql];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (set) {
        NSLog(@"successset1");
        while (set.next) {
            //            *cityPinyin;
            //            *country_name;
            //            *lat;
            //            *lon;
            //            *cityCC;//Chinese character
            NSLog(@"successset2");
            DBModel *model = [[DBModel alloc]init];
            model.cityPinyin = [set stringForColumn:@"cityPinyin"];
            NSLog(@" model.cityPinyin:%@", model.cityPinyin);
            model.country_name = [set stringForColumn:@"country_name"];
            model.lat = [set stringForColumn:@"lat"];
            model.lon = [set stringForColumn:@"lon"];
            model.qwz = [set stringForColumn:@"l"];
            model.cityCC = [set stringForColumn:@"cityCC"];
            model.isCC = [set intForColumn:@"isCC"];
            [array addObject:model];
        }
    }else{
        NSLog(@"3%@", _database.lastErrorMessage);
        [_lock unlock];
        return nil;
    }

#pragma mark fqy
    int indexFlagMin = 0;

    NSMutableArray *indexFlagMinArray = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *cityNameArray = [NSMutableArray arrayWithCapacity:10];
    for (int i=0; i < array.count; i++) {
        DBModel *model1 = array[i];
        NSString *cityName =nil;
        if (isPinyin) {
            cityName = model1.cityPinyin;
        }else{
            cityName = model1.cityCC;
        }

        BOOL addedcityName = NO;
        if(cityNameArray.count == 0 ){
            [cityNameArray addObject:cityName];
        }else{
            for (int t=0; t<cityNameArray.count; t++) {
                if ([cityName isEqualToString:cityNameArray[t]]) {
                    addedcityName = YES;
                    break;
                }
                addedcityName = NO;

            }
            if (!addedcityName) {
                [cityNameArray addObject:cityName];
            }
        }

        if(locationCitymodel.cityCC) {
                if (!addedcityName){
                    indexFlagMin = i;
                    [indexFlagMinArray addObject:[NSString stringWithFormat:@"%d",indexFlagMin]];
                }

        }else{
                 if ( !addedcityName) {
                     indexFlagMin = i;
                     [indexFlagMinArray addObject:[NSString stringWithFormat:@"%d",indexFlagMin]];
                 }
        }
    }

    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int k=0; k<indexFlagMinArray.count; k++) {
        DBModel *model = array[[indexFlagMinArray[k] intValue]];
        [mutableArray addObject:model];
    }
    array = mutableArray;
#pragma mark fqy
    
    [_lock unlock];
    return array;
}
//搜索所有城市
- (NSMutableArray *)searchAllSaveCity
{
    [_lock lock];
    NSString *sql = nil;
    //    注意：name like ‘西门’,相当于是name = ‘西门’。
    //    name like ‘%西%’,为模糊搜索，搜索字符串中间包含了’西’，左边可以为任意字符串，右边可以为任意字符串，的字符串。
    //    但是在 stringWithFormat:中%是转义字符，两个%才表示一个%。

    sql = [NSString stringWithFormat:@"select * from saveCity order by id"];
    NSLog(@"sql:%@",sql);
    FMResultSet *set = [_database executeQuery:sql];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (set) {
        NSLog(@"successset1");
        while (set.next) {
            NSLog(@"successset2");
            DBModel *model = [[DBModel alloc]init];
            model.cityPinyin = [set stringForColumn:@"cityPinyin"];
            NSLog(@" model.cityPinyin:%@", model.cityPinyin);
            model.country_name = [set stringForColumn:@"country_name"];
            model.lat = [set stringForColumn:@"lat"];
            model.lon = [set stringForColumn:@"lon"];
            model.qwz   = [set stringForColumn:@"l"];
            model.cityCC = [set stringForColumn:@"cityCC"];
            model.isCC = [set intForColumn:@"isCC"];
            [array addObject:model];
        }
    }else{
        NSLog(@"从数据库查找存储的城市%@", _database.lastErrorMessage);
        [_lock unlock];
        return nil;
    }
    [_lock unlock];
    return array;
}
//删除一条已经添加的城市数据
- (void)deleateCityFromSaveCity:(DBModel *)model
{
    //加锁
    [_lock lock];
    
    NSString *sql = nil;
    BOOL is = YES;
    //删除一条已经添加的城市数据
    sql =[NSString stringWithFormat:@"delete from saveCity where l = '%@'", model.qwz];
    
    is = [_database executeUpdate:sql,[model valueForKey:@"cityPinyin"],[model valueForKey:@"country_name"],[model valueForKey:@"lat"],[model valueForKey:@"lon"],[model valueForKey:@"qwz"],[model valueForKey:@"cityCC"],[model valueForKey:@"isCC"]];
    
    if (!is) {
        NSLog(@"2%@", _database.lastErrorMessage);
    }
    //解锁
    [_lock unlock];
}
//添加一条城市数据
- (void)saveCityToDB:(DBModel *)model
{
    //加锁
    [_lock lock];
    
    NSString *sql = nil;
    BOOL is = YES;
    //对表添加数据
    sql =[NSString stringWithFormat:@"insert into saveCity(cityPinyin,country_name,lat,lon,l,cityCC,isCC) values(?,?,?,?,?,?,?)"];
    
    is = [_database executeUpdate:sql,[model valueForKey:@"cityPinyin"],[model valueForKey:@"country_name"],[model valueForKey:@"lat"],[model valueForKey:@"lon"],[model valueForKey:@"qwz"],[model valueForKey:@"cityCC"],[model valueForKey:@"isCC"]];
    
    if (!is) {
        NSLog(@"2%@", _database.lastErrorMessage);
    }
    //解锁
    [_lock unlock];
}

//城市名搜索
- (DBModel *)searchWithCityName:(NSString *)cityName
{
    [_lock lock];
    NSString *sql = nil;
    //    注意：name like ‘西门’,相当于是name = ‘西门’。
    //    name like ‘%西%’,为模糊搜索，搜索字符串中间包含了’西’，左边可以为任意字符串，右边可以为任意字符串，的字符串。
    //    但是在 stringWithFormat:中%是转义字符，两个%才表示一个%。
    
    sql = [NSString stringWithFormat:@"select * from cityList where cityPinyin = '%@'", cityName];
    NSLog(@"sql:%@",sql);
    FMResultSet *set = [_database executeQuery:sql];
    DBModel * resultModel = [[DBModel alloc]init];
    if (set.next) {
        
        NSLog(@"successset2");
        resultModel.cityPinyin = [set stringForColumn:@"cityPinyin"];
        resultModel.country_name = [set stringForColumn:@"country_name"];
        resultModel.lat = [set stringForColumn:@"lat"];
        resultModel.lon = [set stringForColumn:@"lon"];
        resultModel.qwz = [set stringForColumn:@"l"];
        resultModel.cityCC = [set stringForColumn:@"cityCC"];
        resultModel.isCC = [set intForColumn:@"isCC"];
        
        
    }else{
        NSLog(@"从数据库查找存储的城市%@", _database.lastErrorMessage);
        [_lock unlock];
        return nil;
    }
    [_lock unlock];
    return resultModel;
}

- (DBModel *)searchOneCity:(DBModel *)model
{
    [_lock lock];
    NSString *sql = nil;
    //    注意：name like ‘西门’,相当于是name = ‘西门’。
    //    name like ‘%西%’,为模糊搜索，搜索字符串中间包含了’西’，左边可以为任意字符串，右边可以为任意字符串，的字符串。
    //    但是在 stringWithFormat:中%是转义字符，两个%才表示一个%。
    
    sql = [NSString stringWithFormat:@"select * from saveCity where l = '%@'", model.qwz];
    NSLog(@"sql:%@",sql);
    FMResultSet *set = [_database executeQuery:sql];
    DBModel * resultModel = [[DBModel alloc]init];
    if (set.next) {
        
        NSLog(@"successset2");
        resultModel.cityPinyin = [set stringForColumn:@"cityPinyin"];
        resultModel.country_name = [set stringForColumn:@"country_name"];
        resultModel.lat = [set stringForColumn:@"lat"];
        resultModel.lon = [set stringForColumn:@"lon"];
        resultModel.cityCC = [set stringForColumn:@"cityCC"];
        resultModel.isCC = [set intForColumn:@"isCC"];

    }else{
        NSLog(@"从数据库查找存储的城市%@", _database.lastErrorMessage);
        [_lock unlock];
        return nil;
    }
    [_lock unlock];
    return resultModel;
}

//获取"10张"壁纸
- (NSArray *)achieveTenWallper:(int)beginPages andWallpaperKind:(int)wallpaperKind{
    [_lock lock];
    NSString *sql1 = @"select count(1) from WallpaperList";
    FMResultSet *s = [_databaseSelectedWallpaperList executeQuery:sql1];
    int totalCount = 0;
    if ([s next]) {
        totalCount = [s intForColumnIndex:0];
    }
    NSLog(@"totalCount:%d",totalCount);
    NSMutableArray *array = [NSMutableArray array];
    //加载是加载以前的内容
    NSString *sql = nil;
    if (totalCount-(beginPages+1)*10>0) {
        sql = [NSString stringWithFormat:@"select * from WallpaperList where id between %d and %d", totalCount-(beginPages+1)*10+1,totalCount-beginPages*10];
    }else if(totalCount-beginPages*10>0){
        sql = [NSString stringWithFormat:@"select * from WallpaperList where id between %d and %d", 1,totalCount-beginPages*10];
    }else{
        //小心死锁
         [_lock unlock];
        return [[array reverseObjectEnumerator] allObjects];
    }
    NSLog(@"sql:%@",sql);
    FMResultSet *set = [_databaseSelectedWallpaperList executeQuery:sql];
    if (set) {
        while (set.next) {
            Image_Model  * resultModel = [[Image_Model alloc]init];
            if (wallpaperKind == 1) {
                resultModel.url = [set stringForColumn:@"SmallWallpaperUrl"];
            }
            if (wallpaperKind == 2) {
                resultModel.url = [set stringForColumn:@"MidWallpaperUrl"];
            }
            if (wallpaperKind == 3) {
                resultModel.url = [set stringForColumn:@"BigWallpaperUrl"];
            }

            resultModel.nameHash = [set stringForColumn:@"NameHash"];
            resultModel.createDateUtc = [set stringForColumn:@"CreateDateUtc"];
            [array addObject:resultModel];
            NSLog(@"%d,++++++++%@",wallpaperKind,resultModel.url);
        }
    }else{
        NSLog(@"从数据库查找存储的城市%@", _databaseSelectedWallpaperList.lastErrorMessage);
    }
    [_lock unlock];
    return [[array reverseObjectEnumerator] allObjects];
    
}
-(void)addWallperToServerWallPaperList:(NSArray *)array{
    //加锁
    [_lock lock];
    NSString *sql = nil;
    BOOL is = YES;
    //对表添加数据
    sql =[NSString stringWithFormat:@"insert into ServerWallpaperList(WID,NameHash,Name,PublishDateUtc,CreateDateUtc,Url,Width,Height,IsPortrait,Vote,Rate,Download) values(?,?,?,?,?,?,?,?,?,?,?,?)"];
    for (int i=0; i<array.count; i++) {
        Image_Model  * resultModel = array[i];
        NSString *hasInsertedSql = nil;
        hasInsertedSql = [NSString stringWithFormat:@"select * from ServerWallpaperList where WID = '%@'", [resultModel valueForKey:@"iD"]];
        FMResultSet *set = [_database executeQuery:hasInsertedSql];
        if (set.next) {
            NSString *updateSql = nil;
            updateSql = [[NSString alloc] initWithFormat:@"UPDATE 'ServerWallpaperList' SET  'NameHash' = '%@',Name= '%@',PublishDateUtc= '%@',CreateDateUtc= '%@',Url= '%@',Width= '%@',Height= '%@',IsPortrait= '%@',Vote= '%@',Rate= '%@',Download= '%@'",
                         [resultModel valueForKey:@"nameHash"],[resultModel valueForKey:@"name"],
                         [resultModel valueForKey:@"publishDateUtc"],[resultModel valueForKey:@"createDateUtc"],[resultModel valueForKey:@"url"],[resultModel valueForKey:@"width"],
                         [resultModel valueForKey:@"height"],[resultModel valueForKey:@"isPortrait"],
                         [resultModel valueForKey:@"stat_Vote"],[resultModel valueForKey:@"stat_Rate"],
                         [resultModel valueForKey:@"stat_Download"]];
        }
        else{
            is = [_database executeUpdate:sql,
                  [resultModel valueForKey:@"iD"], [resultModel valueForKey:@"nameHash"],
                  [resultModel valueForKey:@"name"], [resultModel valueForKey:@"publishDateUtc"],
                  [resultModel valueForKey:@"createDateUtc"],[resultModel valueForKey:@"url"],
                  [resultModel valueForKey:@"width"],[resultModel valueForKey:@"height"],
                  [resultModel valueForKey:@"isPortrait"],[resultModel valueForKey:@"stat_Vote"],
                  [resultModel valueForKey:@"stat_Rate"],[resultModel valueForKey:@"stat_Download"]];
            if (!is) {
                NSLog(@"%@", _database.lastErrorMessage);
            }
        }
    }
    [_lock unlock];
}
//添加壁纸到 SelectedWallpaperListDB
- (void)addWallper:(NSArray *)array{
    //加锁
    [_lock lock];
    NSString *sql = nil;
    BOOL is = YES;
    //对表添加数据
//    SmallWallpaperUrl,MidWallpaperUrl,BigWallpaperUrl,smallWidth,middleWidth,bigWidth
//    主页缩略壁纸模块对应Url,壁纸内页模块对应Url,壁纸宽度占据全局的模块的Url,后面是分别对应的宽度
    sql =[NSString stringWithFormat:@"insert into WallpaperList(NameHash,CreateDateUtc,SmallWallpaperUrl,MidWallpaperUrl,BigWallpaperUrl,smallWidth,middleWidth,bigWidth) values(?,?,?,?,?,?,?,?)"];

    for (int i=0; i<array.count; i++) {
        Image_Model  * resultModel = array[i];

        NSMutableArray *unsorted1 = [NSMutableArray array];
        //顺序随便,只要保证每个宽度都更新
        [unsorted1 addObject:@"1"];
        [unsorted1 addObject:@"2"];
        [unsorted1 addObject:@"3"];

        //与哪个差值最小添加进去
        
        NSString *sql1 = nil;
        sql1 = [NSString stringWithFormat:@"select * from WallpaperList where NameHash = '%@'", resultModel.nameHash];
        FMResultSet *set = [_databaseSelectedWallpaperList executeQuery:sql1];
        if (set.next) {
//smallWidth,middleWidth,bigWidth
                    //查询到nameHash添加进去过了,和原来添加的比较一下

                for (int z=0; z<[unsorted1 count]; z++) {

                    switch ([unsorted1[z] intValue]) {
                        case 1:
                            {
                            NSString *width = [set stringForColumn:@"smallWidth"];
                                if ( fabs([width intValue] - ScreenPixelWidth/3) >= fabs([[resultModel valueForKey:@"width"] intValue] - ScreenPixelWidth/3) )  {
                                    // 要添加的差值比已添加的差值小,就可以进来
                                        is = [_databaseSelectedWallpaperList executeUpdate:[NSString stringWithFormat:@"UPDATE WallpaperList SET CreateDateUtc='%@',SmallWallpaperUrl='%@',smallWidth='%@' WHERE  NameHash = '%@';",[resultModel valueForKey:@"createDateUtc"],[resultModel valueForKey:@"url"],[resultModel valueForKey:@"width"],[resultModel valueForKey:@"nameHash"]]];
                                }
                                break;
                            }
                        case 2:
                        {
                            NSString *width = [set stringForColumn:@"middleWidth"];
                            if ( fabs([width intValue] - ScreenPixelWidth/2) >= fabs([[resultModel valueForKey:@"width"] intValue] - ScreenPixelWidth/2) )  {
                                // 要添加的差值比已添加的差值小,就可以进来
                                is = [_databaseSelectedWallpaperList executeUpdate:[NSString stringWithFormat:@"UPDATE WallpaperList SET CreateDateUtc='%@',MidWallpaperUrl='%@',middleWidth='%@' WHERE  NameHash = '%@';",[resultModel valueForKey:@"createDateUtc"],         [resultModel valueForKey:@"url"],[resultModel valueForKey:@"width"],[resultModel valueForKey:@"nameHash"]]];

                            }
                            break;
                        }

                        case 3:
                        {
                              NSString *width = [set stringForColumn:@"bigWidth"];
                            NSLog(@"nameHash:%@,%@,%f,%d",[resultModel valueForKey:@"nameHash"],width,ScreenPixelWidth,[[resultModel valueForKey:@"width"] intValue]);

                            if ( fabs([width intValue] - ScreenPixelWidth) >= fabs([[resultModel valueForKey:@"width"] intValue] - ScreenPixelWidth) || (([[resultModel valueForKey:@"width"] intValue]>=[width intValue])))  {
                                // 要添加的差值比已添加的差值小,就可以进来
                                is = [_databaseSelectedWallpaperList executeUpdate:[NSString stringWithFormat:@"UPDATE WallpaperList SET CreateDateUtc='%@',BigWallpaperUrl='%@',bigWidth='%@' WHERE NameHash = '%@';",[resultModel valueForKey:@"createDateUtc"],[resultModel valueForKey:@"url"],[resultModel valueForKey:@"width"],[resultModel valueForKey:@"nameHash"]]];

                            }
                            break;
                        }

                        default:
                            break;
                    }
                }

        }
        else{

            is = [_databaseSelectedWallpaperList executeUpdate:sql,[resultModel valueForKey:@"nameHash"],[resultModel valueForKey:@"createDateUtc"],         [resultModel valueForKey:@"url"],[resultModel valueForKey:@"url"],[resultModel valueForKey:@"url"],                                    [resultModel valueForKey:@"width"],[resultModel valueForKey:@"width"],[resultModel valueForKey:@"width"]];

        }

        if (!is) {
            NSLog(@"%@", _databaseSelectedWallpaperList.lastErrorMessage);
        }

    }
    //解锁
    [_lock unlock];
}

//获取数据库中表中数据总数
- (int)achieveTableDataNum:(NSString *)tableName{
    NSString *sql1 = @"select count(1) from WallpaperList";
    FMResultSet *s = [_databaseSelectedWallpaperList executeQuery:sql1];
    int totalCount = 0;
    if ([s next]) {
        totalCount = [s intForColumnIndex:0];
    }
    NSLog(@"totalCount:%d",totalCount);
    return totalCount;
}
/*
// 删除数据库
- (void)deleteDatabse
{
    BOOL success;
    NSError *error;

    NSFileManager *fileManager = [NSFileManager defaultManager];

    // delete the old db.
    if ([fileManager fileExistsAtPath:DBName])
    {
        [DB close];
        success = [fileManager removeItemAtPath:DBName error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to delete old database file with message '%@'.", [error localizedDescription]);
        }
    }
}

// 判断是否存在表
- (BOOL) isTableOK:(NSString *)tableName
{
    FMResultSet *rs = [DB executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        WILog(@"isTableOK %d", count);

        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }

    return NO;
}

// 获得表的数据条数
- (BOOL) getTableItemCount:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
    FMResultSet *rs = [DB executeQuery:sqlstr];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        WILog(@"TableItemCount %d", count);

        return count;
    }

    return 0;
}

// 创建表
- (BOOL) createTable:(NSString *)tableName withArguments:(NSString *)arguments
{
    NSString *sqlstr = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)", tableName, arguments];
    if (![DB executeUpdate:sqlstr])
        //if ([DB executeUpdate:@"create table user (name text, pass text)"] == nil)
    {
        WILog(@"Create db error!");
        return NO;
    }

    return YES;
}

// 删除表
- (BOOL) deleteTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![DB executeUpdate:sqlstr])
    {
        WILog(@"Delete table error!");
        return NO;
    }

    return YES;
}

// 清除表
- (BOOL) eraseTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![DB executeUpdate:sqlstr])
    {
        WILog(@"Erase table error!");
        return NO;
    }

    return YES;
}

// 插入数据
- (BOOL)insertTable:(NSString*)sql, ...
{
    va_list args;
    va_start(args, sql);

    BOOL result = [DB executeUpdate:sql error:nil withArgumentsInArray:nil orVAList:args];

    va_end(args);
    return result;
}

// 修改数据
- (BOOL)updateTable:(NSString*)sql, ...
{
    va_list args;
    va_start(args, sql);

    BOOL result = [DB executeUpdate:sql error:nil withArgumentsInArray:nil orVAList:args];

    va_end(args);
    return result;
}
*/
@end
