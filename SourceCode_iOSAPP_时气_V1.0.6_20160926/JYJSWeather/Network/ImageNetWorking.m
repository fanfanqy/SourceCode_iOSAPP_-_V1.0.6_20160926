//
//  ImageNetWorking.m
//  TestGet
//
//  Created by DEV-IOS-2 on 16/5/25.
//  Copyright © 2016年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "ImageNetWorking.h"
//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>

//空字符串
#define     LocalStr_None           @""

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@interface ImageNetWorking ()<NSXMLParserDelegate>
@property (nonatomic, retain) NSMutableArray *arr;
@property (nonatomic, retain) NSString *value;

@end

@implementation ImageNetWorking
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.value = [NSString string];
    }
    return self;
}
+ (instancetype)handleImageWithURL:(NSURL *)url FinishBlock:(void (^)(NSData * data, BOOL success))block
{
    ImageNetWorking * imageNetWorking = [[ImageNetWorking alloc]init];
    imageNetWorking.finishBlock = block;
    [imageNetWorking handleImageWithURL:url];
    return imageNetWorking;
}

- (void)handleImageWithURL:(NSURL *)url
{ 
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
            
            parser.delegate = self;
            [parser parse];
            NSData * da = [self dataWithBase64EncodedString:self.value];
            self.finishBlock(da, YES);
            
        }else{
            self.finishBlock(nil, NO);
            NSLog(@"图片请求失败:%@", error);
        }
        
    }];
    [dataTask resume];

}
//开始
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    NSLog(@"%s", __func__);

    if ([elementName isEqualToString:@"base64Binary"]) {

    }
}

//查找
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"%s", __func__);
    self.value = [self.value stringByAppendingString:string];
    
}

//结束
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"%s", __func__);
    
}
- (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
    [NSException raise:NSInvalidArgumentException format:@"NSData * nonNull"];

    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

@end
