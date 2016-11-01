//
//  AIMessage.h
//  AITrans
//
//  Created by 王坜 on 15/8/7.
//  Copyright (c) 2015年 __ASIAINFO__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIMessage : NSObject

/*说明:消息体，组成json字符串
 */
@property (nonatomic, strong) NSMutableDictionary *body;

/*说明:消息头，组成HTTP头部
 */
@property (nonatomic, strong) NSMutableDictionary *header;


/*说明:消息服务器地址
 */
@property (nonatomic, strong) NSString *url;

/*说明:唯一标识
 */
@property (nonatomic, assign) NSUInteger uniqueID;


/*说明:获取默认的消息体
 *
 */
+ (instancetype)message;

@end
