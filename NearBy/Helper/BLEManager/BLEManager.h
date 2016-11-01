//
//  BLEManager.h
//  NearBy
//
//  Created by 王坜 on 16/10/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEDevice.h"

typedef NS_ENUM(NSInteger, BLEMode) {
    CenterMode = 0x00,
    PeripheralMode,
};


@protocol BLEManagerDelegate <NSObject>

@optional

- (void)managerDidFindDevices:(NSArray *)devices;

- (void)managerDidFindDevice:(BLEDevice *)device;

- (void)managerDidFail:(NSString *)error;

@end


@interface BLEManager : NSObject

@property (nonatomic, weak)id<BLEManagerDelegate> delegate;

@property (nonatomic) BOOL isScanning;

@property (assign, nonatomic) BLEMode bleMode;

@property (nonatomic, strong) NSString *advertisingName;

@property (nonatomic, strong) NSString *advertisingUUID;

@property (nonatomic, strong, readonly) NSArray *discoveredDevices;

+ (BLEManager *)defaultManager;

- (void)startScan;

- (void)stopScan;

- (void)cleanDevices;


@end
