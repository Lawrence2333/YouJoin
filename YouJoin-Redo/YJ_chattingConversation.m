//
//  YJ_chattingConversation.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/9.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_chattingConversation.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "YJ_userInfo.h"

@implementation YJ_chattingConversation


-(instancetype)initWithAVIMConversation:(AVIMConversation *)conversation andUnReadMessages:(NSArray *)unReadMessages{
   
    if (self = [super init]) {
        _conversationID = conversation.conversationId;
        
        [conversation queryMessagesWithLimit:1 callback:^(NSArray *objects, NSError *error) {
            _conversationLastMessage = [objects lastObject];
        }];
        
        _ConversationTitle = conversation.name;
        
        for (NSString *str in conversation.members) {
            if (![str isEqualToString:[[YJ_userInfo sharedInstance]username]]) {
                _username = str;
            }
        }
        
        _unReadMessages = [NSArray arrayWithArray:unReadMessages];

    }
    
    return self;
}
@end
