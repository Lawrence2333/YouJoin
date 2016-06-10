//
//  YJ_homepageTweetCommentCell.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/6/8.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJ_homepageTweetComment;

@interface YJ_homepageTweetCommentCell : UITableViewCell

@property(nonatomic,strong) YJ_homepageTweetComment *comment;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
