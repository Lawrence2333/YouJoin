//
//  YJ_chattingTableViewCell.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/9.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJ_chattingConversation;

@interface YJ_chattingTableViewCell : UITableViewCell

@property(nonatomic,weak) UIImageView *iconView;
@property(nonatomic,weak) UILabel *nameLabel;
@property(nonatomic,weak) UILabel *messageLabel;
@property(nonatomic,weak) UIButton *unReadMessagesCountBtn;

@property(nonatomic,strong) YJ_chattingConversation *conversation;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
