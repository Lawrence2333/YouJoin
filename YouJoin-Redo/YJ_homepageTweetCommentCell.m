//
//  YJ_homepageTweetCommentCell.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/6/8.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_homepageTweetCommentCell.h"
#import "YJ_homepageTweetComment.h"

@interface YJ_homepageTweetCommentCell()

@property (nonatomic,weak) UILabel * commentLabel;

@end

@implementation YJ_homepageTweetCommentCell

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *comment = [[UILabel alloc]init];
        comment.font = YJ_SMALLTEXT_FONT;
        comment.numberOfLines = 0;
        comment.alpha = 0.7;
        
        [self addSubview:comment];
        self.commentLabel = comment;
        
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"comment";
    YJ_homepageTweetCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YJ_homepageTweetCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
    
}

-(void)setComment:(YJ_homepageTweetComment *)comment{
    
    _comment = comment;
    NSString *commentStr = [NSString stringWithFormat:@"%@ : %@",self.comment.username,self.comment.commentContent];
    CGSize commentSize = [self sizeWithText:commentStr font:YJ_NameFont maxSize:CGSizeMake(240, MAXFLOAT)];
    self.commentLabel.text = commentStr;
    self.commentLabel.frame = CGRectMake(40, 10, commentSize.width, commentSize.height);
    _comment.cellHeight = CGRectGetMaxY(self.commentLabel.frame)+10;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

@end
