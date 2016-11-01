//
//  NBLogHelper.m
//  NearBy
//
//  Created by 王坜 on 16/11/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NBLogHelper.h"

@implementation NBLogHelper

+ (NBLogHelper *)defaultHelper
{
    static NBLogHelper *defaultHelper = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        defaultHelper = [[NBLogHelper alloc] init];
    });

    return defaultHelper;
}

- (void)writeString:(NSString *)string toFile:(NSString *)fileName type:(NSString *)type
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    // 传递 0 代表是找在Documents 目录下的文件。

    NSString *documentDirectory = [directoryPaths objectAtIndex:0];

    // DBNAME 是要查找的文件名字，文件全名

    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@""];

    // 用这个方法来判断当前的文件是否存在，如果不存在，就创建一个文件

    if ( ![fileManager fileExistsAtPath:filePath]) {

        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
        
    }
}


@end
