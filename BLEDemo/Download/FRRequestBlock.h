//
//  FRRequestBlock.h
//  BLEDemo
//
//  Created by Jose Chen on 16/4/22.
//  Copyright © 2016年 David.Dai. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void (^RequestResponseBlock)        (NSURLResponse *response);
typedef void (^RequestReceiveDataBlock)     (NSData *data);
typedef void (^RequestCompleteBlock)        (NSData *data,NSError *error);
typedef void (^RequestProgressBlock)        (CGFloat progress);
