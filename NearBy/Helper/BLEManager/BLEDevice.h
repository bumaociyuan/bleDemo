//
//  BLEDevice.h
//  NearBy
//
//  Created by 王坜 on 16/10/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BLEDistance : NSObject

@property (nonatomic) CGFloat distanceOnce;

@property (nonatomic, strong) NSDate *date;

@end



@interface BLEDevice : NSObject

@property (nonatomic, strong) NSString *UUIDString;

@property (nonatomic, strong) NSString *name;

@property (nonatomic) CGFloat distance;

@property (nonatomic) NSInteger absRSSI;

@property (nonatomic, strong) NSMutableArray *distanceRecords;


@end
