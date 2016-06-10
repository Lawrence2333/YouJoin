//
//  YJ_networkTool.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/4/26.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_networkTool.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "NSString+Password.h"
#import "NSString+Json.h"
#import "RequestPostUploadHelper.h"
#import "YJ_friend.h"
#import "YJ_userDetailInfo.h"
#import "YJ_JSONSerialization.h"
@implementation YJ_networkTool

+(void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSDictionary *))completion{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:LOGINURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"user_name=%@&user_password=%@",username,[password MD5]]dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (response != nil) {
            NSDictionary *receivedDict = [YJ_JSONSerialization JSONObjectWithDataUsingFix:data options:NSJSONReadingAllowFragments error:Nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(receivedDict);
            });
            
        }
        else if([connectionError.domain isEqualToString:NSURLErrorDomain]){
            NSDictionary *failDict = [NSDictionary dictionaryWithObject:@"network error" forKey:@"result"];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(failDict);
            });
            
        }
        else{
            NSDictionary *failDict = [NSDictionary dictionaryWithObject:@"unknown failure" forKey:@"result"];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(failDict);
            });
        }
    }];
}

#pragma mark - tweets
+(void)getTweetsWithTweetID:(NSString *)tweet_id userID:(NSString *)user_id time:(NSString *)time completion:(void (^)(NSArray *, NSString *))completion{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GET_TWEETS_URL]];
    request.HTTPMethod = @"POST";
    NSString *sendStr = [NSString stringWithFormat:@"tweet_id=%@&user_id=%@&time=%@",tweet_id,user_id,time];
    request.HTTPBody = [sendStr dataUsingEncoding:NSUTF8StringEncoding];
     NSLog(@"getTweets------------sendStr==%@",sendStr);
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(response != NULL){
            
            NSDictionary *receivedDict = [YJ_JSONSerialization dictWithDataWithArray:data];
            NSLog(@"getTweets-----------receivedDict==%@",receivedDict);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([receivedDict valueForKey:@"tweets"],[receivedDict valueForKey:@"result"]);
            });
        }
    }];
    
}

+(void)sendTweetCommentWithUserID:(NSString *)userID tweetID:(NSString *)tweetID commentContent:(NSString *)commentContent completion:(void (^)(NSString *))completion{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:COMMENT_TWEET_URL]];
    request.HTTPMethod = @"POST";
    NSString *sendStr = [NSString stringWithFormat:@"tweet_id=%@&user_id=%@&comment_content=%@",tweetID,userID,commentContent];
    NSLog(@"sendTweetComment------------sendStr==%@",sendStr);
    request.HTTPBody = [sendStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (response!=NULL) {
            NSDictionary *resultStr = [YJ_JSONSerialization JSONObjectWithDataUsingFix:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"sendTweetComment-----------resultStr==%@",resultStr);
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([resultStr valueForKey:@"result"]);
            });
        }
    }];
}

+(void)upvoteTweetWithUserID:(NSString *)userID tweetID:(NSString *)tweetID completion:(void (^)(NSString *))completion{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:UPVOTE_TWEET_URL]];
    request.HTTPMethod = @"POST";
    NSString *sendStr = [NSString stringWithFormat:@"tweet_id=%@&user_id=%@",tweetID,userID];
    NSLog(@"upvoteTweet------------sendStr==%@",sendStr);
    request.HTTPBody = [sendStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (response!=NULL) {
            NSDictionary *resultStr = [YJ_JSONSerialization JSONObjectWithDataUsingFix:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"upvoteTweet-----------resultStr==%@",resultStr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([resultStr valueForKey:@"result"]);
            });
        }
    }];

}

+(void)isUpvoteTweetWithUserID:(NSString *)userID tweetID:(NSString *)tweetID completion:(void (^)(NSString *))completion{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:IS_UPVOTE_TWEET_URL]];
    request.HTTPMethod = @"POST";
    NSString *sendStr = [NSString stringWithFormat:@"tweet_id=%@&user_id=%@",tweetID,userID];
    NSLog(@"upvoteTweet------------sendStr==%@",sendStr);
    request.HTTPBody = [sendStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (response!=NULL) {
            NSDictionary *resultStr = [YJ_JSONSerialization JSONObjectWithDataUsingFix:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"upvoteTweet-----------resultStr==%@",resultStr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([resultStr valueForKey:@"result"]);
            });
        }
    }];

}

+(void)getTweetCommentWithTweetID:(NSString *)tweetID completion:(void (^)(NSString *, NSArray *))completion{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GET_COMMENTS_URL]];
    request.HTTPMethod = @"POST";
    NSString *sendStr = [NSString stringWithFormat:@"tweet_id=%@",tweetID];
    NSLog(@"getTweetComment------------sendStr==%@",sendStr);
    request.HTTPBody = [sendStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (response!=NULL) {
            NSDictionary *resultStr = [YJ_JSONSerialization dictWithDataWithArray:data];
            NSLog(@"getTweetComment-----------resultStr==%@",resultStr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([resultStr valueForKey:@"result"],[resultStr valueForKey:@"comments"]);
            });
        }
    }];

}

+(void)sendTweetWithUserID:(NSString *)userID tweetContent:(NSString *)tweetContent tweetImgs:(NSArray *)imgArray imgsNames:(NSArray *)imgNameArray completion:(void (^)(NSString *))completion{
    NSMutableDictionary *sendDict = [[NSMutableDictionary alloc]init];
    [sendDict setObject:userID forKey:@"user_id"];
    [sendDict setObject:tweetContent forKey:@"tweets_content"];
    NSString *resultStr = [RequestPostUploadHelper postRequestWithURL:SEND_TWEET_URL postParems:sendDict picFilePath:imgArray picFileNameArray:imgNameArray];
    NSDictionary *resultDict = [YJ_JSONSerialization JSONObjectWithDataUsingFix:[resultStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    NSLog(@"sendTweet------------resultDict==%@",resultDict);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        completion([resultDict valueForKey:@"result"]);
    });
}

#pragma mark - friend list
+(void)addFriendWithUserID:(NSString *)userID param:(NSString *)param type:(YJ_chooseUserType)type completion:(void (^)(NSString *))completion{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:ADD_FRIEND_URL]];
    request.HTTPMethod = @"POST";
    NSString *sendStr = [NSString stringWithFormat:@"user_id=%@&param=%@&type=%lu",userID,param,(unsigned long)type];
    NSLog(@"addFriend------------sendStr==%@",sendStr);
    request.HTTPBody = [sendStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (response!=NULL) {
            NSDictionary *resultStr = [YJ_JSONSerialization JSONObjectWithDataUsingFix:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"addFriend-----------resultStr==%@",resultStr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([resultStr valueForKey:@"result"]);
            });
        }
    }];

}

+(void)getFriendListWithUserID:(NSString *)userID completion:(void (^)(NSString *, NSArray *))completion{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GET_FRIENDLIST_URL]];
    request.HTTPMethod = @"POST";
    NSString *sendStr = [NSString stringWithFormat:@"user_id=%@",userID];
    request.HTTPBody = [sendStr dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"getFriendList------------sendStr==%@",sendStr);
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if(response != NULL){
            
            NSDictionary *receivedDict = [YJ_JSONSerialization dictWithDataWithArray:data];
            NSLog(@"getFriendList-----------receivedDict==%@",receivedDict);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([receivedDict valueForKey:@"result"],[receivedDict valueForKey:@"friends"]);
            });
        }
    }];

}

#pragma mark - userInfo
+(void)getUserDetailInfo:(NSString *)param type:(YJ_chooseUserType)YJ_chooseUserType completion:(void (^)(YJ_userDetailInfo*))completion{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:REQUEST_USERINFO_URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    request.HTTPMethod = @"POST";
    request.HTTPBody =[[NSString stringWithFormat:@"param=%@&type=%lu",param,(unsigned long)YJ_chooseUserType]dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (response != NULL) {
            
            NSMutableDictionary *receivedDict = [YJ_JSONSerialization JSONObjectWithDataUsingFix:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"getUserDetailInfo------receivedDict%@",receivedDict);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([YJ_userDetailInfo initWithDict:receivedDict]);
            });
        }
        
    }];
    
}

+(void)updateUserDetailInfo:(YJ_userDetailInfo *)sendUserDetailInfo picFilePath:(NSString *)picFilePath picFileName:(NSString *)picFileName completion:(void (^)(NSString *))completion{
    NSString *resultStr = [RequestPostUploadHelper postRequestWithURL:UPDATE_USERINFO_URL postParems:[sendUserDetailInfo dictFromUserInfo] picFilePath:picFilePath picFileName:picFileName];
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(resultStr);
    });
}

#pragma mark - im

@end
