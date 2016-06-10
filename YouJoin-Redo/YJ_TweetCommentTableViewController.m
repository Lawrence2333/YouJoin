//
//  YJ_TweetCommentTableViewController.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/6/8.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_TweetCommentTableViewController.h"
#import "YJ_View.h"
#import "YJ_userInfo.h"
#import "YJ_homepageTweet.h"
#import "UIImageView+WebCache.h"
#import "YJ_homepageTweetCommentCell.h"
#import "YJ_homepageTweetComment.h"
#import "YJ_networkTool.h"

@interface YJ_TweetCommentTableViewController ()

@property (nonatomic,weak) UITextField *inputField;
@property (nonatomic,weak) UIButton *upvoteBtn;

@end

@implementation YJ_TweetCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    CGFloat bigPadding = 20;
    CGFloat smallPadding = 10;
    
    self.tabBarController.tabBar.hidden = YES;
    
    //0.设置tweet的view
    YJ_View *tweetView = [[YJ_View alloc]init];
    
    //1.设置头像 等的view
    YJ_View *titleView = [[YJ_View alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
    titleView.backgroundColor = [UIColor whiteColor];
    //1.1 头像
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    iconView.image = self.tweet.iconpic;
    [titleView addSubview:iconView];
    
    //1.2 用户名
    CGSize nameSize = [self sizeWithText:self.tweet.username font:YJ_SMALLTEXT_FONT maxSize:CGSizeMake(titleView.frame.size.width-60, 20)];
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, nameSize.width,nameSize.height)];
    nameLabel.font = YJ_SMALLTEXT_FONT;
    nameLabel.alpha = 0.5;
    nameLabel.text = self.tweet.username;
    [titleView addSubview:nameLabel];
    
    //1.3 时间
    CGSize timeSize = [self sizeWithText:self.tweet.timer font:YJ_SMALLTEXT_FONT maxSize:CGSizeMake(titleView.frame.size.width-60, 20)];
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 30, timeSize.width,timeSize.height)];
    timeLabel.font = YJ_SMALLTEXT_FONT;
    timeLabel.alpha = 0.5;
    timeLabel.text = self.tweet.timer;
    [titleView addSubview:timeLabel];
    
    [tweetView addSubview:titleView];
    
    //2.设置内容的view
    YJ_View *contentView = [[YJ_View alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    //2.1 设置文字的view
    CGSize textSize = [self sizeWithText:self.tweet.textContent font:YJ_SMALLTEXT_FONT maxSize:CGSizeMake(240, MAXFLOAT)];
    UILabel *contentText = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, textSize.width, textSize.height)];
    contentText.text = self.tweet.textContent;
    contentText.numberOfLines = 0;
    contentText.font = YJ_SMALLTEXT_FONT;
    contentText.alpha = 0.7;
    [contentView addSubview:contentText];
    
    CGFloat pictureViewHeight = 0;
    
    //2.2设置图片的view
    if(self.tweet.picsUrl){
        for (int i = 0; i<self.tweet.picsUrl.count; i++) {
            
            CGFloat row = i/3;
            CGFloat column = i%3;
            CGFloat picturePadding = 10;
            CGFloat pictureBoardPadding = 15;
            CGFloat pictureW = 80;
            CGFloat pictureH = 80;
            CGFloat pictureX = 40 + column * (pictureW + picturePadding) + pictureBoardPadding;
            CGFloat pictureY = row * (pictureH + picturePadding) + CGRectGetMaxY(contentText.frame) + bigPadding;
            
            UIImageView *tweetImage = [[UIImageView alloc]initWithFrame:CGRectMake(pictureX, pictureY, pictureW, pictureH)];
            
            [tweetImage sd_setImageWithURL:[NSURL URLWithString: self.tweet.picsUrl[i]]];
            [contentView addSubview:tweetImage];
             if (i == self.tweet.picsUrl.count-1) {
                pictureViewHeight = CGRectGetMaxY(tweetImage.frame);
            }
        }
    }
    
    //2.3设置点赞按钮
    UIButton *upVoteBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-bigPadding-36-24, pictureViewHeight+5+smallPadding, 36, 24)];
    [upVoteBtn setImage:[UIImage imageNamed:@"upVote"] forState:UIControlStateNormal];
    [upVoteBtn addTarget:self action:@selector(touchUpVoteBtn) forControlEvents:UIControlEventTouchUpInside];
    self.upvoteBtn = upVoteBtn;
    
    //2.4设置评论按钮
    UIButton *commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-smallPadding-24, pictureViewHeight+5+smallPadding, 24, 24)];
    [commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(touchSendBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //2.5设置评论field
    UITextField *inputField = [[UITextField alloc]initWithFrame:CGRectMake(smallPadding, pictureViewHeight+5+smallPadding, self.view.frame.size.width-2*smallPadding-60, 24)];
    inputField.placeholder = @"请在此输入评论";
    inputField.font = YJ_SMALLTEXT_FONT;
    inputField.textColor = [UIColor blackColor];
    self.inputField = inputField;
    
    [contentView addSubview:upVoteBtn];
    [contentView addSubview:commentBtn];
    [contentView addSubview:inputField];
    
    [tweetView addSubview:contentView];

    contentView.frame = CGRectMake(0, titleView.frame.size.height, self.view.frame.size.width, pictureViewHeight+smallPadding+bigPadding*2);

    tweetView.frame = CGRectMake(0, 0, self.view.frame.size.width, CGRectGetMaxY(contentView.frame)+3);
    tweetView.backgroundColor = YJ_HOMEPAGE_GRAY_COLOR;

    //3
    self.tableView.tableHeaderView = tweetView;
    
    //评论设置
    self.comments = [NSArray array];
    
    [self refreshCommentList];
    [self refreshUpvoteState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 加载comment数组
-(void)refreshCommentList{
    //获取comments
    [YJ_networkTool getTweetCommentWithTweetID:self.tweet.tweetID completion:^(NSString *resultStr, NSArray *receicedCommentsDictArray) {
        
        if ([resultStr isEqualToString:@"success"]) {
            
            NSMutableArray *commentArray = [NSMutableArray array];
            
            for (NSDictionary *dict in receicedCommentsDictArray) {
                
                YJ_homepageTweetComment *comment = [YJ_homepageTweetComment commentWithDict:dict];
                
                [commentArray addObject:comment];
            }
            
            self.comments = commentArray;
            
            [self.tableView reloadData];
        }
        
    }];

}

#pragma mark - 判断点赞情况
-(void)refreshUpvoteState{
    
    [YJ_networkTool isUpvoteTweetWithUserID:[[YJ_userInfo sharedInstance]userID] tweetID:self.tweet.tweetID completion:^(NSString *resultStr) {
        if ([resultStr isEqualToString:@"success"]) {
            [self.upvoteBtn setImage:[UIImage imageNamed:@"isUpvote"] forState:UIControlStateNormal];
        }
        else{
            [self.upvoteBtn setImage:[UIImage imageNamed:@"upVote"] forState:UIControlStateNormal];
        }
    }];
}

- (void)touchSendBtn {
    
    [YJ_networkTool sendTweetCommentWithUserID:[[YJ_userInfo sharedInstance]userID] tweetID:self.tweet.tweetID commentContent:self.inputField.text completion:^(NSString *resultStr) {
        if ([resultStr isEqualToString:@"success"]) {
            [self.view endEditing:YES];
            self.inputField.text = nil;
            [self refreshCommentList];
            
            NSLog(@"%@------------sendTweetComment--success",self.class);
        }
    }];
}

- (void)touchUpVoteBtn{
    
    [YJ_networkTool upvoteTweetWithUserID:[[YJ_userInfo sharedInstance]userID] tweetID:self.tweet.tweetID completion:^(NSString *resultStr) {
        if ([resultStr isEqualToString:@"success"]) {
             NSLog(@"%@------------upvoteTweet--success",self.class);
            
            [self refreshUpvoteState];
        }
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YJ_homepageTweetCommentCell *cell = [YJ_homepageTweetCommentCell cellWithTableView:tableView];
    cell.comment = self.comments[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return ((YJ_homepageTweetComment *)self.comments[indexPath.row]).cellHeight;
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:NULL].size;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
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
