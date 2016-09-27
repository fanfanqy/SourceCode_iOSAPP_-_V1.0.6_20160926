//
//  ReachManager.h
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/9/27.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "AppDelegate.h"
@interface ReachManager : NSObject
+(BOOL)isReachable;
+(BOOL)isWIFI;
+(BOOL)isWWAN;
@end
