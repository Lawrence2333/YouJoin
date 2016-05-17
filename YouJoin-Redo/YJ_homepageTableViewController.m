//
//  YJ_homepageTableViewController.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/3/23.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_homepageTableViewController.h"
#import "YJ_homepageTweetsCell.h"
#import "YJ_userInfo.h"
#import "YJ_homepageTweet.h"
#import "YJ_homepageTweetFrame.h"
#import "YJ_networkTool.h"
#import "YJ_JSONSerialization.h"
#import "NSString+Json.h"
#import "RequestPostUploadHelper.h"
#import "YJ_userDetailInfo.h"
#import "YJ_userInfoPageController.h"
#import "UIImage+SmallImage.h"
#import "YJ_editTweetController.h"
#import "NSString+CutLastChar.h"
#import "UIImage+Circle.h"
#import "UIImageView+WebCache.h"

@interface YJ_homepageTableViewController ()<UITableViewDelegate,UITableViewDataSource,YJ_editTweetSendDelegate>

/**
 *  存放所有cell的frame模型数据
 */
@property (nonatomic, strong) NSMutableArray *tweetsFrames;

@end

@implementation YJ_homepageTableViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [self setNeedsStatusBarAppearanceUpdate];

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBarTintColor:YJ_NAVIGATIONBAR_COLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:YJ_NAVIGATIONBAR_TITLE_ATTRS];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //左上角用户图片/第一次操作
    UIButton *leftHeadBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 52-INSERT, 33)];
    
    [leftHeadBtn setImage:[UIImage circleImage:[[UIImage alloc]imageWithImage:[UIImage imageNamed:@"logo2"] scaledToSize:CGSizeMake(30, 30)] borderWidth:2.0 borderColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]] forState:UIControlStateNormal];
    [YJ_networkTool getUserDetailInfo:[[YJ_userInfo sharedInstance]userID] type:YJ_chooseUserTypeUserID completion:^(YJ_userDetailInfo *receivedUserDetailInfo) {
         [leftHeadBtn.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString fixStringByCutLastChar:receivedUserDetailInfo.userImage]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
             if (image!=nil) {
                 [leftHeadBtn setImage:[UIImage circleImage:[[UIImage alloc]imageWithImage:image scaledToSize:CGSizeMake(30, 30)] borderWidth:2.0 borderColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]] forState:UIControlStateNormal];
             }else
             {
                 [leftHeadBtn setImage:[UIImage circleImage:[[UIImage alloc]imageWithImage:[UIImage imageNamed:@"logo2"] scaledToSize:CGSizeMake(30, 30)] borderWidth:2.0 borderColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]] forState:UIControlStateNormal];
             }
         }];
    }];
   
    
    leftHeadBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -INSERT, 0, 0);
    UIBarButtonItem *backItemLeft = [[UIBarButtonItem alloc] initWithCustomView:leftHeadBtn];
    self.navigationItem.leftBarButtonItem = backItemLeft;
    [leftHeadBtn addTarget:self action:@selector(touchLeftHeadBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(touchRightHeadBtn)];
    
    [self setupRefresh];
    NSLog(@"%@",[self class]);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)touchLeftHeadBtn{
    
    YJ_userInfoPageController *userInfoPageVC = [[YJ_userInfoPageController alloc]initWithUserID:[[YJ_userInfo sharedInstance]userID]];
    [self.navigationController pushViewController:userInfoPageVC animated:YES];
    
}

-(void)touchRightHeadBtn{
    
    YJ_editTweetController *editVC = [[YJ_editTweetController alloc]init];
    [self.navigationController pushViewController:editVC animated:YES];
    
}

#pragma mark - YJ_editTweetControllerDelegate
-(void)YJ_editTweetDidSendTweet{
    
    [self setupRefresh];
    
}

#pragma mark - 状态栏
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//tableViewCell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetsFrames.count;
}

//tableViewCell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.tweetsFrames[self.tweetsFrames.count - indexPath.row - 1] cellHeight];
}

#pragma mark - 懒加载tweetsFrame
-(NSMutableArray *)tweetsFrames{
    
    if (_tweetsFrames == nil) {
        // 初始化
        // 1.获得plist的全路径
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"tweetsOf%@.plist",[[YJ_userInfo sharedInstance]username]]];
        
        // 2.加载数组
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:filename];
        
        //如果不存在就重新生成并保存
        if (dictArray == nil) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:filename contents:nil attributes:nil];
        }
        
        // 3.将dictArray里面的所有字典转成模型对象,放到新的数组中
        NSMutableArray *tweetsFrameArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            // 3.1.创建YJ_Tweets模型对象
            YJ_homepageTweet *tweets = [YJ_homepageTweet tweetsWithDict:dict];
            
            // 3.2.创建YJ_TweetsFrame模型对象
            YJ_homepageTweetFrame *tweetsFrame = [[YJ_homepageTweetFrame alloc] init];
            tweetsFrame.tweets = tweets;
            
            // 3.2.添加模型对象到数组中
            [tweetsFrameArray addObject:tweetsFrame];
            
        }
        // 4.赋值
        _tweetsFrames = tweetsFrameArray;
    }
    return _tweetsFrames;
}

#pragma mark - cell加载
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //创建cell
    YJ_homepageTweetsCell *cell = [YJ_homepageTweetsCell cellWithTableView:tableView];
    
    //倒序传模型给cell
    cell.tweetsFrame = self.tweetsFrames[self.tweetsFrames.count - indexPath.row - 1];
    
    //设置为无法表示选择样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - 下拉刷新
-(void)setupRefresh{
    
    //添加下拉刷新
    UIRefreshControl *downRefreshControl = [[UIRefreshControl alloc]init];
    [downRefreshControl addTarget:self action:@selector(refreshNewData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:downRefreshControl];
    
    //马上进入刷新状态，并不会触发UIControlEventValueChanged事件
    [downRefreshControl beginRefreshing];
    
    //加载数据
    [self refreshNewData:downRefreshControl];
    
}

#pragma mark - 加载新数据
-(void)refreshNewData:(UIRefreshControl *)control{
    
    //设置请求属性
    NSString *tweetID = [[NSString alloc]init];
    if (self.tweetsFrames.count) tweetID = ((YJ_homepageTweetFrame *)(self.tweetsFrames.lastObject)).tweets.tweetID;
    else tweetID = @"0";
    NSString *userID = [[YJ_userInfo sharedInstance]userID];
    
    [YJ_networkTool getTweetsWithTweetID:tweetID userID:userID time:@"1" completion:^(NSArray *receivedArray, NSString *resultStr) {
        if ([resultStr isEqualToString:@"failure"]) {
            return ;
        }
        //新的数据数组
        NSMutableArray *newTweetArray = [NSMutableArray array];
        for (NSDictionary *tweetDict in receivedArray) {
                //加载数据
            YJ_homepageTweet *homepageTweet = [[YJ_homepageTweet alloc]initWithReceivedDict:tweetDict];
                //加载模型
            YJ_homepageTweetFrame *tweetFrame = [[YJ_homepageTweetFrame alloc]init];
                            tweetFrame.tweets = homepageTweet;
                //添加模型
            [newTweetArray addObject:tweetFrame];
        }
        // 3.将dictArray里面的所有字典转成模型对象,放到新的数组中
        [self.tweetsFrames addObjectsFromArray:newTweetArray];
        [self.tableView reloadData];
        
//        // 获得plist的全路径
//        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
//        NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"tweetsOf%@.plist",[[YJ_userInfo sharedInstance]username]]];
//        //写入文件
//        [self.tweetsFrames writeToFile:filename atomically:YES];
        
    }];
    
    [control endRefreshing];
}


//-(void)refreshData:(UIRefreshControl *)control{
//    
//    //设置url
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[[NSURL alloc]initWithString:GET_TWEETS_URL]];
//    
//    request.HTTPBody = [[NSString stringWithFormat:@"tweet_id=%s&user_id=%@&time=%d","0",self.appdelegate.userInfo.userID,1]dataUsingEncoding:NSUTF8StringEncoding];
//    request.HTTPMethod = @"POST";
//    
//    //获取数据
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        /**收到的字典集
//         * 格式为：
//         * NSString * result
//         * NSArray * receivedTweetsArray
//         *
//         */
//        NSDictionary *receivedDict = [YJ_JSONSerialization dictWithDataWithArray:data];
//        if ([[receivedDict valueForKey:@"result"]isEqualToString:@"failure"]) {
//            return ;
//        }
//        
//        NSMutableArray *dictArray = [[NSMutableArray alloc]init];
//        
//        for (YJ_ReceivedTweet * receivedTweet in [YJ_ReceivedTweets receivedTweetsArrayWithDict:receivedDict].receivedTweetsArray) {
//            
//            [dictArray  addObject:[YJ_ReceivedTweet tweetsDictWithReceivedTweet:receivedTweet]];
//        }
//        
//        NSMutableArray *tweetsFrameArray = [NSMutableArray array];
//        for (NSDictionary *dict in dictArray) {
//            // 创建YJ_Tweets模型对象
//            YJ_Tweets *tweets = [YJ_Tweets tweetsWithDict:dict];
//            
//            // 创建YJ_TweetsFrame模型对象
//            YJ_TweetsFrame *tweetsFrame = [[YJ_TweetsFrame alloc] init];
//            tweetsFrame.tweets = tweets;
//            
//            // 添加模型对象到数组中
//            [tweetsFrameArray addObject:tweetsFrame];
//        }
//        
//        [self.tweetsFrames addObjectsFromArray:tweetsFrameArray];
//        
//        [self.tableView reloadData];
//        
//        //        // 3.将dictArray里面的所有字典转成模型对象,放到新的数组中
//    }];
//    
//    [control endRefreshing];
//}

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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
