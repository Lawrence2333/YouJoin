//
//  YJ_friendListCell.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/8.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJ_friend.h"
@interface YJ_friendListCell : UITableViewCell

@property(nonatomic,strong) UIImageView *iconView;

@property(nonatomic,strong) YJ_friend *friendInfo;

+(instancetype)cellWithTableView:(UITableView*)tableView;

@end
