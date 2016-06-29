//
//  FRBleManager.h
//  BLEDemo
//
//  Created by David.Dai on 16/3/17.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FRBleCentralManager : NSObject
{
    
}

+ (instancetype)defaultManager;

//扫描外设
- (void)scanPeripherals;

//停止扫描外设
- (void)stopScanPeripherals;




@end
