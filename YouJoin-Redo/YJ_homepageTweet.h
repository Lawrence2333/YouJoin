//
//  YJ_homepageTweet.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/3/23.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YJ_homepageTweet : NSObject

//1.tweetID
@property(nonatomic,copy) NSString * tweetID;
//2.用户名
@property(nonatomic,copy) NSString * username;
//3.发送内容
@property(nonatomic,copy) NSString * textContent;
//4.发送时间
@property(nonatomic,copy) NSString * timer;
//5.用户头像
@property(nonatomic,strong) UIImage * iconpic;
//6.图片列表(图片)
@property(nonatomic,strong) NSArray * pictures;
//7.点赞数
@property(nonatomic,assign) int upVoteCount;
//8.评论数
@property(nonatomic,assign) int commentCount;
//9.点赞状态
@property(nonatomic,assign) BOOL upVoteStatus;

@property(nonatomic,strong) NSArray *picsUrl;

@property(nonatomic,copy) NSString * iconUrl;


//通过完整的dict（包含9个数据）创建
-(instancetype)initWithDict:(NSDictionary *)dict;
//通过完整的dict（包含9个数据）创建
+(instancetype)tweetsWithDict:(NSDictionary *)dict;
//通过网络接收的数据创建（包含8个数据）
-(instancetype)initWithReceivedDict:(NSDictionary *)receivedDict;
//通过网络接收的数据创建（包含8个数据）
+(instancetype)tweetsWithReceivedDict:(NSDictionary *)receivedDict;

@end
