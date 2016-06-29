//
//  FRDataRequest.m
//  BLEDemo
//
//  Created by Jose Chen on 16/4/22.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import "FRDataRequest.h"

@interface FRDataRequest ()<NSURLSessionDataDelegate>

@end

@implementation FRDataRequest

- (void)startRequest:(FRRequestAction*)action
  didReceiveResponse:(RequestResponseBlock)responseBlock
      didReceiveData:(RequestReceiveDataBlock)receiveBlock
            complete:(RequestCompleteBlock)completeBlock
{
    self.action = action;
    self.responseBlock = responseBlock;
    self.receiveBlock = receiveBlock;
    self.completeBlock = completeBlock;
    if (_task == nil) {
        _task = [_session dataTaskWithRequest:[self.action getURLRequest]];
    }
    [_task resume];
}

// 取消
- (void)cancel
{
    [_task cancel];
}

#pragma mark------------NSURLSessionDataDelegate-------------------

/**
 *
 * 收到响应
 *
 */
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
    if (self.responseBlock) {
        self.responseBlock(response);
    }
}

/**
 *
 * 收到数据
 *
 */
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    if (self.completeBlock) {
        [_receiveData appendData:data];
    }
    if (self.receiveBlock) {
        self.receiveBlock(data);
    }
}

/**
 * 请求成功或者失败
 */
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if (self.completeBlock) {
        self.completeBlock(_receiveData,error);
    }
}

@end
