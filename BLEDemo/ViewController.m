//
//  ViewController.m
//  BLEDemo
//
//  Created by David.Dai on 16/3/17.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import "ViewController.h"
#import "FRBleCentralManager.h"
#import "FRBleListViewController.h"
#import "FRRequest.h"

@interface ViewController ()<CBCentralManagerDelegate>
{
    CBCentralManager *_centralManager;
    FRDataRequest *_request;
    FRDownloadRequest *_downloadRequest;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btnScan = [UIButton buttonWithType:UIButtonTypeCustom];
    btnScan.frame = CGRectMake(10, 40, 100, 20);
    btnScan.backgroundColor = [UIColor redColor];
    [btnScan setTitle:@"request" forState:UIControlStateNormal];
    [btnScan addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnScan];
    
    
    btnScan = [UIButton buttonWithType:UIButtonTypeCustom];
    btnScan.frame = CGRectMake(0, 100, 80, 20);
    btnScan.backgroundColor = [UIColor redColor];
    [btnScan setTitle:@"download" forState:UIControlStateNormal];
    [btnScan addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnScan];
    
    btnScan = [UIButton buttonWithType:UIButtonTypeCustom];
    btnScan.frame = CGRectMake(90, 100, 80, 20);
    btnScan.backgroundColor = [UIColor redColor];
    [btnScan setTitle:@"suspend" forState:UIControlStateNormal];
    [btnScan addTarget:self action:@selector(suspend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnScan];
    
    btnScan = [UIButton buttonWithType:UIButtonTypeCustom];
    btnScan.frame = CGRectMake(180, 100, 80, 20);
    btnScan.backgroundColor = [UIColor redColor];
    [btnScan setTitle:@"resume" forState:UIControlStateNormal];
    [btnScan addTarget:self action:@selector(resume) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnScan];
    
    btnScan = [UIButton buttonWithType:UIButtonTypeCustom];
    btnScan.frame = CGRectMake(280, 100, 80, 20);
    btnScan.backgroundColor = [UIColor redColor];
    [btnScan setTitle:@"cancel" forState:UIControlStateNormal];
    [btnScan addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnScan];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)scan
{
    if (_request) {
        [_request cancel];
        return;
    }
//    FRRequestAction *action = [[FRRequestAction alloc] initWithUrl:@"http://www.baidu.com/"];
//    _request = [[FRDataRequest alloc] init];
//    [_request startRequest:action didReceiveResponse:^(NSURLResponse *response) {
//        NSLog(@"didReceiveResponse = %@",response);
//    } didReceiveData:^(NSData *data) {
//        NSLog(@"didReceiveData = %@",data);
//    } complete:^(NSData *data, NSError *error) {
//        NSLog(@"didReceiveResponse=%@",error);
//    }];
    
//https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/ObjC_classic/FoundationObjC.pdf
    
    //http://120.25.226.186:32812/resources/videos/minion_01.mp4
    
    FRRequestAction *action = [[FRRequestAction alloc] initWithUrl:@"http://www.weather.com.cn/data/cityinfo/101010100.html"];
    _request = [[FRDataRequest alloc] init];
    [_request startRequest:action didReceiveResponse:^(NSURLResponse *response) {
        NSLog(@"didReceiveResponse = %@",response);
    } didReceiveData:^(NSData *data) {
        NSLog(@"didReceiveData = %@",data);
    } complete:^(NSData *data, NSError *error) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"str = %@",str);
        NSLog(@"error=%@",error);
    }];
    
}

- (void)download
{
    NSString *tempPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"movie.temp"];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"miniion.mp4"];

    
    FRDownloadAction *action = [[FRDownloadAction alloc] initWithUrl:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4" tempPath:tempPath filePath:filePath];
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

- (void)suspend
{
    [_downloadRequest suspend];
}

- (void)resume
{
    [_downloadRequest resume];
}

- (void)cancel
{
    [_downloadRequest cancel];
}

//delegate
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
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            [self scanBluetooth];   //很重要，当蓝牙处于打开状态，开始扫描。
            break;
        default:
            NSLog(@"蓝牙未工作在正确状态");
            break;
    }
}

- (void)scanBluetooth
{
    NSLog(@"BluetoothBase scanBluetooth");
    //CBCentralManagerScanOptionAllowDuplicatesKey值为 No，表示不重复扫描已发现的设备
    NSDictionary *optionDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [_centralManager scanForPeripheralsWithServices:nil options:optionDic];//如果你将第一个参数设置为nil，Central Manager就会开始寻找所有的服务。
}

//扫描到外设，停止扫描，连接设备(每扫描到一个外设都会调用一次这个函数，若要展示搜索到的蓝牙，可以逐一保存 peripheral 并展示)
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"didDiscoverPeripheral = %@ name=%@",peripheral.identifier,peripheral.name);
  
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
