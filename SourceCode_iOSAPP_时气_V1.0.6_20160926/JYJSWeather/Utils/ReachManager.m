//
//  ReachManager.m
//  JYJSWeather
//
//  Created by DEVP-IOS-03 on 16/9/27.
//  Copyright © 2016年 WangQi. All rights reserved.
//

#import "ReachManager.h"

@implementation ReachManager
+(BOOL)isReachable{
    Reachability *reach = [(AppDelegate *)[[UIApplication sharedApplication] delegate] hostReach];
    return  [reach isReachable];
}
+(BOOL)isWIFI{
    Reachability *reach = [(AppDelegate *)[[UIApplication sharedApplication] delegate] hostReach];
    return  [reach isReachableViaWiFi];
}
+(BOOL)isWWAN{
    Reachability *reach = [(AppDelegate *)[[UIApplication sharedApplication] delegate] hostReach];
    return  [reach isReachableViaWWAN];
}
@end
