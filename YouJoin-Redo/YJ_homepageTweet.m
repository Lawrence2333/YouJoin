//
//  YJ_homepageTweet.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/3/23.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_homepageTweet.h"
#import "RequestPostUploadHelper.h"
#import "YJ_JSONSerialization.h"
#import "NSString+GroupAsArray.h"
#import "YJ_userDetailInfo.h"
#import "UIImageView+WebCache.h"
#import "YJ_networkTool.h"

@implementation YJ_homepageTweet

-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
    
        _username = [dict valueForKey:@"username"];
        _textContent = [dict valueForKey:@"textContent"];
        _tweetID = [dict valueForKey:@"tweetID"];
        _timer = [dict valueForKey:@"timer"];
        _commentCount = (int)[dict valueForKey:@"commentCount"];
        _upVoteCount = (int)[dict valueForKey:@"upVoteCount"];
        _upVoteStatus = (BOOL)[dict valueForKey:@"upVoteStatus"];
        
//        _iconpic = [UIImage imageWithContentsOfFile:[dict valueForKey:@"iconpic"]];
        
        NSArray *picArray = [dict valueForKey:@"pictures"];
        
        _picsUrl = picArray;
        _iconUrl = [dict valueForKey:@"iconpic"];
        
//        NSMutableArray *mupicArray = [[NSMutableArray alloc]init];
//        for (NSString *imageURL in picArray) {
//            [mupicArray addObject:[UIImage imageWithContentsOfFile:imageURL]];
//        }
//        _pictures = mupicArray;
        
    }
    return self;
}
+(instancetype)tweetsWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

-(instancetype)initWithReceivedDict:(NSDictionary *)receivedDict{
    
    if (self = [super init]) {
        
        _tweetID = [receivedDict valueForKey:@"tweets_id"];
        _textContent = [receivedDict valueForKey:@"tweets_content"];
        _commentCount = [[receivedDict valueForKey:@"comment_num"]integerValue];
        _upVoteCount = [[receivedDict valueForKey:@"upvote_num"]integerValue];
        _upVoteStatus = [[receivedDict valueForKey:@"upvote_status"]boolValue];
        _timer = [receivedDict valueForKey:@"tweets_time"];
        
        NSString *userID = [receivedDict valueForKey:@"friend_id"];
        NSArray *picURLArray = [NSString arrayFromString:[receivedDict valueForKey:@"tweets_img"]];

        //获取用户id和头像url
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:REQUEST_USERINFO_URL]];
        request.HTTPBody = [[NSString stringWithFormat:@"param=%@&type=%lu",userID,(unsigned long)YJ_chooseUserTypeUserID] dataUsingEncoding:NSUTF8StringEncoding];
        request.HTTPMethod = @"POST";
        //返回的结果dict
        NSDictionary *dict = [YJ_JSONSerialization JSONObjectWithDataUsingFix:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] options:0 error:nil];
        _username = [dict valueForKey:@"username"];
        NSString *imgUrl = [dict valueForKey:@"img_url"];
//        [imgUrl substringToIndex:imgUrl.length-1];
//#warning 加载头像依旧失败
//        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
//        if (imgData!=nil) {
//            _iconpic = [UIImage imageWithData:imgData];
//        }
//        else _iconpic = nil;
 
        _picsUrl = picURLArray;
        _iconUrl = imgUrl;
        
#pragma mark - picLoad
//        dispatch_queue_t picture_q = dispatch_queue_create("picture_q", DISPATCH_QUEUE_PRIORITY_DEFAULT);
//        
//        NSMutableArray *picArray = [[NSMutableArray alloc]init];
//        for (NSString *picURL in picURLArray) {
//            
//            dispatch_sync(picture_q, ^{
//                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:picURL]]];
//                if (image != nil) {
//                    [picArray addObject:image];
//                }
//            });
//        }
//        _pictures = picArray;
        
    }
    return self;
}
+(instancetype)tweetsWithReceivedDict:(NSDictionary *)receivedDict{
    return [[self alloc]initWithReceivedDict:receivedDict];
}

@end