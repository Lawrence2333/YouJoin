//
//  YJ_userInfo.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/4/16.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_userInfo.h"

@implementation YJ_userInfo

static YJ_userInfo *instance;

+(YJ_userInfo*)sharedInstance{
    
    static YJ_userInfo *instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    
    return instance;
}

//
//+(instancetype)allocWithZone:(struct _NSZone *)zone{
//    
//    static YJ_userInfo *instance;
//    
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//        instance = [super allocWithZone:zone];
//    })
//    
//}

@end
