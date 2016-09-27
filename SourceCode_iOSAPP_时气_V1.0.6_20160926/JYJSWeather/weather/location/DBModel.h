//
//  DBModel.h
//  Calendar
//
//  Created by DEVP-IOS-03 on 16/5/17.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import <Foundation/Foundation.h>
//城市Model
@interface DBModel : NSObject
// cityName==Abag Qi, China , qwz==/q/zmw:00000.1.53192, ll==44.020000 114.949997, cn==阿巴嘎旗
@property(nonatomic,copy)NSString *cityPinyin;
@property(nonatomic,copy)NSString *country_name;
@property(nonatomic,copy)NSString *lat;
@property(nonatomic,copy)NSString *lon;
@property(nonatomic,copy)NSString *qwz;
@property(nonatomic,copy)NSString *cityCC;//Chinese character
@property(nonatomic)BOOL isCC;
@end
