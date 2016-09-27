//
//  DateSource.h
//  历算
//
//  Created by han on 14/12/4.
//  Copyright (c) 2014年 han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateSource : NSObject
+(NSString *)getUTCFormateDate:(NSString *)newsDate;
+(int)getShiChen:(int)hour;
+(int)getDayIndex:(NSString *)dayZhu;
@end
