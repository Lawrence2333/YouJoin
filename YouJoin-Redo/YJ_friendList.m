//
//  YJ_friendList.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/8.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_friendList.h"
#import "YJ_friend.h"
@implementation YJ_friendList

-(void)setFriendList:(NSArray *)friendList{
    
    NSMutableArray *muarray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in friendList) {
        YJ_friend *friend = [YJ_friend friendWithDict:dict];
        [muarray addObject:friend];
    }
    _friendList = muarray;
    
}

@end
