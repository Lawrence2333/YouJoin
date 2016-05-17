//
//  YJ_chattingTableViewCell.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/9.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_chattingTableViewCell.h"
#import "YJ_friendList.h"
#import "UIImageView+WebCache.h"
#import "YJ_userInfo.h"
#import "YJ_networkTool.h"
#import "NSString+CutLastChar.h"
#import "YJ_chattingConversation.h"
#import "UIImage+SmallImage.h"
#import "UIImage+Circle.h"
#import "YJ_userDetailInfo.h"

@implementation YJ_chattingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat iconH = 40;
        CGFloat iconW = iconH;
        CGFloat iconX = 10;
        CGFloat iconY = 5;
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(iconX, iconY, iconW, iconH)];
        self.iconView = iconView;
        [self.contentView addSubview:iconView];
        
        CGFloat nameLabelW = 240;
        CGFloat nameLabelH = 20;
        CGFloat nameLabelX = 60;
        CGFloat nameLabelY = 10;
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH)];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        CGFloat textLabelW = 240;
        CGFloat textLabelH = 15;
        CGFloat textLabelX = 60;
        CGFloat textLabelY = 30;
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(textLabelX, textLabelY, textLabelW, textLabelH)];
        self.messageLabel = textLabel;
        [self.contentView addSubview:textLabel];
        
        CGFloat unReadBtnW = 20;
        CGFloat unReadBtnH = 20;
        CGFloat unReadBtnX = 290;
        CGFloat unReadBtnY = 15;
        UIButton *unReadMessagesCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        unReadMessagesCountBtn.frame = CGRectMake(unReadBtnX, unReadBtnY, unReadBtnW, unReadBtnH);
        unReadMessagesCountBtn.backgroundColor = [UIColor redColor];
        [unReadMessagesCountBtn setUserInteractionEnabled:NO];
        self.unReadMessagesCountBtn = unReadMessagesCountBtn;
        [self.contentView addSubview:unReadMessagesCountBtn];
        
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"chat";
    YJ_chattingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YJ_chattingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(void)setConversation:(YJ_chattingConversation *)conversation{
    
    _conversation = conversation;
    
    [YJ_networkTool getUserDetailInfo:self.conversation.username type:YJ_chooseUserTypeUserName completion:^(YJ_userDetailInfo *receivedUserDetailInfo) {
        
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NSString  fixStringByCutLastChar:receivedUserDetailInfo.userImage]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            self.iconView.image = [UIImage circleImage:[[UIImage alloc]imageWithImage:image scaledToSize:CGSizeMake(40, 40)] borderWidth:2.0 borderColor:YJ_CIRCLE_BORDER_COLOR];
            
        }];
        
    }];
   
    self.nameLabel.text = conversation.ConversationTitle;
    self.messageLabel.text = conversation.conversationLastMessage;
    
    if (conversation.unReadMessages!=nil && conversation.unReadMessages.count!=0) {
        [self.unReadMessagesCountBtn setTitle:[NSString stringWithFormat:@"%d", conversation.unReadMessages.count] forState:UIControlStateNormal];
        self.unReadMessagesCountBtn.hidden = NO;
    }else{
        self.unReadMessagesCountBtn.hidden = YES;
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
