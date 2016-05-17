//
//  YJ_chattingMessagesCell.h
//  YouJoin
//
//  Created by Lawrence on 15/12/31.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJ_messagesFrame;

@interface YJ_chattingMessagesCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong) YJ_messagesFrame *messagesFrame;

@end
