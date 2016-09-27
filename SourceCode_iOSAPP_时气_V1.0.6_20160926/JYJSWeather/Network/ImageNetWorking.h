//
//  ImageNetWorking.h
//  TestGet
//
//  Created by DEV-IOS-2 on 16/5/25.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageNetWorking : NSObject
@property (nonatomic, strong)void (^finishBlock)(NSData * data , BOOL success);
+ (instancetype)handleImageWithURL:(NSURL *)url FinishBlock:(void (^)(NSData * data , BOOL success))block;

@end
