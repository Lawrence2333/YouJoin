//
//  YJ_chattingViewController.h
//  YouJoin
//
//  Created by Lawrence on 15/12/31.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJ_friend;
@interface YJ_chattingViewController : UIViewController

@property (nonatomic, strong) YJ_friend *friendInfo;

@property(nonatomic,copy) NSString * oldConversationID;

@property(nonatomic,strong) NSArray *unReadMessages;

@end
