//
//  FRRequestAction.m
//  BLEDemo
//
//  Created by Jose Chen on 16/4/22.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import "FRRequestAction.h"

@interface FRRequestAction ()
@property (nonatomic, copy, readwrite)   NSString            *method;

@end

@implementation FRRequestAction

- (instancetype)init {
    if (self = [super init]) {
        _method = @"GET";
        _timeout = 180;
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)url {
    self = [self init];
    if (self) {
        _url = url;
    }
    return self;
}

- (void)setHttpMethod:(enum HttpMethod)method {
    switch (method) {
        case httpGet:
            self.method = @"GET";
            break;
        case HttpPost:
            self.method = @"POST";
            break;
        default:
            break;
    }
}

- (NSMutableURLRequest*)getURLRequest
{
    NSURL *url = [NSURL URLWithString:self.url];
    //创建请求对象里面包含请求体
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:_timeout];
    if (self.postData) {
        request.HTTPBody = self.postData;
    }else{
        request.HTTPMethod = @"GET";
    }
    return request;
}

@end
