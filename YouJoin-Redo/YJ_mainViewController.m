//
//  YJ_mainViewController.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/15.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_mainViewController.h"
#import "YJ_LoginViewController.h"
#import "YJ_SignUpViewController.h"
@interface YJ_mainViewController ()
- (IBAction)touchLoginBtn;
- (IBAction)touchSignUpBtn;

@end

@implementation YJ_mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)touchLoginBtn {
    
    YJ_LoginViewController *loginVC = [[YJ_LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:^{
        
    }];
    
}

- (IBAction)touchSignUpBtn {
    YJ_SignUpViewController *VC = [[YJ_SignUpViewController alloc]init];
    [self presentViewController:VC animated:YES completion:^{
        
    }];
}
@end
