//
//  YJ_chattingViewController.m
//  YouJoin
//
//  Created by Lawrence on 15/12/31.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "YJ_chattingViewController.h"
#import "YJ_messages.h"
#import "YJ_messagesFrame.h"
#import "YJ_friend.h"
#import "YJ_networkTool.h"
#import "YJ_userInfo.h"
#import "YJ_chattingMessagesCell.h"
#import "YJ_JSONSerialization.h"
#import "MBProgressHUD+MJ.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface YJ_chattingViewController () <UITableViewDataSource, UITableViewDelegate, UITableViewDelegate, UITextFieldDelegate,AVIMClientDelegate>
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIView *editView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UITextField *inputView;

//@property (nonatomic, strong) NSDictionary *autoreply;
@property (nonatomic, strong) NSMutableArray *messageFrames;

@property(nonatomic,strong) AVIMConversation *conversation;


@property(nonatomic,strong) AVIMClient *client;

- (void)touchSendBtn;
- (void)touchBackBtn;

@end

@implementation YJ_chattingViewController

-(void)loadView{
    [super loadView];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    //tableView
    UITableView *tableView = [[UITableView alloc]init];
    tableView.frame = CGRectMake(self.view.frame.origin.x, 64 , self.view.frame.size.width, self.view.frame.size.height-64-44);
//    tableView.backgroundView.alpha = 0.0;
    self.tableView = tableView;
//    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    self.tableView.backgroundColor = YJ_HOMEPAGE_GRAY_COLOR;
    
    //navigationView
    UIView *navigation = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigation.backgroundColor = YJ_NAVIGATIONBAR_COLOR;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 33, 11, 18)];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [backBtn setImage:[UIImage imageNamed:@"chat_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(touchBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:backBtn];
    
    UILabel *nickname = [[UILabel alloc]initWithFrame:CGRectMake(60, 32, 200, 21)];
    nickname.textAlignment = NSTextAlignmentCenter;
    nickname.textColor = [UIColor whiteColor];
    nickname.text = self.friendInfo.friendNickname;
    self.nameLabel = nickname;
    [navigation addSubview:nickname];
    
    [self.view addSubview:navigation];
    
    //编辑栏
    UIView *editView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tableView.frame), self.view.frame.size.width, 44)];
    editView.backgroundColor = [UIColor whiteColor];
    
    UITextField *inputView = [[UITextField alloc]initWithFrame:CGRectMake(8, 7, 266, 30)];
    inputView.textInputView.backgroundColor = [UIColor whiteColor];
    self.inputView = inputView;
    [editView addSubview: inputView];

    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(282, 7, 30, 30)];
    [sendBtn setImage:[UIImage imageNamed:@"chat_send"] forState:UIControlStateNormal];
    sendBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [sendBtn addTarget:self action:@selector(touchSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:sendBtn];
    self.editView = editView;
    [self.view addSubview:editView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"－－－－－－chattingViewController show");
    
    self.client = [[AVIMClient alloc]initWithClientId:[[YJ_userInfo sharedInstance]username]];
    self.client.delegate = self;
    [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
        if (self.oldConversationID!=nil) {
            self.conversation = [self.client conversationForId:self.oldConversationID];
            
            for (AVIMTypedMessage *message in self.unReadMessages) {
                
                if (message.mediaType == kAVIMMessageMediaTypeText) {
                    [self addMessage:message.text type:YJ_MessageTypeOther];
                }
            }
            
        }
        
        else{
            [self.client createConversationWithName:[NSString stringWithFormat:@"%@",self.friendInfo.friendNickname] clientIds:@[self.friendInfo.friendUsername] attributes:nil options:AVIMConversationOptionUnique callback:^(AVIMConversation *conversation, NSError *error) {
           self.conversation = conversation;
            }];
        }
    }];
    
    // 1.表格的设置
    // 去除分割线

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO; // 不允许选中
    self.tableView.delegate = self;
    
    // 2.监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 3.设置文本框左边显示的view
    self.inputView.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    // 永远显示
    self.inputView.leftViewMode = UITextFieldViewModeAlways;
    self.inputView.delegate = self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  发送一条消息
 */
- (void)addMessage:(NSString *)text type:(YJ_MessageType)type
{
    // 1.数据模型
    YJ_messages *msg = [[YJ_messages alloc] init];
    msg.type = type;
    msg.text = text;
    // 设置数据模型的时间
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    // NSDate  --->  NSString
    // NSString ---> NSDate
    //    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //  2014-08-09 15:45:56
    // 09/08/2014  15:45:56
    msg.time = [fmt stringFromDate:now];
    
    // 看是否需要隐藏时间
    YJ_messagesFrame *lastMf = [self.messageFrames lastObject];
    YJ_messages *lastMsg = lastMf.message;
    msg.hideTime = [msg.time isEqualToString:lastMsg.time];
    
    // 2.frame模型
    YJ_messagesFrame *mf = [[YJ_messagesFrame alloc] init];
    mf.message = msg;
    [self.messageFrames addObject:mf];
    
    // 3.刷新表格
    [self.tableView reloadData];
    
    // 4.自动滚动表格到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.messageFrames.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

///**
// *  根据自己发的内容取得自动回复的内容
// *
// *  @param text 自己发的内容
// */
//- (NSString *)replayWithText:(NSString *)text
//{
//    for (int i = 0; i<text.length; i++) {
//        NSString *word = [text substringWithRange:NSMakeRange(i, 1)];
//        
//        if (self.autoreply[word]) return self.autoreply[word];
//    }
//    
//    return @"滚蛋";
//}

#pragma mark - 文本框代理
/**
 *  点击了return按钮(键盘最右下角的按钮)就会调用
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    // 1.自己发一条消息/到自己的列表显示
//    [self addMessage:textField.text type:YJ_MessageTypeMe];

    [self.conversation sendMessage:[AVIMTextMessage messageWithText:textField.text attributes:nil] callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //加入聊天记录中
            [self addMessage:textField.text type:YJ_MessageTypeMe];
            //打印
            NSLog(@"message : %@ ------ is send",textField.text);
            //清空文字
            self.inputView.text = nil;
        }
        else [MBProgressHUD showError:@"发送失败,未知错误"];
    }];
/*
    [YJ_networkTool sendMessagesWithUsername:[[YJ_userInfo sharedInstance]username] friendInfo:self.friendInfo messageContent:textField.text completion:^(NSString *resultStr) {
        //发送成功：
        if ([resultStr isEqualToString:@"success"]) {
            //加入聊天记录中
            [self addMessage:textField.text type:YJ_MessageTypeMe];
            //打印
            NSLog(@"message : %@ ------ is send",textField.text);
            //清空文字
            self.inputView.text = nil;
        }
        else{
            [MBProgressHUD showError:@"发送失败,未知错误"];
        }

    }];
 */
    // 返回YES即可
    return YES;
}

/**
 *  当键盘改变了frame(位置和尺寸)的时候调用
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 设置窗口的颜色
    self.view.window.backgroundColor = self.tableView.backgroundColor;
    
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0, transformY);
        self.editView.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

- (NSMutableArray *)messageFrames
{
    if (_messageFrames == nil) {

        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@to%@messages.plist",[[YJ_userInfo sharedInstance]userID],self.friendInfo.friendID]];   //获取路径

        NSArray *dictArray = [NSArray arrayWithContentsOfFile:filename];
        
        if (dictArray == nil) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:filename contents:nil attributes:nil];
        }
        
        NSMutableArray *mfArray = [NSMutableArray array];
            
        for (NSDictionary *dict in dictArray) {
            // 消息模型
            YJ_messages *msg = [YJ_messages messageWithDict:dict];
            
            // 取出上一个模型
            YJ_messagesFrame *lastMf = [mfArray lastObject];
            YJ_messages *lastMsg = lastMf.message;
            
            // 判断两个消息的时间是否一致
            msg.hideTime = [msg.time isEqualToString:lastMsg.time];
            
            // frame模型
            YJ_messagesFrame *mf = [[YJ_messagesFrame alloc] init];
            mf.message = msg;
                
            // 添加模型
            [mfArray addObject:mf];
        }
        
        _messageFrames = mfArray;
    }
    return _messageFrames;
}

- (void)touchSendBtn {
    [self textFieldShouldReturn:self.inputView];
}

- (void)touchBackBtn {
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@to%@messages.plist",[[YJ_userInfo sharedInstance]userID],self.friendInfo.friendID]];   //获取路径
    NSLog(@"%@",filename);
    NSMutableArray *messageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.messageFrames.count; i++) {
        [messageArray addObject:((YJ_messagesFrame*)self.messageFrames[i]).message];
    }
    NSMutableArray *finalArray = [[NSMutableArray alloc]init];
    for (YJ_messages *dict in messageArray) {
        NSMutableDictionary *muDict = [[NSMutableDictionary alloc]init];
        muDict[@"text"] = dict.text;
        muDict[@"time"] = dict.time;
        if (dict.type == YJ_MessageTypeMe) {
            muDict[@"type"] = [NSNumber numberWithInt:0];
        }else muDict[@"type"] = [NSNumber numberWithInt:1];
        [finalArray addObject:muDict];
    }
    [finalArray writeToFile:filename atomically:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - YJ_friendListView代理方法
-(void)YJ_friendListPassFriendInfo:(YJ_friend *)friendInfo{
    self.friendInfo = friendInfo;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    YJ_chattingMessagesCell *cell = [YJ_chattingMessagesCell cellWithTableView:tableView];
    
    // 2.给cell传递模型
    cell.messagesFrame = self.messageFrames[indexPath.row];
    
    // 3.返回cell
    return cell;
}

#pragma mark - tableView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YJ_messagesFrame *mf = self.messageFrames[indexPath.row];
    return mf.cellHeight;
}

#pragma mark - AVIMClientDelegate
-(void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    
    NSLog(@"didReceiveTypedMessage-------------");
    if (message.mediaType == kAVIMMessageMediaTypeText) {
        [self addMessage:message.text type:YJ_MessageTypeOther];
    }
    
}

/**
 *  当开始拖拽表格的时候就会调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 退出键盘
    [self.view endEditing:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

@end

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}
//
///*
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}
//*/
//
///*
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/
//
///*
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}
//*/
//
///*
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
//}
//*/
//
///*
//// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}
//*/
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
