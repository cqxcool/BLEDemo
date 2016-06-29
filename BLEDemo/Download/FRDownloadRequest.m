//
//  FRDownloadRequest.m
//  BLEDemo
//
//  Created by Jose Chen on 16/4/22.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import "FRDownloadRequest.h"
#import "FRDownloadAction.h"

@interface FRDownloadRequest ()<NSURLSessionDataDelegate>
{
    CGFloat   _lastProgress;
}
/** 写文件的流对象 */
@property (nonatomic, strong) NSOutputStream *stream;

@end

@implementation FRDownloadRequest

// 懒加载，第一次使用NSOutputStream流对象创建
- (NSOutputStream *)stream
{
    if (!_stream) {
        FRDownloadAction *action = (FRDownloadAction*)self.action;
        _stream = [NSOutputStream outputStreamToFileAtPath:action.tempPath append:YES];
    }
    return _stream;
}

- (void)startDownload:(FRRequestAction*)action
  didReceiveResponse:(RequestResponseBlock)responseBlock
      progress:(RequestProgressBlock)progressBlock
            complete:(RequestCompleteBlock)completeBlock
{
    self.action = action;
    self.responseBlock = responseBlock;
    self.progressBlock = progressBlock;
    self.completeBlock = completeBlock;
    if (_task == nil) {
        _task = [_session dataTaskWithRequest:[self.action getURLRequest]];
    }
    [_task resume];
}

// 暂停
- (void)suspend
{
    [_task suspend];
}

// 开始(恢复)
- (void)resume
{
    [_task resume];
}

// 取消
- (void)cancel
{
    [_task cancel];
    FRDownloadAction *action = (FRDownloadAction*)self.action;
    [[NSFileManager defaultManager] removeItemAtPath:action.tempPath error:nil];
}

#pragma mark - <NSURLSessionDataDelegate>

// 1.接收到响应
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSHTTPURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    if (self.responseBlock) {
        self.responseBlock(response);
    }
    
    // 打开流
    [self.stream open];
    
    FRDownloadAction *action = (FRDownloadAction*)self.action;
    // 获得服务器这次请求 返回数据的总长度
    action.totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + action.downloadedlLength;
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

// 2.接收到服务器返回的数据（这个方法可能会被调用N次）
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    // 写入数据
    [self.stream write:data.bytes maxLength:data.length];
    FRDownloadAction *action = (FRDownloadAction*)self.action;
    //下载进度
    CGFloat progress = 1.0 * action.downloadedlLength / action.totalLength;
    if (((progress - _lastProgress) >= 0.01) || (progress == 1)) {
        if (self.progressBlock) {
            self.progressBlock(progress);
        }
        _lastProgress = progress;
    }
}


// 3.请求完毕（成功\失败）
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if (error == nil) {
        FRDownloadAction *action = (FRDownloadAction*)self.action;
        NSError *err = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:action.filePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:action.filePath error:nil];
        }
        [[NSFileManager defaultManager] moveItemAtPath:action.tempPath toPath:action.filePath error:&err];
        if (err) {
            NSLog(@"FRDownloadAction move file failed,err = %@",err);
        }
        // 关闭流
        [self.stream close];
        self.stream = nil;
        // 清除任务
        _task = nil;
    }
    if (self.completeBlock) {
        self.completeBlock(_receiveData,error);
    }
}

@end
