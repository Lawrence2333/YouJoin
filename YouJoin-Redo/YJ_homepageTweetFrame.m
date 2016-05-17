//
//  YJ_homepageTweetFrame.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/3/24.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_homepageTweetFrame.h"
#import "YJ_homepageTweet.h"

@implementation YJ_homepageTweetFrame

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

-(void)setTweets:(YJ_homepageTweet *)tweets{
    
    _tweets = tweets;
    
    [self settingFinalFrame];
}

-(void)settingFinalFrame{
    
    CGFloat padding = 10;
    CGFloat commentHeight = 30;
    CGFloat cellPaddingHeight = 5;
    
    // 1.头像
    CGFloat iconX = padding;
    CGFloat iconY = padding;
    CGFloat iconW = 30;
    CGFloat iconH = 30;
    _incoPicF = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 2.昵称
    // 文字的字体
    CGSize nameSize = [self sizeWithText:self.tweets.username font:YJ_NameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat nameX = CGRectGetMaxX(_incoPicF) + padding;
    CGFloat nameY = iconY + (iconH - nameSize.height) * 0.5;
    _usernameF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    
    // 3.时间
    CGSize timerSize = [self sizeWithText:self.tweets.timer font:YJ_NameFont maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    CGFloat timerX = 320 - padding * 11;
    CGFloat timerY = nameY;
    _timerF = CGRectMake(timerX, timerY, timerSize.width, timerSize.height);
    
    // 4.正文
    CGFloat textX = nameX;
    CGFloat textY = CGRectGetMaxY(_incoPicF) + padding;
    CGSize textSize = [self sizeWithText:self.tweets.textContent font:YJ_TextFont maxSize:CGSizeMake(240, MAXFLOAT)];
    _textContentF = CGRectMake(textX, textY, textSize.width, textSize.height);
    
    //无配图 cell的高度
    _cellHeight = CGRectGetMaxY(_textContentF) + cellPaddingHeight + commentHeight + padding;
    // 多配图高度设置
    if (self.tweets.picsUrl.count!=0) {
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        for (int i = 0; i<self.tweets.picsUrl.count; i++) {
            CGFloat row = i/3;
            CGFloat column = i%3;
            CGFloat picturePadding = 10;
            CGFloat pictureBoardPadding = 15;
            CGFloat pictureW = 80;
            CGFloat pictureH = 80;
            
            CGFloat pictureX = iconW + column * (pictureW + picturePadding) + pictureBoardPadding;
            CGFloat pictureY = row * (pictureH + picturePadding) + CGRectGetMaxY(_textContentF) + padding;
            
            CGRect rect = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            NSValue *value = [NSValue valueWithCGRect:rect];
            [array addObject:value];
            
        }
        _picturesF = array;
        _cellHeight = CGRectGetMaxY(((NSValue *)_picturesF.lastObject).CGRectValue) + cellPaddingHeight + commentHeight + padding;
    }
    
    //内容部分
    _mycontentViewF = CGRectMake(0, 0, 320, _cellHeight - cellPaddingHeight);
    
    //等同于cell高度
    _cellPaddingF = CGRectMake(0, 0, 320, _cellHeight);
    
    //commentCount和upVoteCount的Frame
    CGFloat countW = 160;
    CGFloat countH = 30;
    
    _commentCountF = CGRectMake(160,_mycontentViewF.size.height - commentHeight , countW, countH);
    _upVoteCountF = CGRectMake(0, _mycontentViewF.size.height - commentHeight, countW, countH);
    
}
@end
