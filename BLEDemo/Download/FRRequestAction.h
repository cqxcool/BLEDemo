//
//  FRRequestAction.h
//  BLEDemo
//
//  Created by Jose Chen on 16/4/22.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HttpMethod) {
    httpGet = 1,
    HttpPost,
};

@interface FRRequestAction : NSObject

/**
 *  Http methods,默认Get.只读.
 *  修改使用setHttpMethod:方法
 */
@property (nonatomic, copy, readonly)   NSString *method;

/**
 *  url
 */
@property (nonatomic, copy)   NSString           *url;

/**
 *  超时时间,默认180s
 */
@property (nonatomic, assign) NSTimeInterval     timeout;

/**
 *  Http headers
 */
@property (nonatomic, strong) NSDictionary       *headers;

/**
 *  Http PostData
 *
 */
@property(nonatomic,strong) NSData      *postData;


- (instancetype)initWithUrl:(NSString *)url;
- (void)setHttpMethod:(enum HttpMethod)method;
- (NSMutableURLRequest*)getURLRequest;

@end
