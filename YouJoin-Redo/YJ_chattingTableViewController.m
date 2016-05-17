//
//  YJ_chattingTableViewController.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/9.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_chattingTableViewController.h"
#import <AVOSCloudIM/AVOSCloudIM.h>
#import "YJ_chattingConversation.h"
#import "YJ_chattingTableViewCell.h"
#import "YJ_mainTabbarViewController.h"
#import "YJ_userInfo.h"
#import "YJ_chattingViewController.h"
#import "AVIMConversation+unReadMessages.h"
@interface YJ_chattingTableViewController ()<UITableViewDataSource,UITableViewDelegate,YJ_mainTabbarReceivedMessageDelegate>

@property (nonatomic,strong) AVIMClient *client;

@property(nonatomic,strong) NSArray *conversationArray;

@end

@implementation YJ_chattingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:YJ_NAVIGATIONBAR_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:YJ_NAVIGATIONBAR_TITLE_ATTRS];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIImageView *headerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    self.tableView.tableHeaderView = headerImage;
    
    self.client = [[AVIMClient alloc]initWithClientId:[[YJ_userInfo sharedInstance]username]];

    [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
        
        AVIMConversationQuery *query = [self.client conversationQuery];
        query.limit = 50;
        [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
            
            NSMutableArray *muArray = [NSMutableArray array];
            
            for (AVIMConversation *object in objects) {
                
                BOOL isMine = NO;
                for (NSString *member in object.members) {
                    if ([member isEqualToString:[[YJ_userInfo sharedInstance]username]]) {
                        isMine = YES;
                    }
                }
                if (isMine) {
                    [muArray addObject:object];
                }
            }
            self.conversationArray = muArray;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    }];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversationArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}

#pragma mark - tableView Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJ_chattingTableViewCell *cell = [YJ_chattingTableViewCell cellWithTableView:tableView];
    
    cell.conversation = [[YJ_chattingConversation alloc]initWithAVIMConversation:[self.conversationArray objectAtIndex:indexPath.row]andUnReadMessages:((AVIMConversation *)[self.conversationArray objectAtIndex:indexPath.row]).unReadMessages];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJ_chattingViewController *chattingVC = [[YJ_chattingViewController alloc]init];
    
    chattingVC.oldConversationID = ((AVIMConversation *)[self.conversationArray objectAtIndex:indexPath.row]).conversationId;
    
    if (((AVIMConversation *)[self.conversationArray objectAtIndex:indexPath.row]).unReadMessages!=nil) {
        
        chattingVC.unReadMessages = ((AVIMConversation *)[self.conversationArray objectAtIndex:indexPath.row]).unReadMessages;
        
        ((AVIMConversation *)[self.conversationArray objectAtIndex:indexPath.row]).unReadMessages = nil;
        
        NSString *oldValue = self.tabBarController.tabBar.items[1].badgeValue;
        self.tabBarController.tabBar.items[1].badgeValue = [NSString stringWithFormat:@"%d",[oldValue intValue]-chattingVC.unReadMessages.count];
        
        self.mainTabbarController.unReadMessagesCount -= chattingVC.unReadMessages.count;
        if (self.mainTabbarController.unReadMessagesCount == 0) {
            self.mainTabbarController.tabBar.items[1].badgeValue = nil;
        }
        [self.tableView reloadData];
    }
    
    [self.navigationController pushViewController:chattingVC animated:YES];
    
}

#pragma mark - YJ_didReceivedMessageDelegate
-(void)didReceivedMessages:(AVIMTypedMessage *)messages andConversation:(AVIMConversation *)conversation{
    
    for (AVIMConversation *object in self.conversationArray) {
        if ([object.conversationId isEqualToString:conversation.conversationId]) {
            
            NSMutableArray *muArray = [NSMutableArray arrayWithArray:object.unReadMessages];
            if (muArray == nil) {
                muArray = [NSMutableArray array];
            }
            [muArray addObject:messages];
           
            object.unReadMessages = muArray;
            
            [self.tableView reloadData];
            
            break;
        }
    }

}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
