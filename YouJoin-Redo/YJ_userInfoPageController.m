//
//  YJ_userInfoPageController.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/4.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//
#import "YJ_networkTool.h"
#import "YJ_userInfoPageController.h"
#import "UIImage+Circle.h"
#import "YJ_userInfoPageCell.h"
#import "UIImageView+WebCache.h"
#import "YJ_userDetailInfo.h"
#import "NSString+CutLastChar.h"
#import "YJ_userInfo.h"
#import "MBProgressHUD+MJ.h"
#import "UIImage+SmallImage.h"
#import "YJ_homepageLeftListController.h"

@interface YJ_userInfoPageController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSString *userID;
@property(nonatomic,strong) YJ_userDetailInfo *userDetailInfo;

@end

@implementation YJ_userInfoPageController

-(instancetype)initWithUserID:(NSString *)userID{
    
    if (self = [super init]) {
        self.userID = userID;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navigationItem.title = @"个人资料";
//    self.navigationItem.leftBarButtonItem.title = @"back";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController.navigationBar setBarTintColor:YJ_NAVIGATIONBAR_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:YJ_NAVIGATIONBAR_TITLE_ATTRS];
    
    self.tableView.backgroundColor = YJ_HOMEPAGE_GRAY_COLOR;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([self.userID isEqualToString:[[YJ_userInfo sharedInstance]userID]]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editDetailUserInfo)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    }
    
    __weak YJ_userInfoPageController *weakself = self;
    
    [YJ_networkTool getUserDetailInfo:weakself.userID type:YJ_chooseUserTypeUserID completion:^(YJ_userDetailInfo *receivedUserDetailInfo) {
        
        CGFloat viewPadding = 10;
        
        CGFloat iconViewW = 80;
        CGFloat iconViewH = iconViewW;
        CGFloat iconViewX = weakself.view.center.x-iconViewW/2;
        CGFloat iconViewY = viewPadding+weakself.navigationController.navigationBar.frame.size.height+20;
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH)];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
//        iconView.contentMode = UIViewContentModeScaleAspectFill;
        [iconView sd_setImageWithURL:[NSURL URLWithString:[NSString fixStringByCutLastChar: receivedUserDetailInfo.userImage]] placeholderImage:[UIImage imageNamed:@"logo2"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image!=nil) {
                iconView.image = [UIImage circleImage:[[UIImage alloc]imageWithImage:image scaledToSize:CGSizeMake(80, 80)] borderWidth:2.0 borderColor:YJ_CIRCLE_BORDER_COLOR];
//                iconView.image = [[UIImage alloc]imageWithImage: [UIImage circleImage:image borderWidth:1.0 borderColor:[UIColor whiteColor]] scaledToSize:CGSizeMake(80, 80)];
            }
            else{
                iconView.image = [UIImage circleImage:[[UIImage alloc]imageWithImage:[UIImage imageNamed:@"logo2"] scaledToSize:CGSizeMake(80, 80)] borderWidth:2.0 borderColor:YJ_CIRCLE_BORDER_COLOR];
            }
            
        }];

        
        [weakself.view addSubview:iconView];
        
        weakself.tableView.tableHeaderView = iconView;
        
        weakself.userDetailInfo = receivedUserDetailInfo;
        
        [weakself.tableView reloadData];
    }];
        // Do any additional setup after loading the view.
}

-(void)editDetailUserInfo{
    NSLog(@"touch---editDetailUserInfo");
    
    YJ_homepageLeftListController *vc = [[YJ_homepageLeftListController alloc]init];
    vc.userDetailInfo = self.userDetailInfo;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)addFriend{
    NSLog(@"touch---addFriend");
    [YJ_networkTool addFriendWithUserID:[[YJ_userInfo sharedInstance]userID] param:self.userID type:YJ_chooseUserTypeUserID completion:^(NSString *resultStr) {
        if ([resultStr isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"关注好友成功"];
        }else{
            [MBProgressHUD showError:@"网络故障，请稍后重试"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJ_userInfoPageCell *cell = [[YJ_userInfoPageCell alloc]init];
    
    cell.backgroundColor = YJ_HOMEPAGE_GRAY_COLOR;
    
    if (indexPath.row == 0&&self.userDetailInfo.username!=nil) {
        cell = [[YJ_userInfoPageCell alloc]initWithKey:@"用户名" andValue:self.userDetailInfo.username andBlock:^{
            
        }];
    }else if (indexPath.row == 1&&self.userDetailInfo.username!=nil){
        cell = [[YJ_userInfoPageCell alloc]initWithKey:@"昵称" andValue:self.userDetailInfo.userNickname andBlock:^{
            
        }];
    }else if (indexPath.row == 2&&self.userDetailInfo.username!=nil){
        cell = [[YJ_userInfoPageCell alloc]initWithKey:@"ID" andValue:self.userDetailInfo.userID andBlock:^{
            
        }];
    }else if (indexPath.row == 3&&self.userDetailInfo.username!=nil){
        cell = [[YJ_userInfoPageCell alloc]initWithKey:@"e-mail" andValue:self.userDetailInfo.userEmail andBlock:^{
            
        }];
    }else if (indexPath.row == 4&&self.userDetailInfo.username!=nil){
        cell = [[YJ_userInfoPageCell alloc]initWithKey:@"地址" andValue:self.userDetailInfo.userBirth andBlock:^{
            
        }];
    }else if (indexPath.row == 5&&self.userDetailInfo.username!=nil){
        cell = [[YJ_userInfoPageCell alloc]initWithKey:@"生日" andValue:self.userDetailInfo.userBirth andBlock:^{
            
        }];
    }else if (indexPath.row == 6&&self.userDetailInfo.username!=nil){
        cell = [[YJ_userInfoPageCell alloc]initWithKey:@"工作" andValue:self.userDetailInfo.userWork andBlock:^{
            
        }];
    }else if (indexPath.row == 7&&self.userDetailInfo.username!=nil){
        cell = [[YJ_userInfoPageCell alloc]initWithKey:@"性别" andValue:self.userDetailInfo.userSex andBlock:^{
            
        }];
    }else if (indexPath.row== 8&&self.userDetailInfo.username!=nil){
        cell = [[YJ_userInfoPageCell alloc]initWithKey:@"关注数" andValue:[NSString stringWithFormat:@"%d",self.userDetailInfo.userFocusNum] andBlock:^{
            
        }];
    }else if (indexPath.row == 9&&self.userDetailInfo.username!=nil){
        cell = [[YJ_userInfoPageCell alloc]initWithKey:@"被关注数" andValue:[NSString stringWithFormat:@"%d",self.userDetailInfo.userFollowNum] andBlock:^{
            
        }];
    }else if (indexPath.row == 10&&self.userDetailInfo.username!=nil){
        cell = [[YJ_userInfoPageCell alloc]initWithKey:@"个性签名" andValue:self.userDetailInfo.userSign andBlock:^{
            
        }];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
