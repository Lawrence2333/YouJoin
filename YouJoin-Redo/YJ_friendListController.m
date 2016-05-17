//
//  YJ_friendListController.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/7.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_friendListController.h"
#import "YJ_friendList.h"
#import "YJ_addFriendViewController.h"
#import "YJ_networkTool.h"
#import "UIImageView+WebCache.h"
#import "NSString+CutLastChar.h"
#import "YJ_userInfo.h"
#import "UIImage+Circle.h"
#import "UIImage+SmallImage.h"
#import "YJ_chattingViewController.h"
#import "YJ_friendListCell.h"

@interface YJ_friendListController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) YJ_friendList *friends ;

@end

@implementation YJ_friendListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.navigationController.navigationBar setBarTintColor:YJ_NAVIGATIONBAR_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:YJ_NAVIGATIONBAR_TITLE_ATTRS];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIImageView *headerImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
    headerImage.contentMode = UIViewContentModeScaleAspectFit;
    self.tableView.tableHeaderView = headerImage;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendControllerBtn)];
    
    [YJ_networkTool getFriendListWithUserID:[[YJ_userInfo sharedInstance]userID] completion:^(NSString *resultStr, NSArray *receicedFriendListDictArray) {
        
        self.friends = [[YJ_friendList alloc]init];
        self.friends.friendList = receicedFriendListDictArray;
        
        
        [self.tableView reloadData];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    return self.friends.friendList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJ_friendListCell *cell = [YJ_friendListCell cellWithTableView:tableView];
    
    cell.friendInfo = self.friends.friendList[indexPath.row];
    
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString fixStringByCutLastChar: cell.friendInfo.friendIconUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.iconView.image = [UIImage circleImage:[[UIImage alloc]imageWithImage:image scaledToSize:CGSizeMake(40, 40)] borderWidth:2.0 borderColor:YJ_CIRCLE_BORDER_COLOR];
    }];    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 52;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJ_chattingViewController *chattingVC = [[YJ_chattingViewController alloc]init];
    chattingVC.friendInfo = self.friends.friendList[indexPath.row];
    
    [self.navigationController pushViewController:chattingVC animated:YES];
    
}

-(void)addFriendControllerBtn{
    
    YJ_addFriendViewController *addFriendVC = [[YJ_addFriendViewController alloc]init];
    
    [self.navigationController pushViewController:addFriendVC animated:YES];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
