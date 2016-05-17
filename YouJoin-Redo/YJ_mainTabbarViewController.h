//
//  YJ_mainTabbarViewController.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/3/22.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVIMTypedMessage;
@class AVIMConversation;

@protocol YJ_mainTabbarReceivedMessageDelegate <NSObject>

-(void)didReceivedMessages:(AVIMTypedMessage *)messages andConversation:(AVIMConversation *)conversation;

@end

@interface YJ_mainTabbarViewController : UITabBarController

@property(nonatomic,assign) int unReadMessagesCount;

@property(nonatomic,weak) id<YJ_mainTabbarReceivedMessageDelegate> YJ_delegate;

@end
