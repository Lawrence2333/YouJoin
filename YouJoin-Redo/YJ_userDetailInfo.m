//
//  YJ_userDetailInfo.m
//  YouJoin
//
//  Created by MacBookPro on 15/11/13.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "YJ_userDetailInfo.h"

@interface YJ_userDetailInfo()

@end

@implementation YJ_userDetailInfo

-(void)setUserInfo:(YJ_userDetailInfo *)userInfo{
    self.userID = userInfo.userID;
    self.username = userInfo.username;
    self.userNickname = userInfo.userNickname;
    self.userEmail = userInfo.userEmail;
    self.userWork = userInfo.userWork;
    self.userLocation = userInfo.userLocation;
    self.userSex = userInfo.userSex;
    self.userBirth = userInfo.userBirth;
    self.userSign = userInfo.userSign;
    self.userFollowNum = userInfo.userFollowNum;
    self.userFocusNum = userInfo.userFocusNum;
    self.userImage = userInfo.userImage;
    
    self.result = userInfo.result;
    
}

+(instancetype)initWithDict:(NSDictionary *)dict{
    YJ_userDetailInfo *userInfo = [[YJ_userDetailInfo alloc]init];
    userInfo.userID = [dict valueForKey:@"id"];
    userInfo.username = [dict valueForKey:@"username"];
    userInfo.userEmail = [dict valueForKey:@"email"];
    userInfo.userWork = [dict valueForKey:@"work"];
    userInfo.userSex = [dict valueForKey:@"sex"];
    userInfo.userBirth = [dict valueForKey:@"birth"];
    userInfo.userImage = [dict valueForKey:@"img_url"];
    userInfo.userLocation = [dict valueForKey:@"location"];
    if (userInfo.userImage == NULL) {
        userInfo.userImage = @"";
    }
    userInfo.userSign = [dict valueForKey:@"usersign"];
    userInfo.userNickname = [dict valueForKey:@"nickname"];
    
    userInfo.userFollowNum = (int)[dict valueForKey:@"follow_num"];
    userInfo.userFocusNum = (int)[dict valueForKey:@"focus_num"];
    
    userInfo.result = [dict valueForKey:@"result"];
    return userInfo;
}

-(NSDictionary *)dictFromUserInfo{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:self.userID forKey:@"user_id"];
    if(self.userNickname!=NULL){
        [dict setObject:self.userNickname forKey:@"user_nickname"];
    }
    if (self.userLocation!=NULL) {
        [dict setObject:self.userLocation forKey:@"user_location"];
    }
    if (self.userSex!=NULL) {
        [dict setObject:self.userSex forKey:@"user_sex"];
    }if (self.userBirth!=NULL) {
        [dict setObject:self.userBirth forKey:@"user_birth"];
    }if (self.userImage!=NULL) {
        [dict setObject:self.userImage forKey:@"user_img"];
    }if (self.userWork!=NULL) {
        [dict setObject:self.userWork forKey:@"user_work"];
    }
    if (self.userSign!=NULL) {
        [dict setObject:self.userSign forKey:@"user_sign"];
    }
    
    return (NSDictionary*)dict;
}

-(NSString *)description{
    NSString *print = [NSString stringWithFormat:@"userid:%@,useremail:%@,username:%@,result:%@",self.userID,self.userEmail,self.username,self.result];
    return print;
}
@end
