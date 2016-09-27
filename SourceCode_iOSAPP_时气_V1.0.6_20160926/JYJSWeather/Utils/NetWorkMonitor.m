//
//  NetWorkMonitor.m
//  SideSlip
//
//  Created by DEVP-IOS-03 on 16/5/16.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import "NetWorkMonitor.h"

@interface NetWorkMonitor()

@end

@implementation NetWorkMonitor
@synthesize isHostReach = _isHostReach;
@synthesize networkKind = _networkKind;

- (NetworkKind)networkKind{
    [self isNetworkReachable];
    return _networkKind;
}

- (BOOL)isHostReach
{
    _isHostReach = [self isNetworkReachable];
    return _isHostReach;
}

+(NetWorkMonitor *)networkReachable{
    NetWorkMonitor *monitor = [[NetWorkMonitor alloc]init];
    return monitor;
}

-(instancetype)init{
    if (self = [super init]) {
        [self isNetworkReachable];
    }
    return self;
}

- (BOOL)isNetworkReachable{
    Reachability* curReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    _reachableCount++;
    switch (netStatus)
    {
        case NotReachable:{
            _networkKind = NONETWORK;
            return NO;
            break;
        }

        case ReachableViaWWAN:{
            _networkKind = NOWIFI;
            return YES;
            break;
        }
        case ReachableViaWiFi:{

            _networkKind = WIFI;
            return YES;
            break;
        }
    }
    if (_reachableCount == 2) {
        _reachableCount = 0;
    }

}

@end
