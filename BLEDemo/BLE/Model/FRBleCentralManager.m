//
//  FRBleManager.m
//  BLEDemo
//
//  Created by David.Dai on 16/3/17.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import "FRBleCentralManager.h"
#import "FRBleModelHelper.h"

#define     kFrontRowServiceUUID            "e498d939-1663-4edc-bdcb-8df514c5db04"
#define     kFrontRowCharacterisicWrite     "086b434e-cab4-49a9-8849-7660a2c754a5"
#define     kFrontRowCharacterisicNotify    "fa10ec29-9669-485d-a73a-7ca7fe1ce663"

@interface FRBleCentralManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager *_centralManager;
}
@end

@implementation FRBleCentralManager

+ (instancetype)defaultManager{
    static FRBleCentralManager *gBleManger = nil;
    if (gBleManger == nil) {
        gBleManger = [[FRBleCentralManager alloc] init];
    }
    return gBleManger;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initBleCentral];
    }
    return self;
}

//初始化
- (void)initBleCentral
{
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
}

//扫描外设
- (void)scanPeripherals;
{
    NSLog(@"scanPeripherals");
    //CBCentralManagerScanOptionAllowDuplicatesKey值为 No，表示不重复扫描已发现的设备
    NSDictionary *optionDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [_centralManager scanForPeripheralsWithServices:nil options:optionDic];//如果你将第一个参数设置为nil，Central Manager就会开始寻找所有的服务。
}

//停止扫描外设
- (void)stopScanPeripherals
{
    [_centralManager stopScan];
}

//连接到外设
- (void)connectToPeripheral:(CBPeripheral*)peripheral
{
    [_centralManager connectPeripheral:peripheral
                            options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}

#pragma mark --------CBCentralManagerDelegate-------------

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState:%ld",(long)central.state);
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"CBCentralManagerStatePoweredOff");
        }
            break;
        case CBCentralManagerStatePoweredOn:
            [self scanPeripherals];   //很重要，当蓝牙处于打开状态，开始扫描。
            break;
        default:
            NSLog(@"蓝牙未工作在正确状态");
            break;
    }
}

//扫描到外设，停止扫描，连接设备(每扫描到一个外设都会调用一次这个函数，若要展示搜索到的蓝牙，可以逐一保存 peripheral 并展示)
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"didDiscoverPeripheral = %@ name=%@",peripheral.identifier,peripheral.name);
    [[FRBleModelHelper defaultManager] addPeripheral:peripheral];
//    if (!peripheral.name) {
//        [self connectToPeripheral:peripheral];
//    }
    [self connectToPeripheral:peripheral];

}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"didConnectPeripheral = %@ name=%@",peripheral.identifier,peripheral.name);
    
    if ([peripheral.name hasSuffix:@"0200"]) {
        [peripheral setDelegate:self];  //查找服务
        [peripheral discoverServices:nil];
    }
}


#pragma mark ---------------CBPeripheralDelegate----------------------
//搜索到Services
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
    NSLog(@"didDiscoverServices");
    
    if (error)
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        
        return;
    }
    
    
    for (CBService *service in peripheral.services)
    {
        //发现服务
        NSLog(@"Service found with UUID: %@", service.UUID); //查找特征
        [peripheral discoverCharacteristics:nil forService:service];
//        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_PROPRIETARY_SERVICE]])
//        {
//            NSLog(@"Service found with UUID: %@", service.UUID); //查找特征
//            [peripheral discoverCharacteristics:nil forService:service];
//            break;
//        }
    }
}

//搜索到characteristics
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    NSLog(@"服务：%@",service.UUID);
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"characteristic");
        //发现特征
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"xxxxxxx"]]) {
//            NSLog(@"监听：%@",characteristic);//监听特征
//            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    //    NSLog(@"收到的数据：%@",characteristic.value);
}









@end
