//
//  Utils.m
//  Calendar
//
//  Created by DEVP-IOS-03 on 16/5/17.
//  Copyright © 2016年 DEVP-IOS-03. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (BOOL)isAllChineseInString:(NSString*)str {
    for (int i=0; i<str.length; i++) {
        unichar ch = [str characterAtIndex:i];
        if (0x4e00 >= ch  || ch >= 0x9fff) {
            return false;
        }
    }
    return YES;
}

+(NSString*)chineseConvertToPinYin:(NSString*)chinese {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [chinese stringByTrimmingCharactersInSet:set];
    if (chinese == nil || trimedString.length == 0) {
        return @"";
    }
    NSMutableString *result = [NSMutableString stringWithString:chinese];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)result,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)result,NULL, kCFStringTransformStripDiacritics,NO);
    return [result uppercaseString];
}
@end
