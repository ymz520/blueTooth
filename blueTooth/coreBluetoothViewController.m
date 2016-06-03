//
//  coreBluetoothViewController.m
//  blueTooth
//
//  Created by 张 荣桂 on 16/6/3.
//  Copyright © 2016年 张 荣桂. All rights reserved.
//

#import "coreBluetoothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface coreBluetoothViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>
@property(nonatomic,strong)NSMutableArray *peripherals;
@property(nonatomic,strong) CBCentralManager *centralmanager;
@end

@implementation coreBluetoothViewController
//懒加载(延迟加载，即在需要的时候才加载，效率低，占用内存小)写的是其get方法
-(NSMutableArray *)peripherals
{
    //先判断是否已经有咯，若没有，则进行实例化
    if(!_peripherals)
    {
        _peripherals=[[NSMutableArray alloc]initWithCapacity:0];
        return _peripherals;
    }
    return _peripherals;
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建中心设备管理器
    CBCentralManager *centralmanager=[[CBCentralManager alloc]init];
    self.centralmanager=centralmanager;
    //3.成为中心设备的代理，中心设备发现外部设备将通知你
    centralmanager.delegate=self;
    //2.扫描外部设备(nil表示扫描所有设备)
    [centralmanager scanForPeripheralsWithServices:nil options:nil];
    //2.1.创建外部设备管理
//    CBPeripheralManager
}
#pragma mark-CBCentralManagerDelegate
//4.实现代理里的方法(中心设备已经扫描到（发现）外部设备)
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    //5.保存外部设备，并建立连接，
    //5.1先判断数组里是否存在
    if(![self.peripherals containsObject:peripheral])
    {
        peripheral.delegate=self;
        [self.peripherals addObject:peripheral];
    }
    
    
}
//模拟点击连接外部设备的按钮
-(void)connectOnClick
{
    //中心设备连接外部设备(循环遍历所有的外部设备并进行连接)
    for (CBPeripheral *peripheral in self.peripherals) {
        [self.centralmanager connectPeripheral:peripheral options:nil];
    }
    
}
#pragma mark-CBCentralManagerDelegate
//实现代理的方法通知连接成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSArray *servers=peripheral.services;
    for (CBService *service in servers)
    {
        //循环遍历所有的服务，通过唯一标识uuid找到需要的服务
        if ([service.UUID.UUIDString isEqualToString:@"需要的服务的唯一标识UUID"])
        {
            //通过这个外设的这个服务去扫描所有的特征
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
    //通过外部设备得到所有的服务
    [peripheral discoverServices:servers];
    //通过成为外设的代理
}
#pragma mark-CBPeripheralDelegate
//已经扫描到特征
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSArray *characteristics=service.characteristics;
    for (CBCharacteristic *characteristic in characteristics)
    {
        if ([characteristic.UUID.UUIDString isEqualToString:@"456"])
        {
            NSLog(@"根据456这个特征做出相应的行为");
        }
    }
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
