//
//  YJ_userInfo.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/4/16.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVIMClient;

@interface YJ_userInfo : NSObject

@property(nonatomic,copy) NSString * username;
@property(nonatomic,copy) NSString * userID;
@property(nonatomic,copy) NSString * userNickname;
@property(nonatomic,copy) NSString * userEmail;

@property(nonatomic,strong) AVIMClient *client;


+(id)sharedInstance;

@end
