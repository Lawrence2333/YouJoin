//
//  YJ_homepageLeftListController.m
//  YouJoin
//
//  Created by MacBookPro on 15/11/25.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "YJ_homepageLeftListController.h"
#import "YJ_homepageLeftListCellView.h"
#import "YJ_userInfo.h"
#import "UIImage+Circle.h"
#import "YJ_userDetailInfo.h"
#import "UIImage+SaveImage.h"
#import "UIImage+SmallImage.h"
#import "NSString+CutLastChar.h"
#import "UIImage+Extension.h"
#import "UIImageView+WebCache.h"
#import "YJ_JSONSerialization.h"
#import "RequestPostUploadHelper.h"
#import "YJ_networkTool.h"

@interface YJ_homepageLeftListController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property(nonatomic,weak) UIButton *iconView;

@property(nonatomic,copy) NSString * userImage;

@property(nonatomic,strong) YJ_homepageLeftListCellView *username;
@property(nonatomic,strong) YJ_homepageLeftListCellView *userNickname;
@property(nonatomic,strong) YJ_homepageLeftListCellView *userEmail;
@property(nonatomic,strong) YJ_homepageLeftListCellView *userSex;
@property(nonatomic,strong) YJ_homepageLeftListCellView *userSign;
@property(nonatomic,strong) YJ_homepageLeftListCellView *userLocation;
@property(nonatomic,strong) YJ_homepageLeftListCellView *userBirthday;
@property(nonatomic,strong) YJ_homepageLeftListCellView *userWork;
@end

@implementation YJ_homepageLeftListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:YJ_NAVIGATIONBAR_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:YJ_NAVIGATIONBAR_TITLE_ATTRS];
    
    //backgroundImage setting
    UIImageView *backgroundImage = [[UIImageView alloc]init];
    backgroundImage.backgroundColor = YJ_HOMEPAGE_GRAY_COLOR;
    backgroundImage.frame = self.view.frame;
    
    [self.view addSubview:backgroundImage];
    
    //scollView setting
    UIScrollView *scollView = [[UIScrollView alloc]init];
    scollView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height);
    
    int padding = 0;
    
    //头像view
    CGFloat iconW = 80;
    CGFloat iconH = iconW;
    CGFloat iconX = self.view.frame.size.width/2-iconW/2;
    CGFloat iconY = 20;
    UIButton *iconView = [[UIButton alloc]initWithFrame:CGRectMake(iconX, iconY, iconW, iconH)];
    self.iconView = iconView;
    iconView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(touchSave)];
    
    self.userImage = [[YJ_userInfo sharedInstance]username];
    
    [iconView.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString fixStringByCutLastChar: self.userDetailInfo.userImage]] placeholderImage:[UIImage imageNamed:@"logo2"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image!=nil) {
            
             [iconView setImage:[UIImage circleImage:[[UIImage alloc]imageWithImage:image scaledToSize:CGSizeMake(80, 80)] borderWidth:2.0 borderColor:YJ_CIRCLE_BORDER_COLOR] forState:UIControlStateNormal];
        }
        else{
            [iconView setImage:[UIImage circleImage:[UIImage imageNamed:@"logo2"] borderWidth:1.0 borderColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        }
       
    }];
    

    [iconView addTarget:self action:@selector(pickImage:) forControlEvents:UIControlEventTouchUpInside];
    
    [scollView addSubview:iconView];
    
    //用户名
    YJ_homepageLeftListCellView *username = [YJ_homepageLeftListCellView initWithTitle:@"name" andY:CGRectGetMaxY(iconView.frame)+padding+20 andTextfieldText:self.userDetailInfo.username];
    self.username = username;
    [scollView addSubview:username];
    
    //用户昵称
    YJ_homepageLeftListCellView *userNickname = [YJ_homepageLeftListCellView initWithTitle:@"nick name" andY:CGRectGetMaxY(username.frame)+padding+20 andTextfieldText:self.userDetailInfo.userNickname];
    self.userNickname = userNickname;
    [scollView addSubview:userNickname];
    
    //用户地址
    YJ_homepageLeftListCellView *userLocation = [YJ_homepageLeftListCellView initWithTitle:@"location" andY:CGRectGetMaxY(userNickname.frame)+padding andTextfieldText:self.userDetailInfo.userLocation];
    self.userLocation = userLocation;
    [scollView addSubview:userLocation];
    
    //用户工作
    YJ_homepageLeftListCellView *userWork = [YJ_homepageLeftListCellView initWithTitle:@"work" andY:CGRectGetMaxY(userLocation.frame)+padding andTextfieldText:self.userDetailInfo.userWork];
    self.userWork = userWork;
    [scollView addSubview:userWork];
    
    //用户生日
    YJ_homepageLeftListCellView *userBirth = [YJ_homepageLeftListCellView initWithTitle:@"birthday" andY:CGRectGetMaxY(userWork.frame)+padding andTextfieldText:self.userDetailInfo.userBirth];
    self.userBirthday = userBirth;
    [scollView addSubview:userBirth];
    
    //用户性别
    YJ_homepageLeftListCellView *userSex = [YJ_homepageLeftListCellView initWithTitle:@"sex" andY:CGRectGetMaxY(userBirth.frame)+padding andTextfieldText:self.userDetailInfo.userSex];
    self.userSex = userSex;
    [scollView addSubview:userSex];
    
    //用户email
    YJ_homepageLeftListCellView *userEmail = [YJ_homepageLeftListCellView initWithTitle:@"E-mail" andY:CGRectGetMaxY(userSex.frame)+padding andTextfieldText:self.userDetailInfo.userEmail];
    self.userEmail = userEmail;
    [scollView addSubview:userEmail];
    
    //用户个性签名
    YJ_homepageLeftListCellView *userSign = [YJ_homepageLeftListCellView initWithTitle:@"Sign" andY:CGRectGetMaxY(userEmail.frame)+padding andTextfieldText:self.userDetailInfo.userSign];
    self.userSign = userSign;
    [scollView addSubview:userSign];
    
    scollView.contentSize = CGSizeMake(320, CGRectGetMaxY(userSign.frame)+300);
    
    [self.view addSubview:scollView];
    // Do any additional setup after loading the view from its nib.
}

- (void)touchSave {
    
    self.userDetailInfo.userID = self.userDetailInfo.userID;
    self.userDetailInfo.username = self.userDetailInfo.username;
    self.userDetailInfo.userSex = self.userDetailInfo.userSex;
    self.userDetailInfo.userEmail = self.userEmail.myTextfield.text;
    self.userDetailInfo.userWork = self.userWork.myTextfield.text;
    self.userDetailInfo.userNickname = self.userNickname.myTextfield.text;
    self.userDetailInfo.userBirth = self.userBirthday.myTextfield.text;
    self.userDetailInfo.userSign = self.userSign.myTextfield.text;
    self.userDetailInfo.userLocation = self.userLocation.myTextfield.text;
    self.userDetailInfo.userFocusNum = self.userDetailInfo.userFocusNum;
    self.userDetailInfo.userFollowNum = self.userDetailInfo.userFollowNum;
//    self.userDetailInfo.result = self.userDetailInfo.result;
    
    self.userDetailInfo.userImage = self.userImage;
//    
//    YJ_userInfo *test = self.myUserInfo;
    
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString* documentPath = @"/Users/MAC/Desktop/";
    NSString* avatarPath = [documentPath stringByAppendingPathComponent:self.userDetailInfo.userImage];
    
    NSString *resultString = [RequestPostUploadHelper postRequestWithURL:UPDATE_USERINFO_URL postParems:[self.userDetailInfo dictFromUserInfo] picFilePath:avatarPath picFileName:self.userDetailInfo.userImage];
    
    [YJ_networkTool updateUserDetailInfo:self.userDetailInfo picFilePath: avatarPath picFileName:self.userDetailInfo.userImage completion:^(NSString *resultStr) {
        NSLog(@"updateUserDetailInfo-----------resultStr = %@",resultStr);
    }];
    
    NSDictionary *dict = [YJ_JSONSerialization JSONObjectWithDataUsingFix:[resultString dataUsingEncoding:NSUTF8StringEncoding] options:1 error:NULL];
    
    if ([[dict valueForKey:@"result"]isEqualToString:@"success"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"设置成功" message:@"资料卡设置成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"设置失败" message:@"请稍后重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

-(void)pickImage:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"通过相机"   , @"图库获取",nil];
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self selectForCameraButtonClick];
    }
    if (buttonIndex == 1) {
        [self selectForAlbumButtonClick];
    }
    else ;
    
}
#pragma mark 从用户相册获取活动图片
//访问相册
-(void)selectForAlbumButtonClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"访问图片库错误"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
    }
}
//访问摄像头
-(void)selectForCameraButtonClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"不可使用摄像功能"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
    }
}
#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    image = [[UIImage alloc]imageWithImage:image scaledToSize:CGSizeMake(80, 80)];
    self.userImage = self.userDetailInfo.username;
    [UIImage saveImage:image WithName:self.userImage];
    [self.iconView setImage:[UIImage circleImage:image borderWidth:2.0 borderColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]] forState:UIControlStateNormal]; //imageView为自己定义的UIImageView
    
    [picker dismissModalViewControllerAnimated:YES];
    
}

@end
