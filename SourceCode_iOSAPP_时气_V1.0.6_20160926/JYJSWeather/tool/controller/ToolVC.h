//
//  ToolVC.h
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/5/11.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma wq 1
#import <CoreLocation/CoreLocation.h>
@class RootViewController;
@interface ToolVC : UIViewController
#pragma wq 1
@property (nonatomic , strong) CLLocationManager    * locMgr;
@property (nonatomic, strong)RootViewController *delegate;
- (float ) folderSizeAtPath;
- (void)startLocation;
@end

