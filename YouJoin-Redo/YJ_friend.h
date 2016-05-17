//
//  YJ_friend.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/9.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJ_friend : NSObject

@property(nonatomic,copy) NSString * friendID;
@property(nonatomic,copy) NSString * friendIconUrl;
@property(nonatomic,copy) NSString * friendNickname;
@property(nonatomic,copy) NSString * friendUsername;

+(instancetype)friendWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
