//
//  YJ_homepageTweetComment.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/6/8.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YJ_homepageTweetComment : NSObject

@property(nonatomic,copy) NSString * commentContent;
@property(nonatomic,copy) NSString * commentTime;
@property(nonatomic,copy) NSString * username;
@property(nonatomic,copy) NSString * commentID;
@property(nonatomic,copy) NSString * tweetID;
@property(nonatomic,copy) NSString * friendID;

@property(nonatomic,assign) CGFloat cellHeight;

+(instancetype)commentWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
