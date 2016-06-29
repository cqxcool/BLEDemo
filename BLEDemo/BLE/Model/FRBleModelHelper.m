
//
//  FRBleModelHelper.m
//  BLEDemo
//
//  Created by David.Dai on 16/3/18.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import "FRBleModelHelper.h"

@interface FRBleModelHelper ()
{
    NSMutableArray *_peripheralArray;
}

@end

@implementation FRBleModelHelper

+ (instancetype)defaultManager{
    static FRBleModelHelper *gBleMoelHelper = nil;
    if (gBleMoelHelper == nil) {
        gBleMoelHelper = [[FRBleModelHelper alloc] init];
    }
    return gBleMoelHelper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initModelHelper];
    }
    return self;
}

- (void)initModelHelper
{
    _peripheralArray = [[NSMutableArray alloc] init];
}

//添加到设备列表
- (void)addPeripheral:(CBPeripheral*)peripheral;
{
    if (![_peripheralArray containsObject:peripheral]) {
        [_peripheralArray addObject:peripheral];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kFRBleHelperAddPeripheral object:nil];
}

//获取外设列表
- (NSMutableArray*)getPeripheralList
{
    return _peripheralArray;
}

//清除设备列表
- (void)clearPeripheral
{
    [_peripheralArray removeAllObjects];
}

@end
