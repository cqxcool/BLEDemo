//
//  FRBleModelHelper.h
//  BLEDemo
//
//  Created by David.Dai on 16/3/18.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define kFRBleHelperAddPeripheral       @"FRBleHelperAddPeripheral"

@interface FRBleModelHelper : NSObject

+ (instancetype)defaultManager;

//添加到外设列表
- (void)addPeripheral:(CBPeripheral*)peripheral;

//获取外设列表
- (NSMutableArray*)getPeripheralList;

//清除设备列表
- (void)clearPeripheral;

@end
