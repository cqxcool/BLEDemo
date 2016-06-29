//
//  FRDownloadAction.h
//  BLEDemo
//
//  Created by Jose Chen on 16/4/26.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import "FRRequestAction.h"

@interface FRDownloadAction : FRRequestAction

/** 文件的总长度 */
@property (nonatomic, assign) NSInteger totalLength;

/** 已下载的文件长度 */
@property (nonatomic, assign) NSInteger downloadedlLength;

/** 缓存中间文件路径 */
@property (nonatomic, strong) NSString *tempPath;

/** 下载完成存储路径 */
@property (nonatomic, strong) NSString *filePath;


/**
 *  初始化
 *
 *  @param url       下载的文件url地址
 *  @param tempPath  下载文件中间缓存路径
 *  @param filePath  下载文件完成保存路径
 *
 *  @return  FRDownloadAction
 */
- (instancetype)initWithUrl:(NSString *)url
                   tempPath:(NSString *)tempPath
                   filePath:(NSString*)filePath;

@end
