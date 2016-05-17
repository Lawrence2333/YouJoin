//
//  YJ_SignUpViewController.m
//  YouJoin
//
//  Created by MacBookPro on 15/11/15.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "YJ_SignUpViewController.h"
#import "YJ_LoginViewTextField.h"
#import "YJ_LoginViewController.h"
#import "YJ_View.h"
#import "AppDelegate.h"
#import "NSString+Password.h"
#import "YJ_JSONSerialization.h"
#import "YJ_userInfo.h"

@interface YJ_SignUpViewController ()
//- (IBAction)signUpClick;
//- (IBAction)cancelClick;
@property (weak, nonatomic) YJ_LoginViewTextField *usernameField;
@property (weak, nonatomic) YJ_LoginViewTextField *passwordField;
@property (weak, nonatomic) YJ_LoginViewTextField *passwordAgainField;
@property (weak, nonatomic) YJ_LoginViewTextField *emailField;
@property (weak,nonatomic) UIButton *signUpBtn;
@property (weak,nonatomic) UIButton *cancelBtn;

@property(nonatomic,weak) AppDelegate *appDelegate;
//服务器收到的data
@property (nonatomic, strong) NSMutableData *data;

@end

@implementation YJ_SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //backgroundImage setting
    UIImageView *backgroundImage = [[UIImageView alloc]init];
    backgroundImage.image = [UIImage imageNamed:@"signUp_background"];
    backgroundImage.frame = self.view.frame;
    
    [self.view addSubview:backgroundImage];

#pragma mark - textField Setting
    
    CGFloat padding = 20;
    CGFloat fieldHeight = 50;
    CGFloat fieldWith = 320;
    CGFloat fieldX = 0;
    CGFloat firstY = 80;
    CGFloat textFieldAlpha = 0.4;
    
    
    //userNameField setting
    
    YJ_LoginViewTextField *userNameField = [[YJ_LoginViewTextField alloc]init];
    self.usernameField = userNameField;
    CGFloat usernameY = firstY;
    userNameField.placeholder = @"username";
    userNameField.textAlignment = NSTextAlignmentCenter;
    userNameField.clearButtonMode = UITextFieldViewModeAlways;
    userNameField.frame = CGRectMake(fieldX, usernameY, fieldWith, fieldHeight);
    [userNameField setValue:[UIColor colorWithRed:0 green:0 blue:0 alpha:textFieldAlpha] forKeyPath:@"_placeholderLabel.textColor"];
    userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    //    userNameField.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:userNameField];
    
    //passWordField setting
    
    YJ_LoginViewTextField *passWordField = [[YJ_LoginViewTextField alloc]init];
    self.passwordField = passWordField;
    CGFloat pswY = usernameY+padding+fieldHeight;
    passWordField.placeholder = @"password";
    passWordField.textAlignment = NSTextAlignmentCenter;
    passWordField.secureTextEntry = YES;
    passWordField.clearButtonMode = UITextFieldViewModeAlways;
    [passWordField setValue:[UIColor colorWithRed:0 green:0 blue:0 alpha:textFieldAlpha] forKeyPath:@"_placeholderLabel.textColor"];
    passWordField.frame = CGRectMake(fieldX, pswY, fieldWith, fieldHeight);
    passWordField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:passWordField];

    //passWordAgainField setting
    
    YJ_LoginViewTextField *passWordAgainField = [[YJ_LoginViewTextField alloc]init];
    self.passwordAgainField = passWordAgainField;
    CGFloat pswaY = pswY+padding+fieldHeight;
    passWordAgainField.placeholder = @"password again";
    passWordAgainField.textAlignment = NSTextAlignmentCenter;
    passWordAgainField.secureTextEntry = YES;
    passWordAgainField.clearButtonMode = UITextFieldViewModeAlways;
    [passWordAgainField setValue:[UIColor colorWithRed:0 green:0 blue:0 alpha:textFieldAlpha] forKeyPath:@"_placeholderLabel.textColor"];
    passWordAgainField.frame = CGRectMake(fieldX, pswaY, fieldWith, fieldHeight);
    passWordAgainField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:passWordAgainField];
    
    //emailField setting
    
    YJ_LoginViewTextField *eMailField = [[YJ_LoginViewTextField alloc]init];
    self.emailField = eMailField;
    CGFloat emY = pswaY+padding+fieldHeight;
    eMailField.placeholder = @"email";
    eMailField.textAlignment = NSTextAlignmentCenter;
//    eMailField.secureTextEntry = YES;
    eMailField.clearButtonMode = UITextFieldViewModeAlways;
    [eMailField setValue:[UIColor colorWithRed:0 green:0 blue:0 alpha:textFieldAlpha] forKeyPath:@"_placeholderLabel.textColor"];
    eMailField.frame = CGRectMake(fieldX, emY, fieldWith, fieldHeight);
    eMailField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:eMailField];

#pragma mark - btnSetting
    
    CGFloat btnH = 32;
    CGFloat btnW = 74;
    CGFloat btnPaddingX = 40;
    CGFloat btnPaddingY = 60;
    //signupBtn setting
    
    UIButton *signUpBtn = [[UIButton alloc]init];
    self.signUpBtn = signUpBtn;
    //    loginBtn.backgroundColor = [UIColor redColor];
    [signUpBtn setBackgroundImage:[UIImage imageNamed:@"signUp_signUpBtn"]
                        forState:UIControlStateNormal];
    [signUpBtn setTitle:@"sign up" forState:UIControlStateNormal];
    signUpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    signUpBtn.titleLabel.textColor = [UIColor whiteColor];
    
    CGFloat signupY = emY+btnPaddingY+fieldHeight;
    CGFloat signupX = 160+btnPaddingX/2;
    signUpBtn.frame = CGRectMake(signupX, signupY, btnW, btnH);
    [self.view addSubview:signUpBtn];
    [signUpBtn addTarget:self action:@selector(signUpClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //cancelBtn setting
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    self.cancelBtn = cancelBtn;
    //    loginBtn.backgroundColor = [UIColor redColor];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"signUp_cancelBtn"]
                         forState:UIControlStateNormal];
    [cancelBtn setTitle:@"cancel" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    cancelBtn.titleLabel.textColor = [UIColor whiteColor];
    
    CGFloat cancelY = emY+btnPaddingY+fieldHeight;
    CGFloat cancelX = 160-btnPaddingX/2-btnW;
    cancelBtn.frame = CGRectMake(cancelX, cancelY, btnW, btnH);
    [self.view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationController.navigationBarHidden = YES;
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

#pragma mark -点了注册
- (void)signUpClick:(UIButton *)Btn {
    
    if ([self.usernameField hasText] == NO||[self.passwordField hasText] == NO||[self.passwordAgainField hasText] == NO||[self.emailField hasText] == NO)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请完成所有数据填入" message:@"注册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    else if (![self.passwordAgainField.text isEqualToString:self.passwordField.text])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"两次输入密码不同" message:@"注册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:SIGNUPRUL];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"POST";
        
        NSString *str = [NSString stringWithFormat: @"user_name=%@&user_password=%@&user_email=%@",self.usernameField.text,[self.passwordField.text MD5],self.emailField.text];
        
        request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError) {
            
            //链接正常
            if (connectionError == NULL) {
                //新建数据字典
                NSMutableDictionary *loginDict = [[NSMutableDictionary alloc]init];
                //json转字典
                loginDict = [YJ_JSONSerialization JSONObjectWithDataUsingFix:data options:0 error:NULL];
                
                YJ_userInfo *userInfo = [YJ_userInfo sharedInstance];
               
                if ([[loginDict valueForKey:@"result"] isEqualToString:@"success"]) {
                    
                    userInfo.userID = [loginDict valueForKey:@"id"];
                    userInfo.username = [loginDict valueForKey:@"username"];
                    userInfo.userEmail = [loginDict valueForKey:@"email"];
                    NSLog(@"%@",userInfo);

                    [[NSOperationQueue mainQueue]addOperationWithBlock:^
                     {
                         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"注册成功" message:@"帮您自动登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                         [alertView show];
                         [self dismissViewControllerAnimated:YES completion:^{
                             YJ_LoginViewController *loginVC = [[YJ_LoginViewController alloc]init];
                             [self presentViewController:loginVC animated:YES completion:^{
                                 
                             }];
                         }];
                     }];
                }
                else if ([[loginDict valueForKey:@"result"] isEqualToString:@"fail_username"]){
                    [[NSOperationQueue mainQueue]addOperationWithBlock:^
                     {
                         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"用户名已被使用" message:@"注册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                         [alertView show];
                     }];
                }
                else{
                    [[NSOperationQueue mainQueue]addOperationWithBlock:^
                     {
                         UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"未知错误" message:@"注册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                         [alertView show];
                     }];
                }
            }
            else{
                [[NSOperationQueue mainQueue]addOperationWithBlock:^
                 {
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"未知错误" message:@"注册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                     [alertView show];
                }];
            }

        }];
    }
}

- (void)cancelClick:(UIButton *)Btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//-(void)loginIn
//{
//    //设置url
//    NSURL *url = [NSURL URLWithString:LOGINURL];
//    //设置请求
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
//    //设置请求方式
//    request.HTTPMethod = @"POST";
//    
//    //获取数据
//    NSString *str = [NSString stringWithFormat: @"user_name=%@&user_password=%@",self.usernameField.text,[self.passwordField.text MD5]];
//    
//    //NSLog(@"%@",str);
//    
//    //设置请求的字符串（数据）和编码格式
//    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
//    
//    //建立异步请求链接
//    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError)
//     {
//         
//         //链接正常
//         if (connectionError == NULL)
//         {
//             //            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//             //新建数据字典
//             NSMutableDictionary *loginDict = [[NSMutableDictionary alloc]init];
//             //json转字典
//             loginDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//             self.appDelegate.userInfo.result = [loginDict valueForKey:@"result"];
////             向全局变量赋值
////             self.appDelegate.userInfo = [YJ_userInfo initWithDict:loginDict];
////             NSLog(@"%@",self.appDelegate.userInfo);
//             
////             //登录失败
////             if([self.appDelegate.userInfo.result isEqualToString: @"failure"])
////             {
////                 [[NSOperationQueue mainQueue]addOperationWithBlock:^
////                  {
////                      UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"用户名或密码错误" message:@"登录失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
////                      [alertView show];
////                      self.loginBtn.hidden = NO;
////                      [self.activity stopAnimating];
////                  }];
////             }
//             //服务器忙
//             if([self.appDelegate.userInfo.result isEqualToString: @"fail_serverbusy"])
//             {
//                 [[NSOperationQueue mainQueue]addOperationWithBlock:^
//                  {
//                      UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"服务器忙，请稍后再试" message:@"登录失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                      [alertView show];
//                }];
//             }
//             //登录成功
//             else if([self.appDelegate.userInfo.result isEqualToString:@"success"])
//             {
//                 [[NSOperationQueue mainQueue]addOperationWithBlock:^
//                  {
////                      [self performSegueWithIdentifier:@"segueToMainBarController" sender:self];
//                  }];
//             }
//         }
//     }];
//}
//
////- (void)keyBoardWillChangeFrame:(NSNotification *)note
////{
////    // 设置窗口的颜色
////    self.view.window.backgroundColor = self.view.backgroundColor;
////    
////    // 0.取出键盘动画的时间
////    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
////    
////    // 1.取得键盘最后的frame
////    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
////    
////    // 2.计算控制器的view需要平移的距离
////    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
////    
////    // 3.执行动画
////    [UIView animateWithDuration:duration animations:^{
////        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
////    }];
////
////}
@end
