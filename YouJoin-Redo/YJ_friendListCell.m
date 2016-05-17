//
//  YJ_friendListCell.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/8.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_friendListCell.h"
#import "UIImage+Circle.h"
#import "UIImageView+WebCache.h"
#import "UIImage+SmallImage.h"
//#import "YJ_friend.h"
@interface YJ_friendListCell()


@property(nonatomic,strong) UILabel *usernameLabel;

@end

@implementation YJ_friendListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat padding = 10;
        CGFloat iconSize = 40;
        
        UIImageView *iconView = [[UIImageView alloc]init];
        [iconView setImage:[UIImage imageNamed:@"logo2"]];
//        iconView.image = [UIImage imageNamed:@"logo2"];
        iconView.frame = CGRectMake(padding, 6, iconSize, iconSize);
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *usernameLabel = [[UILabel alloc]init];
        usernameLabel.frame = CGRectMake(CGRectGetMaxX(iconView.frame)+padding, 6, self.frame.size.width - CGRectGetMaxX(iconView.frame)+padding, iconSize);
        
        [self.contentView addSubview:usernameLabel];
        self.usernameLabel = usernameLabel;
        
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"friendcell";
    YJ_friendListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YJ_friendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

-(void)setFriendInfo:(YJ_friend *)friendInfo{
    
    _friendInfo = friendInfo;
    
    self.usernameLabel.text = friendInfo.friendNickname;
    
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:friendInfo.friendIconUrl]];
//    self.iconView.image = [UIImage circleImage:[[UIImage alloc]imageWithImage:self.iconView.image scaledToSize:CGSizeMake(40, 40)] borderWidth:2.0 borderColor:YJ_CIRCLE_BORDER_COLOR];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
