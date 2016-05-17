//
//  YJ_LoginViewController.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/3/22.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_LoginViewController.h"
#import "YJ_LoginViewTextField.h"

#import "YJ_networkTool.h"
#import "YJ_userInfo.h"
#import "YJ_userDetailInfo.h"

#import "NSString+Password.h"
#import "MBProgressHUD+MJ.h"
#import "RequestPostUploadHelper.h"
#import "YJ_JSONSerialization.h"
#import "YJ_mainTabbarViewController.h"
//#import "YJ_homepageTableViewController.h"
//#import "YJ_homepageNavigationController.h"
//#import "YJ_chattingViewController.h"
//#import "YJ_chattingNavigationController.h"
//#import "YJ_moreNavigationController.h"
//#import "YJ_moreViewController.h"

@interface YJ_LoginViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak)YJ_LoginViewTextField * usernameField;
@property (nonatomic,weak)YJ_LoginViewTextField * passwordField;

@property (nonatomic,weak)UIButton * signUpBtn;
@property (nonatomic,weak)UIButton * loginBtn;

@property (nonatomic,strong) YJ_userDetailInfo *myDetailInfo;

@end

@implementation YJ_LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //背景图片
    UIImageView *backgroundImage = [[UIImageView alloc]init];
    backgroundImage.frame = self.view.frame;
    backgroundImage.image = [UIImage imageNamed:@"ios-login"];
    backgroundImage.userInteractionEnabled = YES;
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchBackgroundImage)];
    tap.delegate = self;
    [backgroundImage addGestureRecognizer:tap];
    [self.view addSubview: backgroundImage];
    
    //帐号文本框
    YJ_LoginViewTextField *usernameField = [[YJ_LoginViewTextField alloc]init];
    CGFloat unfX = 0;
    CGFloat unfY = 270;
    CGFloat unfW = 320;
    CGFloat unfH = 40;
    usernameField.placeholder = @"username";
    usernameField.textColor = [UIColor grayColor];
    usernameField.textAlignment = NSTextAlignmentCenter;
    usernameField.clearButtonMode = UITextFieldViewModeAlways;
    usernameField.frame = CGRectMake(unfX, unfY, unfW, unfH);
    [self.view addSubview:usernameField];
    self.usernameField = usernameField;
    
    //密码文本框
    YJ_LoginViewTextField * passwordField = [[YJ_LoginViewTextField alloc]init];
    CGFloat pswX = 0;
    CGFloat pswY = 270+unfH+1;
    CGFloat pswW = 320;
    CGFloat pswH = 40;
    passwordField.placeholder = @"password";
    passwordField.textColor = [UIColor grayColor];
    passwordField.textAlignment = NSTextAlignmentCenter;
    passwordField.secureTextEntry = YES;
    passwordField.clearButtonMode = UITextFieldViewModeAlways;
    [passwordField setValue:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2] forKeyPath:@"_placeholderLabel.textColor"];
    passwordField.frame = CGRectMake(pswX, pswY, pswW, pswH);
    [self.view addSubview:passwordField];
    self.passwordField = passwordField;
    
//    //注册按钮（sign up）
//    UIButton *signUpBtn = [[UIButton alloc]init];
//    self.signUpBtn = signUpBtn;
//    [signUpBtn setBackgroundImage:[UIImage imageNamed:@"login_signUpBtn"]
//                         forState:UIControlStateNormal];
//    [signUpBtn setTitle:@"sign up" forState:UIControlStateNormal];
//    signUpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    signUpBtn.titleLabel.textColor = [UIColor whiteColor];
//    signUpBtn.frame = CGRectMake(60, pswY+pswH+25, 74, 32);
//    [self.view addSubview:signUpBtn];
//    [signUpBtn addTarget:self action:@selector(touchSignUpBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //登录按钮
    UIButton *loginBtn = [[UIButton alloc]init];
    self.loginBtn = loginBtn;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"]
                        forState:UIControlStateNormal];
//    [loginBtn setTitle:@"login" forState:UIControlStateNormal];
//    loginBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    loginBtn.titleLabel.textColor = [UIColor whiteColor];
    loginBtn.frame = CGRectMake(94, pswY+pswH+25, 131, 51);
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(touchloginBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationController.navigationBarHidden = YES;
    
    // Do any additional setup after loading the view from its nib.
}

-(void)touchBackgroundImage{
    [self.view endEditing:YES];
}

-(void)touchSignUpBtn{
    NSLog(@"touch SignUp Button");
}

-(void)touchloginBtn{
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"登录中" toView:self.view];
    __weak YJ_LoginViewController *weakSelf = self;
//    __block NSString *result;
    __block  YJ_mainTabbarViewController *mainTabbarVC;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        
        [YJ_networkTool loginWithUsername:weakSelf.usernameField.text password:weakSelf.passwordField.text completion:^(NSDictionary *resultDict) {
            NSLog(@"resultDict------loginViewController--%@",resultDict);
            
            if ([[resultDict valueForKey:@"result"] isEqualToString:@"success"]) {
                YJ_userInfo *userInfo = [YJ_userInfo sharedInstance];
                userInfo.username = [resultDict valueForKey:@"username"];
                userInfo.userID = [resultDict valueForKey:@"id"];
                userInfo.userEmail = [resultDict valueForKey:@"email"];
                
                mainTabbarVC = [weakSelf loadTabbarViewController];
                
                [weakSelf presentViewController:mainTabbarVC animated:YES completion:^{
                    
                }];
            }
            //登录失败
            else if([[resultDict valueForKey:@"result"] isEqualToString: @"failure"])
            {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^
                 {
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"用户名或密码错误" message:@"登录失败" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles: nil];
                     [alertView show];
                 }];
            }
            //服务器忙
            else if([[resultDict valueForKey:@"result"] isEqualToString: @"fail_serverbusy"])
            {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^
                 {
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"服务器忙，请稍后再试" message:@"登录失败" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles: nil];
                     [alertView show];
                }];
            }
            else if([[resultDict valueForKey:@"result"] isEqualToString: @"network error"])
            {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^
                 {
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"网络连接失败，请稍后再试" message:@"登录失败" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles: nil];
                     [alertView show];
                 }];
            }
            else if ([[resultDict valueForKey:@"result"]isEqualToString:@"unknown failure"])
            {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"未知错误" message:@"登录失败" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alertView show];

                }];
            }
            
            
        }];
        
    } completionBlock:^{
        
        
        
    }];
    
    
}

#pragma mark - tabbarViewController设置和载入
-(YJ_mainTabbarViewController *)loadTabbarViewController{
    
    //创建mainTabbarVC
    YJ_mainTabbarViewController *mainTabbarVC = [[YJ_mainTabbarViewController alloc]init];
    
    return mainTabbarVC;
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
