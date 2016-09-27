//
//  NetWorkMonitor.h
//  SideSlip
//
//  Created by DEVP-IOS-03 on 16/5/16.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>
typedef enum{
    NONETWORK=0,
    WIFI=1,
    NOWIFI=2
}NetworkKind;

@interface NetWorkMonitor : NSObject 
@property (nonatomic, readonly) BOOL isHostReach;
@property (nonatomic, readonly) NSInteger reachableCount;
@property (nonatomic,readonly) NetworkKind networkKind  ;//0:没有连接：1：WIFI 2：非WIFI连接
@property (nonatomic, strong) Reachability *hostReach;
- (BOOL)isNetworkReachable;
+ (NetWorkMonitor *)networkReachable;
@end
