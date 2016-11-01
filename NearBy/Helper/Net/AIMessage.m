//
//  AIMessage.m
//  AITrans
//
//  Created by 王坜 on 15/8/7.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import "AIMessage.h"

@interface AIMessage ()
{
    
}

@end

@implementation AIMessage

- (id)init
{
    self = [super init];
    if (self) {
        self.body = [[NSMutableDictionary alloc] init];
        self.header = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (instancetype)message
{
    AIMessage *message = [[AIMessage alloc] init];
    return message;
}


#pragma mark - 生成唯一标识
- (void)makeUniqueID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    
    CFRelease(uuidStr);
    CFRelease(uuid);
}

@end
