//
//  FRTransferTaskManager.m
//  BLEDemo
//
//  Created by Jose Chen on 16/4/28.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import "FRTransferTaskManager.h"

@interface FRTransferTaskManager ()
{
    NSMutableArray          *_taskArray;
    BOOL                    _isBusy;
    FRDownloadRequest       *_downloadRequest;
}
@end

@implementation FRTransferTaskManager

+ (instancetype)defaultManager{
    static FRTransferTaskManager *gTransferTaskManager = nil;
    if (gTransferTaskManager == nil) {
        gTransferTaskManager = [[FRTransferTaskManager alloc] init];
    }
    return gTransferTaskManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark-----------task queue-------------------
- (void)addDownloadTask:(FRDownloadAction*)task
{
    [_taskArray addObject:task];
    [self checkIfNeedsStart];
}

- (void)checkIfNeedsStart
{
    if (_isBusy) {
        NSLog(@"download task is busy");
        return;
    }
    [self startNextTask];
}

- (void)startNextTask
{
    NSLog(@"startNextDownloadTask count=%lu",(unsigned long)_taskArray.count);
    if (_taskArray.count) {
        FRDownloadAction *action = [_taskArray objectAtIndex:0];
        _downloadRequest = [[FRDownloadRequest alloc] init];
        [_downloadRequest startDownload:action
                     didReceiveResponse:^(NSURLResponse *response) {
                         NSLog(@"respone=%@",response);
                     } progress:^(CGFloat progress) {
                         NSLog(@"progress=%.2f",progress);
                     } complete:^(NSData *data, NSError *error) {
                         NSLog(@"complete error=%@",error);
                         
                     }];
    }
}

@end
