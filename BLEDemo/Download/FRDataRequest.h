//
//  FRDataRequest.h
//  BLEDemo
//
//  Created by Jose Chen on 16/4/22.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import "FRBaseRequest.h"


@interface FRDataRequest : FRBaseRequest

- (void)startRequest:(FRRequestAction*)action
  didReceiveResponse:(RequestResponseBlock)responseBlock
      didReceiveData:(RequestReceiveDataBlock)receiveBlock
            complete:(RequestCompleteBlock)completeBlock;

// 取消
- (void)cancel;

@end
