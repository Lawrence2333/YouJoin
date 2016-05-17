//
//  AVIMConversation+unReadMessages.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/15.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "AVIMConversation+unReadMessages.h"
#import <objc/runtime.h>
@implementation AVIMConversation (unReadMessages)
static char *unReadMessageKey;

-(void)setUnReadMessages:(NSArray *)unReadMessages{
    objc_setAssociatedObject(self, unReadMessageKey, unReadMessages, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSArray *)unReadMessages{
    return objc_getAssociatedObject(self, unReadMessageKey);
}

@end
