//
//  FRDownloadAction.m
//  BLEDemo
//
//  Created by Jose Chen on 16/4/26.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import "FRDownloadAction.h"

@implementation FRDownloadAction
@synthesize totalLength;
@synthesize downloadedlLength;
@synthesize tempPath;
@synthesize filePath;

- (instancetype)initWithUrl:(NSString *)url
                   tempPath:(NSString *)temp
                   filePath:(NSString*)file
{
    self = [self initWithUrl:url];
    if (self) {
        self.tempPath = temp;
        self.filePath = file;
    }
    return self;
}

- (NSInteger)downloadedlLength
{
    return [self getSize];
}

- (NSInteger)getSize{
    NSString *fullPath = self.tempPath;
    //先把沙盒中的文件大小取出来
    NSError *err = nil;
    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&err];
    NSInteger size = [[dict objectForKey:@"NSFileSize"] integerValue];
    return size;
}

- (NSMutableURLRequest*)getURLRequest
{
    //设置请求头 Range : bytes=xxx-xxx
    NSMutableURLRequest *request = [super getURLRequest];
    request.timeoutInterval = 30*60;
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", [self downloadedlLength]];
    [request setValue:range forHTTPHeaderField:@"Range"];
    return request;
}

@end
