//
//  FRDownloadRequest.h
//  BLEDemo
//
//  Created by Jose Chen on 16/4/22.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import "FRBaseRequest.h"

@interface FRDownloadRequest : FRBaseRequest

/**
 *  开始下载
 *
 *  @param action        下载请求的action
 *  @param responseBlock 收到Response
 *  @param progressBlock 更新进度
 *  @param completeBlock 下载完成 err=nil成功 err!=nil失败
 */
- (void)startDownload:(FRRequestAction*)action
   didReceiveResponse:(RequestResponseBlock)responseBlock
             progress:(RequestProgressBlock)progressBlock
             complete:(RequestCompleteBlock)completeBlock;
// 暂停
- (void)suspend;

// 开始(恢复)
- (void)resume;

// 取消
- (void)cancel;

@end
