//
//  CustomImageView.m
//  JYJSWeather
//
//  Created by DEV-IOS-2 on 16/6/17.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "CustomImageView.h"
#import "ImageNetWorking.h"

@interface CustomImageView ()
{
    NSString * temp;
}
//@property (nonatomic, assign) NSString * temp;

@end

@implementation CustomImageView
- (void)setImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    
    if ([temp isEqualToString:@""]) {
        temp = @"1";
    } else {
        temp = [NSString stringWithFormat:@"%d", [temp intValue]+1];
    }
    NSLog(@"temp = %@", temp);
    
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    url = ( NSString *)
//    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                              (CFStringRef)url,
//                                                              NULL,//指定了将本身为非法的URL字符不进行编码的字符集合
//                                                              CFSTR("!*();+$,%#[] "),//将本身为合法的URL字符需要进行编码的字符集合
//                                                              kCFStringEncodingUTF8));
    NSURL * urlStr = [NSURL URLWithString:url];
    NSString * fileName = urlStr.absoluteString;

    NSArray * array = [fileName componentsSeparatedByString:@"url="];
    fileName = [array lastObject];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];

    NSFileManager *manager=[NSFileManager defaultManager];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [NSString stringWithFormat:@"%@/images", path];
    path = [NSString stringWithFormat:@"%@/%@", path,fileName];
    
    if (placeholder != nil) {
        self.image = placeholder;
        
    }
    
    BOOL isHasFile=[manager fileExistsAtPath:path];
    if (isHasFile) {
        NSData * data = [self getimageWithUrl:urlStr]; //为真表示已经请求过这个文件,可以直接读取
        [self setImageData:data];
        NSLog(@"请求过这个图片");
    }else{
        //没有请求过这个图片
        NSLog(@"未请求过");
        [self handleImageWithUrl:urlStr Temp:temp];
    }
    
}
// 从网络获取图片
- (void)handleImageWithUrl:(NSURL *)url Temp:(NSString *)temp1
{
    NSLog(@"%@", url.absoluteString);
    [ImageNetWorking handleImageWithURL:url FinishBlock:^(NSData *data, BOOL success) {
        // 图片请求成功存入本地
        if (success) {
            [self saveImageWithUrl:url ImageData:data];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 如果返回图片为最后请求的图片则显示
            if ([temp isEqualToString: temp1]) {
                if (success) {
                    [self setImageData:data];
                } else {
                    // 请求图片失败显示错误图片
                    self.image = [UIImage imageNamed:@"load_error_min"];
                }
            } else {
                return ;
            }
            
        });
        
    }];
}
// 将图片存入本地
- (void)saveImageWithUrl:(NSURL *)url ImageData:(NSData *)data
{
    NSString * fileName = url.absoluteString;
    NSArray * array = [fileName componentsSeparatedByString:@"url="];
    fileName = [array lastObject];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSFileManager *manager=[NSFileManager defaultManager];

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    path = [NSString stringWithFormat:@"%@/images", path];
    
    BOOL isHasFile=[manager fileExistsAtPath:path];
    if (!isHasFile) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [NSString stringWithFormat:@"%@/%@", path,fileName];

    NSLog(@"图片缓存%@",path);

    if ([manager fileExistsAtPath:path]){

    }else{
    [data writeToFile:path atomically:YES];
    }
}
// 从本地读取图片
- (NSData *)getimageWithUrl:(NSURL *)url
{
    NSString * fileName = url.absoluteString;
    NSArray * array = [fileName componentsSeparatedByString:@"url="];
    fileName = [array lastObject];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    path = [NSString stringWithFormat:@"%@/images", path];
    path = [NSString stringWithFormat:@"%@/%@", path,fileName];
    
    NSData * data = [NSData dataWithContentsOfFile:path];
    return data;
    
}

- (void)setImageData:(NSData *)data
{

    self.contentMode = UIViewContentModeScaleAspectFill;
    self.image = [UIImage imageWithData:data];
}

@end
