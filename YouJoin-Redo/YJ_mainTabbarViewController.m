//
//  YJ_mainTabbarViewController.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/3/22.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_mainTabbarViewController.h"
#import "YJ_homepageTableViewController.h"
#import "YJ_chattingTableViewController.h"
#import "YJ_friendListController.h"
#import "YJ_moreViewController.h"

#import "YJ_userInfo.h"
#import "YJ_chattingConversation.h"
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface YJ_mainTabbarViewController ()<AVIMClientDelegate>

@end

@implementation YJ_mainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark - tabbar设置
    YJ_homepageTableViewController *homepageVC = [[YJ_homepageTableViewController alloc]init];
    [self createVC:homepageVC Title:@"homepage" imageName:@"homepage_btn"];
    
    YJ_chattingTableViewController *chattingVC  = [[YJ_chattingTableViewController alloc]init];
    [self createVC:chattingVC Title:@"chat" imageName:@"chat_btn"];
    self.YJ_delegate = chattingVC;
    chattingVC.mainTabbarController = self;
    
    YJ_friendListController *friendVC = [[YJ_friendListController alloc]init];
    [self createVC:friendVC Title:@"friend" imageName:@"friend_btn"];
    
    YJ_moreViewController *moreVC = [[YJ_moreViewController alloc]init];
    [self createVC:moreVC Title:@"more" imageName:@"more_btn"];
    
    YJ_userInfo *userInfo = [YJ_userInfo sharedInstance];
    userInfo.client = [[AVIMClient alloc]initWithClientId:userInfo.username];
    [userInfo.client openWithCallback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"client succeeded in tabbarController");
            userInfo.client.delegate = self;
            self.unReadMessagesCount = 0;
        }
    }];
    
    NSLog(@"%@",[self class]);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createVC:(UIViewController *)vc Title:(NSString *)title imageName:(NSString *)imageName
{
    vc.title = title;
    
    self.tabBar.tintColor = [UIColor colorWithRed:68/255.0 green:173/255.0 blue:159/255.0 alpha:1];
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    NSString *imageSelect = [NSString stringWithFormat:@"%@_sel",imageName];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:imageSelect] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:[[UINavigationController alloc]initWithRootViewController:vc]];
}

#pragma mark - AVIMClientDelegate
-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    
    NSLog(@"didReceiveTypedMessage-- --conversation-- %@ --message -- %@",conversation.name,message.text);
    
    self.unReadMessagesCount++;
    
    if (self.unReadMessagesCount!=0) {
        [[self.tabBar.items objectAtIndex:1] setBadgeValue:[NSString stringWithFormat:@"%d",self.unReadMessagesCount]];
        
//        YJ_chattingTableViewController *chattingVC = ((YJ_chattingTableViewController*)self.childViewControllers[1]);
        
        if ([self.YJ_delegate respondsToSelector:@selector(didReceivedMessages:andConversation:)] ) {
            [self.YJ_delegate didReceivedMessages:message andConversation:conversation];
        }
//        [self.YJ_delegate didReceivedMessages:message andConversation:conversation];

    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
