//
//  NBLogHelper.h
//  NearBy
//
//  Created by 王坜 on 16/11/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBLogHelper : NSObject

+ (NBLogHelper *)defaultHelper;

- (void)writeString:(NSString *)string toFile:(NSString *)fileName type:(NSString *)type;

@end
