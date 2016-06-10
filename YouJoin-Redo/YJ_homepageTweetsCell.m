//
//  YJ_homepageTweetsCell.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/3/24.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_homepageTweetsCell.h"
#import "UIImage+SmallImage.h"
#import "YJ_homepageTweet.h"
#import "YJ_homepageTweetFrame.h"
#import "UIImage+Circle.h"
#import "UIImageView+WebCache.h"
#import "NSString+CutLastChar.h"

@interface YJ_homepageTweetsCell()

//头像
 @property (nonatomic, weak) UIImageView *iconPicView;
//昵称
@property (nonatomic, weak) UILabel *usernameView;
//时间
@property (nonatomic, weak) UILabel *timerView;
//正文
@property (nonatomic, weak) UILabel *textContentView;
//多配图
@property (nonatomic, strong) NSArray *picturesViews;
//评论数量
@property (nonatomic, weak) UIButton *commentCountView;
//点赞数量
@property (nonatomic, weak) UIButton *upVoteCountView;
//cell间隔
@property (nonatomic, weak) UIView *cellPaddingView;
////评论栏
//@property (nonatomic, weak) UIView *commentView;
//内容部分view
@property (nonatomic, weak) UIView *mycontentView;

@end


@implementation YJ_homepageTweetsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 分隔栏
        UIView *cellPaddingView = [[UIView alloc]init];
        cellPaddingView.backgroundColor = YJ_LIGHT_GRAY_COLOR01;
        [self.contentView addSubview:cellPaddingView];
        self.cellPaddingView = cellPaddingView;
        
        //内容栏
        UIView *mycontentView = [[UIView alloc]init];
        mycontentView.backgroundColor = [UIColor whiteColor];
        [self.cellPaddingView addSubview:mycontentView];
        self.mycontentView = mycontentView;
        
        //点赞数量
        UIButton *upVoteCountView = [[UIButton alloc]init];
        upVoteCountView.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [upVoteCountView setImage:[UIImage imageNamed:@"UpvoteCount01"] forState:UIControlStateNormal];
        upVoteCountView.enabled = YES;
        upVoteCountView.titleLabel.font = [UIFont systemFontOfSize:10];
        [upVoteCountView setTitleColor:[UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1.0] forState:UIControlStateNormal];
        upVoteCountView.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.upVoteCountView = upVoteCountView;
        [self.mycontentView addSubview:upVoteCountView];
        
        //评论数量
        UIButton *commentCountView = [[UIButton alloc]init];
        [commentCountView setImage:[UIImage imageNamed:@"CommentCount01"] forState:UIControlStateNormal];
        commentCountView.enabled = YES;
        commentCountView.titleLabel.font = [UIFont systemFontOfSize:10];
        [commentCountView setTitleColor:[UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1.0] forState:UIControlStateNormal];
        commentCountView.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.commentCountView = commentCountView;
        [self.mycontentView addSubview:commentCountView];
        
        // 1.头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.mycontentView addSubview:iconView];
        self.iconPicView = iconView;
        
        // 2.昵称
        UILabel *nameView = [[UILabel alloc] init];
        nameView.font = YJ_SMALLTEXT_FONT;
        nameView.alpha = 0.5;
        [self.mycontentView addSubview:nameView];
        self.usernameView = nameView;
        
        // 3.时间
        UILabel *timerView = [[UILabel alloc] init];
        timerView.font = YJ_SMALLTEXT_FONT;
        timerView.alpha = 0.5;
        [self.mycontentView addSubview:timerView];
        self.timerView = timerView;
        
        // 4.正文
        UILabel *textView = [[UILabel alloc] init];
        textView.numberOfLines = 0;
        textView.font = YJ_SMALLTEXT_FONT;
        textView.alpha = 0.7;
        [self.mycontentView addSubview:textView];
        self.textContentView = textView;
        
        // 5.多配图
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < 9; i++) {
            UIImageView *pictureView = [[UIImageView alloc]init];
            [self.mycontentView addSubview:pictureView];
            [array addObject:pictureView];
        }
        self.picturesViews = array;
    }
    return self;

}

/**
 *  设置数据
 */
- (void)settingData
{
    // 微博数据
    YJ_homepageTweet *tweets = self.tweetsFrame.tweets;
    
    // 1.头像[NSURL URLWithString:[NSString fixStringByCutLastChar: tweets.iconUrl]]
    [self.iconPicView sd_setImageWithURL:[NSURL URLWithString: [NSString fixStringByCutLastChar: tweets.iconUrl]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.iconPicView.image = [UIImage circleImage:[[UIImage alloc]imageWithImage:image scaledToSize:CGSizeMake(40, 40)] borderWidth:2.0 borderColor:YJ_CIRCLE_BORDER_COLOR];
        tweets.iconpic = self.iconPicView.image;
    }];
//    self.iconPicView.image = [UIImage circleImage:tweets.iconpic borderWidth:CIRCLE_BORDER_WIDTH borderColor:YJ_CIRCLE_BORDER_COLOR];
    
    // 2.昵称
    self.usernameView.text = tweets.username;
    
    // 3.时间
    self.timerView.text = tweets.timer;
    
    // 4.正文
    self.textContentView.text = tweets.textContent;
    
    // 5.评论 点赞数量
    [self.commentCountView setTitle:[NSString stringWithFormat:@"  %d",tweets.commentCount] forState:UIControlStateNormal];
    [self.upVoteCountView setTitle:[NSString stringWithFormat:@"  %d",tweets.upVoteCount] forState:UIControlStateNormal];
    
    // 6.多配图
    for (int i = 0 ; i < tweets.picsUrl.count; i++){
//        [(UIImageView*)self.picturesViews[i] setImage:[tweets.pictures objectAtIndex:i]];
        [(UIImageView *)self.picturesViews[i] sd_setImageWithURL:[NSURL URLWithString:tweets.picsUrl[i]]];
        ((UIImageView *)self.picturesViews[i]).hidden = NO;
    }
    for (int i = tweets.picsUrl.count ; i<9; i++) {
        ((UIImageView *)self.picturesViews[i]).hidden = YES;
    }
}
/**
 *  设置frame
 */
- (void)settingFrame{
    
    // 1.头像
    self.iconPicView.frame = self.tweetsFrame.incoPicF;
    
    // 2.昵称
    self.usernameView.frame = self.tweetsFrame.usernameF;
    
    // 3.时间
    self.timerView.frame = self.tweetsFrame.timerF;
    
    // 4.正文
    self.textContentView.frame = self.tweetsFrame.textContentF;
    
    // 5.间隔底层view
    self.cellPaddingView.frame = self.tweetsFrame.cellPaddingF;
    
    // 6.整个可用view
    self.mycontentView.frame = self.tweetsFrame.mycontentViewF;
    
    // 7.评论
    self.commentCountView.frame = self.tweetsFrame.commentCountF;
    
    // 8.点赞
    self.upVoteCountView.frame = self.tweetsFrame.upVoteCountF;
    
    // 9.微博数据
    YJ_homepageTweet *tweets = self.tweetsFrame.tweets;
    
    // 10.图片
    for (int i = 0; i < tweets.picsUrl.count; i++) {
        ((UIImageView *) self.picturesViews[i]).frame = ((NSValue *) [self.tweetsFrame.picturesF objectAtIndex:i]).CGRectValue;
    }
}
/**
 *  重写tweetsFrame的写入方法
 */
-(void)setTweetsFrame:(YJ_homepageTweetFrame *)tweetsFrame{
    
    _tweetsFrame = tweetsFrame;
    
    [self settingData];
    
    [self settingFrame];
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"tweets";
    YJ_homepageTweetsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YJ_homepageTweetsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
