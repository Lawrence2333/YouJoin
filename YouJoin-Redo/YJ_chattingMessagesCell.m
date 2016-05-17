//
//  YJ_chattingMessagesCell.m
//  YouJoin
//
//  Created by Lawrence on 15/12/31.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "YJ_chattingMessagesCell.h"
#import "YJ_messagesFrame.h"
#import "UIImage+Extension.h"
#import "YJ_messages.h"
@interface YJ_chattingMessagesCell()

/**
 *  时间
 */
@property (nonatomic, weak) UILabel *timeView;
/**
 *  头像
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  正文
 */
@property (nonatomic, weak) UIButton *textView;

@end

@implementation YJ_chattingMessagesCell
-(void)awakeFromNib{
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"message";
    YJ_chattingMessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YJ_chattingMessagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 子控件的创建和初始化
        // 1.时间
        UILabel *timeView = [[UILabel alloc] init];
        timeView.textAlignment = NSTextAlignmentCenter;
        timeView.textColor = [UIColor blackColor];
        timeView.font = YJ_TextFont;
        [self.contentView addSubview:timeView];
        self.timeView = timeView;
        
        // 2.头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        // 3.正文
        UIButton *textView = [[UIButton alloc] init];
        textView.titleLabel.numberOfLines = 0; // 自动换行
        textView.titleLabel.font = YJ_NameFont;
        textView.contentEdgeInsets = UIEdgeInsetsMake(YJ_TextPadding, YJ_TextPadding, YJ_TextPadding, YJ_TextPadding);
        [textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:textView];
        self.textView = textView;
        
        // 4.设置cell的背景色
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setMessagesFrame:(YJ_messagesFrame *)messageFrame
{
    _messagesFrame = messageFrame;
    
    YJ_messages *message = messageFrame.message;
    
    // 1.时间
    self.timeView.text = message.time;
    self.timeView.frame = messageFrame.timeF;
    
    // 2.头像
    NSString *icon = (message.type == YJ_MessageTypeMe) ? @"me" : @"other";
    self.iconView.image = [UIImage imageNamed:icon];
    self.iconView.frame = messageFrame.iconF;
    
    // 3.正文
    [self.textView setTitle:message.text forState:UIControlStateNormal];
    self.textView.frame = messageFrame.textF;
    
    // 4.正文的背景
    if (message.type == YJ_MessageTypeMe) { // 自己发的
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_cell_me"] forState:UIControlStateNormal];
    } else { // 别人发的
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_cell_other"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
