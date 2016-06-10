//
//  YJ_TweetCommentTableViewController.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/6/8.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJ_homepageTweet,YJ_homepageTweetComment;
@interface YJ_TweetCommentTableViewController : UITableViewController

@property(nonatomic,strong)  YJ_homepageTweet * tweet;
@property(nonatomic,strong) NSArray *comments;


@end
