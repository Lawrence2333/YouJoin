//
//  YJ_editTweetController.m
//  YouJoin
//
//  Created by MacBookPro on 15/12/18.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "YJ_editTweetController.h"
#import "YJ_userInfo.h"
#import "UIImage+SmallImage.h"
#import "NSString+GetImageOldName.h"
#import "YJ_networkTool.h"
#import "UIImage+SaveImage.h"
#import "YJ_homepageTweet.h"

@interface YJ_editTweetController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
- (IBAction)addImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) YJ_homepageTweet *tweet;
@property (nonatomic, strong) NSMutableArray *imageNameArray;
@property (nonatomic, strong) NSMutableArray *imagePathArray;

- (IBAction)touchSend:(id)sender;
- (IBAction)touchCancel:(id)sender;

@end

@implementation YJ_editTweetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageArray = [[NSMutableArray alloc]init];
    self.imageNameArray = [[NSMutableArray alloc]init];
    self.imagePathArray = [[NSMutableArray alloc]init];
    self.tweet = [[YJ_homepageTweet alloc]init];
    self.tweet.username = [[YJ_userInfo sharedInstance]username];
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.view.backgroundColor = YJ_HOMEPAGE_GRAY_COLOR;
    
    // Do any additional setup after loading the view from its nib.
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

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)touchCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)touchSend:(id)sender {
    
    [YJ_networkTool sendTweetWithUserID:[[YJ_userInfo sharedInstance]userID] tweetContent:self.textView.text tweetImgs:self.imagePathArray imgsNames:self.imageNameArray completion:^(NSString *resultStr) {
        
        if ([self respondsToSelector:@selector(YJ_editTweetDidSendTweet)]) {
            [self.delegate YJ_editTweetDidSendTweet];
        }
        
        if ([resultStr isEqualToString:@"success"]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"发送成功"
                                  message:@""
                                  delegate:nil
                                  cancelButtonTitle:@"OK!"
                                  otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            UIAlertView *alert = [[UIAlertView alloc]
                                        initWithTitle:@"发送失败"
                                        message:@"请重试！\n可能是网络原因"
                                        delegate:nil
                                        cancelButtonTitle:@"OK!"
                                        otherButtonTitles:nil];
            [alert show];

        }
        
    }];
}
- (IBAction)addImage {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"通过相机"   , @"图库获取",nil];
    
    [self.view endEditing:YES];
    
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
    UIImage *smallImage = [[UIImage alloc]imageWithImage:image scaledToSize:CGSizeMake(120, 120)];
    [self.imageArray addObject:smallImage];
//    self.userImage = self.appDelegate.userInfo.username;
    NSString *imageType = [[NSString alloc]init];
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(image)) {
        //返回为png图像。
        imageType = @"png";
    }else {
        //返回为JPEG图像。
        imageType = @"jpeg";
    }
    NSURL *original = [editingInfo valueForKey:@"UIImagePickerControllerReferenceURL"];
    NSString *imageName = [NSString stringWithFormat:@"%@.%@",[NSString imageNameWithImageURL:original],imageType];
    if(imageName == NULL){//说明是相机来的图片
        //    //获取时间戳来命名图片
            NSDate* localdate = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval adate=[localdate timeIntervalSince1970]*1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
            NSNumber *numStage =  [NSNumber numberWithDouble:adate];
            NSString *numStr = [NSString stringWithFormat:@"%0.0lf",[numStage doubleValue]];
        imageName = [NSString stringWithFormat:@"photoPickat%@",numStr];
    }
    NSLog(@"%@",imageName);
    //保存图片
    image = [[UIImage alloc]imageWithImage:image scaledToSize:CGSizeMake(64, 64)];
    NSString *imagePath = [UIImage saveImage:image WithName:[NSString stringWithFormat:@"%@%@.%@",self.tweet.username,imageName,imageType]];
    //保存图片名字和图片路径
    [self.imageNameArray addObject:imageName];
    [self.imagePathArray addObject:imagePath];
    
    //图片加入scrollView
    [self addImageInScrollView:smallImage];
    //退出pickView
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)addImageInScrollView:(UIImage *)image{
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = CGSizeMake(self.imageArray.count*60, 60);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(((self.imageArray.count-1)*60), 0, 60, 60)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:imageView];
}
@end
