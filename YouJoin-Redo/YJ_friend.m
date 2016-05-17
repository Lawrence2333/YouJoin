//
//  YJ_friend.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/9.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_friend.h"
#import "YJ_networkTool.h"
#import "YJ_userDetailInfo.h"
@implementation YJ_friend

-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        self.friendIconUrl = [dict valueForKey:@"img_url"];
        self.friendID = [dict valueForKey:@"id"];
        self.friendNickname = [dict valueForKey:@"nickname"];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [YJ_networkTool getUserDetailInfo:self.friendID type:YJ_chooseUserTypeUserID completion:^(YJ_userDetailInfo *receivedUserDetailInfo) {
                self.friendUsername = receivedUserDetailInfo.username;
            }];
        });
        
    }
    
    return self;
}

+(instancetype)friendWithDict:(NSDictionary *)dict{
    
    return [[[self class]alloc]initWithDict:dict];
    
}

@end
