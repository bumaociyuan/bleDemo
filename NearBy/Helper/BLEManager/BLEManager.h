//
//  BLEManager.h
//  NearBy
//
//  Created by 王坜 on 16/10/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEDevice.h"

/**
 * 蓝牙扫描模式
 **/
typedef NS_ENUM(NSInteger, BLEMode) {
    /**
     * 中心者模式
     **/
    CenterMode = 0x00,

    /**
     * 周边模式，发送广播
     **/
    PeripheralMode,
};

/**
 * 蓝牙扫描回调协议
 **/
@protocol BLEManagerDelegate <NSObject>

@optional

/**
 * 当有新的设备添加时，通知界面刷新
 **/
- (void)managerDidFindDevices:(NSArray *)devices;

/**
 * 错误通知
 **/
- (void)managerDidFail:(NSString *)error;

@end

/**
 * 蓝牙扫描类
 **/
@interface BLEManager : NSObject

/**
 * 获取返回数据的回调对象
 **/
@property (nonatomic, weak)id<BLEManagerDelegate> delegate;

/**
 * 判断当前是否在扫描设备中
 **/
@property (nonatomic) BOOL isScanning;

/**
 * 手动设置当前的蓝牙模式，如果不设置则为随机模式
 **/
@property (assign, nonatomic) BLEMode bleMode;

/**
 * 蓝牙广播的名称 --必填
 **/
@property (nonatomic, strong) NSString *advertisingName;

/**
 * 蓝牙广播的唯一标识 --必填
 **/
@property (nonatomic, strong) NSString *advertisingUUID;

/**
 * 扫描到的所有设备
 **/
@property (nonatomic, strong, readonly) NSArray *discoveredDevices;

/**
 * 默认的单例对象
 **/
+ (BLEManager *)defaultManager;

/**
 * 开始扫描
 **/
- (void)startScan;

/**
 * 停止扫描
 **/
- (void)stopScan;

/**
 * 清空所有数据
 **/
- (void)cleanDevices;


@end
