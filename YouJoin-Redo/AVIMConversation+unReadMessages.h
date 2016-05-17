//
//  AVIMConversation+unReadMessages.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/15.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <AVOSCloudIM/AVOSCloudIM.h>

@interface AVIMConversation (unReadMessages)

@property (nonatomic,strong) NSArray *unReadMessages;

@end
