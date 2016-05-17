//
//  YJ_userDetailInfo.h
//  YouJoin
//
//  Created by MacBookPro on 15/11/13.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YJ_userDetailInfo;
@interface YJ_userDetailInfo : NSObject

@property(nonatomic,copy) NSString * userID;
@property(nonatomic,copy) NSString * username;
@property(nonatomic,copy) NSString * userNickname;
@property(nonatomic,copy) NSString * userEmail;
@property(nonatomic,copy) NSString * userWork;
@property(nonatomic,copy) NSString * userLocation;
@property(nonatomic,copy) NSString * userSex;
@property(nonatomic,copy) NSString * userBirth;
@property(nonatomic,copy) NSString * userSign;

@property(nonatomic,copy) NSString * userImage;

@property(nonatomic,assign) int userFollowNum;
@property(nonatomic,assign) int userFocusNum;

@property(nonatomic,copy) NSString * result;


-(void)setUserInfo:(YJ_userDetailInfo *)userInfo;
+(instancetype)initWithDict:(NSDictionary *)dict;

-(NSDictionary *)dictFromUserInfo;
@end
