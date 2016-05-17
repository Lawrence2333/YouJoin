//
//  YJ_messages.h
//  YouJoin
//
//  Created by Lawrence on 15/12/31.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    YJ_MessageTypeMe = 0, // 自己发的
    YJ_MessageTypeOther   // 别人发的
} YJ_MessageType;

@interface YJ_messages : NSObject
/**
 *  聊天内容
 */
@property (nonatomic, copy) NSString *text;
/**
 *  发送时间
 */
@property (nonatomic, copy) NSString *time;
/**
 *  信息的类型
 */
@property (nonatomic, assign) YJ_MessageType type;

/**
 *  是否隐藏时间
 */
@property (nonatomic, assign) BOOL hideTime;

+ (instancetype)messageWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
