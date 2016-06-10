//
//  YJ_homepageTweetComment.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/6/8.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_homepageTweetComment.h"
#import "YJ_JSONSerialization.h"

typedef enum : NSUInteger {
    YJ_chooseUserTypeUserID = 1,
    YJ_chooseUserTypeUserName = 2,
    YJ_chooseUserTypeUserEmail = 3,
} YJ_chooseUserType;

@implementation YJ_homepageTweetComment

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        _commentContent = [dict valueForKey:@"comment_content"];
        _commentID = [dict valueForKey:@"comment_id"];
        _commentTime = [dict valueForKey:@"comment_time"];
        _tweetID = [dict valueForKey:@"tweet_id"];
        _friendID = [dict valueForKey:@"friend_id"];
        
        //获取用户id和头像url
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:REQUEST_USERINFO_URL]];
        request.HTTPBody = [[NSString stringWithFormat:@"param=%@&type=%lu",_friendID,(unsigned long)YJ_chooseUserTypeUserID] dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPMethod = @"POST";
        //返回的结果dict
        NSDictionary *dict = [YJ_JSONSerialization JSONObjectWithDataUsingFix:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] options:0 error:nil];
        _username = [dict valueForKey:@"username"];
    }
    return self;
}

+(instancetype)commentWithDict:(NSDictionary *)dict{
    return [[YJ_homepageTweetComment alloc]initWithDict:dict];
}

@end
