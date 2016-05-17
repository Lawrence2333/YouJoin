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

/*
+(void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSDictionary *))completion{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:LOGINURL] ];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"user_name=%@&user_password=%@",username,[password MD5]]dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response != NULL) {
            NSDictionary *receivedDict = [YJ_JSONSerialization JSONObjectWithDataUsingFix:data options:NSJSONReadingAllowFragments error:nil];
            
            completion(receivedDict);
        }
        else {
            NSDictionary *failDict = [NSDictionary dictionaryWithObject:@"unknown failure" forKey:@"result"];
            completion(failDict);
        }
       
    }]resume];
}
*/
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
/*
+(void)getTweetsWithTweetID:(NSString *)tweet_id userID:(NSString*)user_id time:(NSString *)time completion:(void (^)(NSArray *, NSString *))completion{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GET_TWEET_URL]];
    
    request.HTTPMethod = @"POST";
    
    [request setValue:@"application/jason" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *mudict = [NSMutableDictionary dictionary];
    [mudict setObject:tweet_id forKey:@"tweet_id"];
    [mudict setObject:user_id forKey:@"user_id"];
    [mudict setObject:time forKey:@"time"];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:mudict options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = data;
//    request.HTTPBody = [[NSString stringWithFormat:@"tweet_id=%@&user_id=%@&time=%@",tweet_id,user_id,time]dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (response != NULL) {
            
            NSDictionary * receivedDict = [YJ_JSONSerialization JSONObjectWithDataUsingFix:data options:NSJSONReadingAllowFragments error:nil];
            
            NSArray * tweetsArray = [receivedDict valueForKey:@"tweets"];
            
            NSString * resultStr = [receivedDict valueForKey:@"result"];
            
            completion(tweetsArray,resultStr);
        }
        
        else completion(nil,@"unknown failure");
        
    }]resume];
}
 */
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

+(void)getTweetCommentWithTweetID:(NSString *)tweetID completion:(void (^)(NSString *, NSArray *))completion{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:GET_COMMENTS_URL]];
    request.HTTPMethod = @"POST";
    NSString *sendStr = [NSString stringWithFormat:@"tweet_id=%@",tweetID];
    NSLog(@"getTweetComment------------sendStr==%@",sendStr);
    request.HTTPBody = [sendStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (response!=NULL) {
            NSDictionary *resultStr = [YJ_JSONSerialization JSONObjectWithDataUsingFix:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"getTweetComment-----------resultStr==%@",resultStr);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion([resultStr valueForKey:@"result"],[resultStr valueForKey:@"message"]);
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

/*
+(void)updateUserDetailInfo:(YJ_userDetailInfo *)sendUserDetailInfo completion:(void (^)(NSString *))completion{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:UPDATE_USERINFO_URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    request.HTTPMethod = @"POST";
    NSString *sendStr = [NSString jsonStringWithDictionary:[sendUserDetailInfo dictFromUserInfo]];
    request.HTTPBody = [sendStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (response != NULL) {
            
            NSString *receivedStr = [[YJ_JSONSerialization JSONObjectWithDataUsingFix:data options:NSJSONReadingAllowFragments error:nil]valueForKey:@"result"];
            completion(receivedStr);
            
        }
    }];
    
}
*/
+(void)updateUserDetailInfo:(YJ_userDetailInfo *)sendUserDetailInfo picFilePath:(NSString *)picFilePath picFileName:(NSString *)picFileName completion:(void (^)(NSString *))completion{
    NSString *resultStr = [RequestPostUploadHelper postRequestWithURL:UPDATE_USERINFO_URL postParems:[sendUserDetailInfo dictFromUserInfo] picFilePath:picFilePath picFileName:picFileName];
    dispatch_async(dispatch_get_main_queue(), ^{
        completion(resultStr);
    });
}

#pragma mark - im

//#warning 用了friendNickname
//+(void)sendMessagesWithUsername:(NSString *)username friendInfo:(YJ_friend *)friendInfo messageContent:(NSString *)messageContent completion:(void (^)(NSString *))completion{
//    
//    AVIMClient *client = [[AVIMClient alloc]initWithClientId:username];
//    [client openWithCallback:^(BOOL succeeded, NSError *error) {
//        [client createConversationWithName:friendInfo.friendNickname clientIds:@[friendInfo.friendNickname] callback:^(AVIMConversation *conversation, NSError *error) {
//            
//            [conversation sendMessage:[AVIMTextMessage messageWithText:messageContent attributes:nil]callback:^(BOOL succeeded, NSError *error) {
//                if (succeeded) {
//                    completion(@"success");
//                }else completion(@"failure");
//            }];
//        }];
//    }];
//}
//
//+(void)getChatLogWithUserID:(NSString *)userID friendID:(NSString *)friendID time:(YJ_TweetTime)time primsgID:(NSString *)primsgID completion:(void (^)(NSString *, NSArray *))completion{
//    
//}
//+(void)receiveMessage:(NSString *)userID completion:(void (^)(NSString *, NSArray *))completion{
//    
//}

@end
