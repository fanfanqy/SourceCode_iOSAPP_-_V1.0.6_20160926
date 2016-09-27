//
//  Calendary.h
//  XJKJwnl
//
//  Created by xjkjmac02 on 14-11-21.
//  Copyright (c) 2014年 xjkjmac02. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  画日历所需要的日期Model
 */
@interface Calendary : NSObject

@property(nonatomic, copy)NSString * _id;
@property(nonatomic, copy)NSString *lMonth;
@property(nonatomic, copy)NSString *lDayName;
@property(nonatomic, copy)NSString *jieQi;
@property(nonatomic, copy)NSString *jieQiTime;
@property(nonatomic, copy)NSString *gongLiJieRi;
@property(nonatomic, copy)NSString *nongLiJieRi;
@property(nonatomic, copy)NSString *pssd;
@property(nonatomic, copy)NSString *gd;
@property(nonatomic, copy)NSString *gdNum;
@property(nonatomic, assign)CGFloat height;
@property(nonatomic, copy)NSString * lDay;
@property(nonatomic, copy)NSString * liFa;
@property(nonatomic, copy)NSString * zm;
@property(nonatomic, copy)NSString * zd;
@property(nonatomic, copy)NSString * pssdZang;

@end
