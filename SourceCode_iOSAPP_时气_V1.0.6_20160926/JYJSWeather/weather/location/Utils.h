//
//  Utils.h
//  Calendar
//
//  Created by DEVP-IOS-03 on 16/5/17.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
+ (BOOL)isAllChineseInString:(NSString*)str;
+ (NSString*)chineseConvertToPinYin:(NSString*)chinese;
@end
