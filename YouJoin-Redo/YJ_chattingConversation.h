//
//  YJ_chattingConversation.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/9.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVIMConversation;

@interface YJ_chattingConversation : NSObject

@property(nonatomic,copy) NSString * username;
@property(nonatomic,copy) NSString * conversationID;
@property(nonatomic,copy) NSString * conversationLastMessage;
@property(nonatomic,copy) NSString * ConversationTitle;

@property(nonatomic,strong) NSArray *unReadMessages;


//-(void)setDataWithAVIMConversation:(AVIMConversation *)conversation;
-(instancetype)initWithAVIMConversation:(AVIMConversation *)conversation andUnReadMessages:(NSArray *)unReadMessages;
@end
