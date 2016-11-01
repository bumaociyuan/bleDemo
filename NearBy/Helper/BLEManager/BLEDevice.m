//
//  BLEDevice.m
//  NearBy
//
//  Created by 王坜 on 16/10/31.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BLEDevice.h"

@interface BLEDevice ()

@end

@implementation BLEDevice



- (CGFloat)distance
{
    if (_distanceRecords.count > 0) {

        CGFloat total = 0;
        for (NSInteger i = 0; i < _distanceRecords.count; i++) {
            BLEDistance *distance = [_distanceRecords objectAtIndex:i];

            total += distance.distanceOnce;
        }

        _distance = total / _distanceRecords.count;
    }


    return _distance;
}


@end


@implementation BLEDistance



@end
