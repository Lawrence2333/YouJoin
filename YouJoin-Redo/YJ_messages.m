//
//  YJ_messages.m
//  YouJoin
//
//  Created by Lawrence on 15/12/31.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "YJ_messages.h"

@implementation YJ_messages

+ (instancetype)messageWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
