//
//  FRBaseRequest.h
//  BLEDemo
//
//  Created by Jose Chen on 16/4/22.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRRequestAction.h"
#import "FRRequestBlock.h"

@interface FRBaseRequest : NSObject
{
    NSMutableData       *_receiveData;
    NSURLSession        *_session;
    NSURLSessionTask    *_task;
}
@property(nonatomic,strong)  FRRequestAction *action;

@property(nonatomic,copy)  RequestResponseBlock     responseBlock;
@property(nonatomic,copy)  RequestReceiveDataBlock  receiveBlock;
@property(nonatomic,copy)  RequestProgressBlock     progressBlock;
@property(nonatomic,copy)  RequestCompleteBlock     completeBlock;



// 开始
- (void)resume;

// 暂停
- (void)suspend;

// 取消
- (void)cancel;

@end
