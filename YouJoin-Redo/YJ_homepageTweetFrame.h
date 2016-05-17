//
//  YJ_homepageTweetFrame.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/3/24.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class YJ_homepageTweet;

@interface YJ_homepageTweetFrame : NSObject

@property(nonatomic,assign,readonly) CGRect incoPicF;
@property(nonatomic,assign,readonly) CGRect usernameF;
@property(nonatomic,assign,readonly) CGRect textContentF;
@property(nonatomic,assign,readonly) CGRect timerF;
@property(nonatomic,assign,readonly) CGRect commentCountF;
@property(nonatomic,assign,readonly) CGRect upVoteCountF;
@property(nonatomic,assign,readonly) CGRect cellPaddingF;
//@property(nonatomic,assign,readonly) CGRect commentF;
@property(nonatomic,assign,readonly) CGRect mycontentViewF;

@property(nonatomic,strong) NSArray *picturesF;

@property(nonatomic,assign,readonly) CGFloat cellHeight;

@property(nonatomic,strong)YJ_homepageTweet *tweets;

@end
