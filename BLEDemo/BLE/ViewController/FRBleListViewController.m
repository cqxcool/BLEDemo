//
//  FRBleListViewController.m
//  BLEDemo
//
//  Created by David.Dai on 16/3/18.
//  Copyright © 2016年 David.Dai. All rights reserved.
//

#import "FRBleListViewController.h"
#import "FRBleModelHelper.h"
#import "FRBleCentralManager.h"

@interface FRBleListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_tableData;
}

@end

@implementation FRBleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[FRBleCentralManager defaultManager] scanPeripherals];
    
    _tableData = [[FRBleModelHelper defaultManager] getPeripheralList];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableData) name:kFRBleHelperAddPeripheral object:nil];
}

- (void)reloadTableData
{
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FRBleListCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FRBleListCell"];
    }
    
    if (indexPath.row < _tableData.count) {
        CBPeripheral *peripheral = [_tableData objectAtIndex:indexPath.row];
        NSLog(@"peripheral name = %@",peripheral.name);
        cell.textLabel.text = peripheral.name;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
