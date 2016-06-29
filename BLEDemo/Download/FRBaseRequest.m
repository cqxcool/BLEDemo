//
//  FRBaseRequest.m
//  BLEDemo
//
//  Created by Jose Chen on 16/4/22.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import "FRBaseRequest.h"

@interface FRBaseRequest ()<NSURLSessionDelegate>
{

}

@end

@implementation FRBaseRequest
@synthesize action = _action;

- (instancetype)init
{
    self = [super init];
    if (self) {        
        [self initRequest];
    }
    return self;
}

- (void)initRequest
{
    _receiveData = [[NSMutableData alloc] init];
    NSURLSessionConfiguration *sessionConfig =[NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:sessionConfig
                                             delegate:self
                                        delegateQueue:[NSOperationQueue new]];
}

// 暂停
- (void)suspend
{
    
}

// 开始(恢复)
- (void)resume
{
   
}

// 取消
- (void)cancel
{
    
}

@end
