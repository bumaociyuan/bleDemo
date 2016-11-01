//
//  BLEManager.m
//  NearBy
//
//  Created by 王坜 on 16/10/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BLEManager.h"
#import "TransferService.h"
#import <CoreBluetooth/CoreBluetooth.h>

#define kSBOSSPrefix @"SBOSS-"



@interface BLEManager () <CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate>
{
    NSMutableArray *_discoveredDevices;
}
// Global

@property (nonatomic, strong) NSTimer *globalTimer;
@property (nonatomic) NSInteger currentDeviceCount;

// CBPeripheralManager
@property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
@property (strong, nonatomic) NSData                    *dataToSend;

// CBCentralManager
@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData         *data;

@end


@implementation BLEManager

@synthesize discoveredDevices = _discoveredDevices;

#pragma mark - Public Functions ---

+ (BLEManager *)defaultManager
{
    static BLEManager *defaultManager = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        defaultManager = [[BLEManager alloc] init];
        [defaultManager initialManagers];
    });

    return defaultManager;
}


- (void)startScan
{
    self.isScanning = YES;

    [self watchTheStatus];

    switch (self.bleMode) {
            case CenterMode:
            self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

            break;
            case PeripheralMode:
            self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
            break;
        default:
            break;
    }


}

- (void)stopScan
{
    self.isScanning = NO;


    switch (self.bleMode) {
            case CenterMode:
            [self.centralManager stopScan];
            self.centralManager = nil;
            break;
            case PeripheralMode:
            [self.peripheralManager stopAdvertising];
            self.peripheralManager = nil;
            break;
        default:
            break;
    }
}

- (void)cleanDevices
{
    _currentDeviceCount = 0;
    [_discoveredDevices removeAllObjects];
}


#pragma mark - Private Functions ---


- (void)watchTheStatus
{
    if (self.globalTimer) {
        [self.globalTimer invalidate];
    }

    self.globalTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeBLEMode) userInfo:nil repeats:YES];

}


- (float)distanceWithRSSI:(NSInteger)rssi
{
    int iRssi = abs((int)rssi);
    float power = (iRssi-47)/(10*3.6);
    return pow(10, power);
}

- (NSString *)createSBOSSName:(NSString *)name
{
    return [NSString stringWithFormat:@"SBOSS-%@", (name == nil || name.length == 0) ? @"附近的人" : name];
}

- (void)initialManagers
{
    NSInteger random = arc4random() % 2;
    self.bleMode = (BLEMode)random;
    self.advertisingName = [self createSBOSSName:nil];
    _discoveredDevices = [[NSMutableArray alloc] init];
}


- (void)changeBLEMode
{
    if (_currentDeviceCount == self.discoveredDevices.count) {

        [self stopScan];

        if (self.bleMode == CenterMode) {
            self.bleMode = PeripheralMode;
        } else if (self.bleMode == PeripheralMode) {
            self.bleMode = CenterMode;
        }

        NSInteger randomSeconds = arc4random() % 2;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(randomSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startScan];
        });


    } else {
        _currentDeviceCount = self.discoveredDevices.count;
    }

}

#pragma mark - 开始扫描周边设备
/** Scan for peripherals - specifically for our service's 128bit CBUUID
 */
- (void)centralScanForPeripherals
{

    [self.centralManager scanForPeripheralsWithServices:nil
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}

#pragma mark - 开始扫描中心设备

- (void)peripheralAdvertising
{

}

#pragma mark - CBCentralManagerDelegate ---

/** centralManagerDidUpdateState is a required protocol method.
 *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
 *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
 *  the Central is ready to be used.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{

    switch (central.state) {
            case CBCentralManagerStatePoweredOn:
            [self centralScanForPeripherals];
            break;
            
        default:
            break;
    }

}




/** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
 *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
 *  we start the connection process
 */


- (BOOL)filterDevice:(BLEDevice *)device
{
    if (_discoveredDevices.count == 0) {
        [_discoveredDevices addObject:device];
    } else {
        for (NSInteger i = 0; i < _discoveredDevices.count; i++) {
            BLEDevice *de = [_discoveredDevices objectAtIndex:i];
            if ([de.UUIDString isEqualToString:device.UUIDString]) {

            }
        }
    }


    return YES;
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{

    CGFloat distanceFloat = [self distanceWithRSSI:RSSI.integerValue];

    if (distanceFloat > 30) {
        return;
    }

    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    NSString *name = advertisementData[CBAdvertisementDataLocalNameKey];
    NSArray *uuids = advertisementData[CBAdvertisementDataServiceUUIDsKey];
    CBUUID *uuid = uuids.firstObject;
    NSLog(@"\n--name: %@ \n--UUID: %@ \n", name, uuid.UUIDString);

    if (!name || !uuid) {
        return;
    }

    if (![name hasPrefix:kSBOSSPrefix]) {
        return;
    }

    BLEDevice *device = [[BLEDevice alloc] init];
    device.name = name;
    device.UUIDString = uuid.UUIDString;

    BLEDistance *distance = [[BLEDistance alloc] init];
    distance.distanceOnce = [self distanceWithRSSI:RSSI.integerValue];
    distance.date = [NSDate date];
    device.distanceRecords = [[NSMutableArray alloc] initWithObjects:distance, nil];

    if (_discoveredDevices.count == 0) {
        [_discoveredDevices addObject:device];
    } else {

        BOOL findSame = NO;

        for (NSInteger i = 0; i < _discoveredDevices.count; i++) {
            BLEDevice *de = [_discoveredDevices objectAtIndex:i];
            if ([de.UUIDString isEqualToString:device.UUIDString]) {
                if ([de.name isEqualToString:@"device"]) {
                    de.name = device.name;
                }
                // 记录三秒内的3-5次记录，求平均值
                BLEDistance *first = de.distanceRecords.firstObject;
                NSTimeInterval timeBetween = [distance.date timeIntervalSinceDate:first.date];

                if (fabs(distance.distanceOnce - de.distance) > 5) { // 大幅度的波动忽略
                    return;
                } else if (timeBetween > 1.5) { // 不超过3秒
                    [de.distanceRecords removeAllObjects];
                    [de.distanceRecords addObject:distance];
                } else if (de.distanceRecords.count < 3) { // 最多记录3次
                    [de.distanceRecords addObject:distance];
                }

                findSame = YES;
                break;
            }
        }

        if (!findSame) {
            [_discoveredDevices addObject:device];
        }
    }



    [self.delegate managerDidFindDevices:_discoveredDevices];

    //[self.delegate managerDidFindDevice:device];



}




#pragma mark - CBPeripheralManagerDelegate


/** Required protocol method.  A full app should take care of all the possible states,
 *  but we're just waiting for  to know when the CBPeripheralManager is ready
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{

    switch (peripheral.state) {
            case CBCentralManagerStatePoweredOn:
            [self.peripheralManager startAdvertising:@{CBAdvertisementDataLocalNameKey:[NSString stringWithFormat:@"%@%@", kSBOSSPrefix, self.advertisingName], CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:self.advertisingUUID]] }];
            break;

        default:
            break;
    }

}





@end
