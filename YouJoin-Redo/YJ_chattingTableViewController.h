//
//  YJ_chattingTableViewController.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/9.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJ_mainTabbarViewController;
@interface YJ_chattingTableViewController : UITableViewController

//@property(nonatomic,strong) NSArray *unReadMessages;
@property (nonatomic,weak) YJ_mainTabbarViewController *mainTabbarController;
@end
