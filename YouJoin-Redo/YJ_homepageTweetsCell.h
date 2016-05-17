//
//  YJ_homepageTweetsCell.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/3/24.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJ_homepageTweetFrame;

@interface YJ_homepageTweetsCell : UITableViewCell

@property(nonatomic,strong) YJ_homepageTweetFrame *tweetsFrame;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
