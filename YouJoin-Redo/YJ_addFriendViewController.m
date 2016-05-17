//
//  YJ_addFriendViewController.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/13.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_addFriendViewController.h"
#import "ZHPickView.h"
#import "YJ_userDetailInfo.h"
#import "YJ_networkTool.h"
#import "MBProgressHUD+MJ.h"
#import "YJ_userInfoPageController.h"
#import "YJ_View.h"

@interface YJ_addFriendViewController ()<ZHPickViewDelegate>

@property(nonatomic,weak) UIButton *chooseTypeBtn;
@property(nonatomic,weak) UITextField *keyTextField;
@property(nonatomic,strong) ZHPickView *pickView;


@end

@implementation YJ_addFriendViewController

-(void)loadView{
    [super loadView];
    self.view = [[YJ_View alloc]init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"search user";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBarTintColor:YJ_NAVIGATIONBAR_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:YJ_NAVIGATIONBAR_TITLE_ATTRS];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(touchFinshBtn)];
    
    UILabel *chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 64, 300, 40)];
    chooseLabel.text = @"请选择查找用户的方式：";
    chooseLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:chooseLabel];
    
    UIButton *chooseTypeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    chooseTypeBtn.frame = CGRectMake(40, 104, 240, 20);
    [chooseTypeBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [chooseTypeBtn addTarget:self action:@selector(showChooseTypePicker) forControlEvents:UIControlEventTouchUpInside];
    self.chooseTypeBtn = chooseTypeBtn;
    [self.view addSubview:chooseTypeBtn];
    
    UILabel *inputLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 134, 300, 40)];
    inputLabel.text = @"请输入用户键值：";
    inputLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:inputLabel];

    UITextField *keyTextField = [[UITextField alloc]initWithFrame:CGRectMake(30, 174, 260, 30)];
    keyTextField.placeholder = @"用户ID／用户名／用户E-mail";
    self.keyTextField = keyTextField;
    [self.view addSubview:keyTextField];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showChooseTypePicker{
    
    self.pickView = [[ZHPickView alloc]initPickviewWithArray:@[@"用户ID",@"用户名",@"用户E-mail"] isHaveNavControler:NO];
    self.pickView.delegate = self;
    [self.pickView show];
}

-(void)touchFinshBtn{
    
    YJ_chooseUserType chooseType = 0;
    NSString *param = [[NSString alloc]init];
    param = self.keyTextField.text;
    
    if ([self.chooseTypeBtn.titleLabel.text isEqualToString:@"用户ID"]) {
        chooseType = YJ_chooseUserTypeUserID;
    }else if([self.chooseTypeBtn.titleLabel.text isEqualToString:@"用户名"]){
        chooseType = YJ_chooseUserTypeUserName;
    }else if([self.chooseTypeBtn.titleLabel.text isEqualToString:@"用户E-mail"]){
        chooseType = YJ_chooseUserTypeUserEmail;
    }else{
        [MBProgressHUD showError:@"请选择查找方式"];
    }
    
    if (chooseType!=0) {
        if ([self.keyTextField.text isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入键值"];
        }else {
            [YJ_networkTool getUserDetailInfo:param type:chooseType completion:^(YJ_userDetailInfo *receivedUserDetailInfo) {
                
                YJ_userInfoPageController *userInfoPageVC = [[YJ_userInfoPageController alloc]initWithUserID:receivedUserDetailInfo.userID];
                [self.navigationController pushViewController:userInfoPageVC animated:YES];
                
            }];
        }
    }
}

#pragma mark - picker代理方法
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    [self.chooseTypeBtn setTitle:resultString forState:UIControlStateNormal];
    [self.chooseTypeBtn setNeedsDisplay];
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
