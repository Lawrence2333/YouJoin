//
//  YJ_networkTool.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/4/26.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YJ_friend;
@class YJ_userDetailInfo;

typedef enum : NSUInteger {
    YJ_chooseUserTypeUserID = 1,
    YJ_chooseUserTypeUserName = 2,
    YJ_chooseUserTypeUserEmail = 3,
} YJ_chooseUserType;
typedef enum : NSUInteger {
    YJ_TweetOld,
    YJ_TweetNew,
} YJ_TweetTime;
@interface YJ_networkTool : NSObject

//登录
+(void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(NSDictionary * resultDict))completion;

//获取tweets
+(void)getTweetsWithTweetID:(NSString *)tweet_id userID:(NSString*)user_id time:(NSString *)time completion:(void (^)(NSArray *receivedArray, NSString *resultStr))completion;

//获取用户信息
+(void)getUserDetailInfo:(NSString *)param type:(YJ_chooseUserType)YJ_chooseUserType completion:(void(^)(YJ_userDetailInfo *receivedUserDetailInfo))completion;

//更新个人资料
+(void)updateUserDetailInfo:(YJ_userDetailInfo *)sendUserDetailInfo picFilePath:(NSString *)picFilePath picFileName:(NSString *)picFileName completion:(void(^)(NSString *resultStr))completion;

//添加好友
+(void)addFriendWithUserID:(NSString *)userID param:(NSString *)param type:(YJ_chooseUserType)type completion:(void(^)(NSString * resultStr))completion;

//发送心情动态
+(void)sendTweetWithUserID:(NSString *)userID tweetContent:(NSString *)tweetContent tweetImgs:(NSArray *)imgArray imgsNames:(NSArray *)imgNameArray completion:(void(^)(NSString *resultStr))completion;

//给某个用户发送私信
//+(void)sendMessagesWithUsername:(NSString *)username friendInfo:(YJ_friend *)friendInfo messageContent:(NSString *)messageContent completion:(void(^)(NSString *resultStr))completion;

//心情动态的评论
+(void)sendTweetCommentWithUserID:(NSString *)userID tweetID:(NSString *)tweetID commentContent:(NSString *)commentContent completion:(void(^)(NSString *resultStr))completion;

//请求私信数量 只是为了告知你哪些朋友有向你发私信（这里的sender_id也就是你朋友的id此时发给你的全是未读的）
//+(void)receiveMessage:(NSString*)userID completion:(void(^)(NSString *resultStr,NSArray *receicedMessageDictArray))completion;

//点赞
+(void)upvoteTweetWithUserID:(NSString *)userID tweetID:(NSString *)tweetID completion:(void(^)(NSString *resultStr))completion;

//获取好友列表
+(void)getFriendListWithUserID:(NSString *)userID completion:(void(^)(NSString *resultStr,NSArray *receicedFriendListDictArray))completion;

//私信记录 primsg_id(用于查找在此之前的chats，获取最新的话，请设置个大于所有的id值)
//+(void)getChatLogWithUserID:(NSString *)userID friendID:(NSString *)friendID time:(YJ_TweetTime)time primsgID:(NSString *)primsgID completion:(void(^)(NSString *resultStr,NSArray *receicedChatLogDictArray))completion;

//获取心情动态的评论
+(void)getTweetCommentWithTweetID:(NSString *)tweetID completion:(void(^)(NSString *resultStr,NSArray *receicedCommentsDictArray))completion;
@end
