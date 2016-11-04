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

    NSString *component = [NSString stringWithFormat:@"%@.%@", fileName, type];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:component];

    // 用这个方法来判断当前的文件是否存在，如果不存在，就创建一个文件
    NSLog(@"path: %@", filePath);
    if ( ![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];

    }

    // 写文件
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSFileHandle* fh = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fh seekToFileOffset:[fh seekToEndOfFile]];
    [fh writeData:data];
    [fh synchronizeFile];


}

- (NSString *)readStringFromFile:(NSString *)fileName type:(NSString *)type
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    NSString *component = [NSString stringWithFormat:@"%@.%@", fileName, type];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:component];
    NSString *dataString = nil;
    if ([fileManager fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }

    return dataString;
}

- (void)removeFile:(NSString *)file type:(NSString *)type
{
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    NSString *component = [NSString stringWithFormat:@"%@.%@", file, type];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:component];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}


@end
