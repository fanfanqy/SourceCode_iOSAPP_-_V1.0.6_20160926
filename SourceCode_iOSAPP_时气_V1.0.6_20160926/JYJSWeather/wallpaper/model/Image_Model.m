//
//  Image_Model.m
//  TestGet
//
//  Created by DEV-IOS-2 on 16/5/25.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "Image_Model.h"

@implementation Image_Model
+ (NSMutableArray *)sortOutDataWith:(NSArray *)array
{
    NSMutableArray * testArray = [NSMutableArray array];
    for (NSDictionary * dictionary in array) {
        Image_Model * model = [[Image_Model alloc]init];
        model.thumbUrl = [dictionary objectForKey:@"ThumbUrl"];
        model.iD = [dictionary objectForKey:@"ID"];
        model.nameHash = [dictionary objectForKey:@"NameHash"] ;
        model.name = [dictionary objectForKey:@"Name"];
        model.publishDateUtc = [dictionary objectForKey:@"PublishDateUtc"];
        model.createDateUtc = [dictionary objectForKey:@"CreateDateUtc"];
        model.url = [dictionary objectForKey:@"Url"];
        model.width = [[dictionary objectForKey:@"Width"] integerValue];
        model.height = [[dictionary objectForKey:@"Height"]integerValue];
        model.isPortrait = [dictionary objectForKey:@"IsPortrait"];
        model.type = [dictionary objectForKey:@"__type"];
        model.categories = [dictionary objectForKey:@"Categories"];
        model.itdescription = [dictionary objectForKey:@"Description"];
        model.Labels = [dictionary objectForKey:@"Labels"];
        model.stat_Download = [[[dictionary objectForKey:@"Stat"] objectForKey:@"Download"]integerValue];
        model.stat_Rate = [[[dictionary objectForKey:@"Stat"] objectForKey:@"Rate"]integerValue];
        model.stat_Vote = [[[dictionary objectForKey:@"Stat"] objectForKey:@"Vote"]integerValue];
        [testArray addObject:model];
    }

    for (int i = 0; i < testArray.count; i++) {
        for (int j = i + 1; j < testArray.count; j++) {

            Image_Model * model1 = [testArray objectAtIndex:i];
            Image_Model * model2 = [testArray objectAtIndex:j];

            NSDate * time1 = [NSDate dateWithTimeIntervalSince1970:([[model1.createDateUtc substringWithRange:NSMakeRange(6, 13)] longLongValue]/1000.0)];
            NSDate * time2 = [NSDate dateWithTimeIntervalSince1970:([[model2.createDateUtc substringWithRange:NSMakeRange(6, 13)] longLongValue]/1000.0)];

            if ([time1 timeIntervalSinceDate:time2] > 0.0) {
                [testArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
//#pragma mark  待删除
//    for (Image_Model * model in testArray) {
//        NSDate * time1 = [NSDate dateWithTimeIntervalSince1970:([[model.createDateUtc substringWithRange:NSMakeRange(6, 13)] longLongValue]/1000.0)];
//        NSLog(@"%@", time1);
//    }
    return testArray;
}

@end
