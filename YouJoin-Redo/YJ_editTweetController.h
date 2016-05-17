//
//  YJ_editTweetController.h
//  YouJoin
//
//  Created by MacBookPro on 15/12/18.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJ_homepageTweet;

@protocol YJ_editTweetSendDelegate <NSObject>

-(void)YJ_editTweetDidSendTweet;

@end

@interface YJ_editTweetController : UIViewController

@property(nonatomic,weak) id<YJ_editTweetSendDelegate> delegate;

@end
