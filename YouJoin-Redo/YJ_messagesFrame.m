//
//  YJ_messagesFrame.m
//  YouJoin
//
//  Created by Lawrence on 15/12/31.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "YJ_messagesFrame.h"
#import "YJ_messages.h"
#import "NSString+Extension.h"
@implementation YJ_messagesFrame
- (void)setMessage:(YJ_messages *)message
{
    _message = message;
    // 间距
    CGFloat padding = 10;
    // 屏幕的宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 1.时间
    if (message.hideTime == NO) { // 显示时间
        CGFloat timeX = 0;
        CGFloat timeY = 0;
        CGFloat timeW = screenW;
        CGFloat timeH = 40;
        _timeF = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
//    // 2.头像
//    CGFloat iconY = CGRectGetMaxY(_timeF) + padding;
//    CGFloat iconW = 40;
//    CGFloat iconH = 40;
//    CGFloat iconX;
//    if (message.type == YJ_MessageTypeOther) {// 别人发的
//        iconX = padding;
//    } else { // 自己的发的
//        iconX = screenW - padding - iconW;
//    }
//    _iconF = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 3.正文
    CGFloat textY = CGRectGetMaxY(_timeF)+padding;
    // 文字计算的最大尺寸
    CGSize textMaxSize = CGSizeMake(200, MAXFLOAT);
    // 文字计算出来的真实尺寸(按钮内部label的尺寸)
    CGSize textRealSize = [message.text sizeWithFont:YJ_NameFont maxSize:textMaxSize];
    // 按钮最终的真实尺寸
    CGSize textBtnSize = CGSizeMake(textRealSize.width + padding * 2, textRealSize.height + padding * 2);
    CGFloat textX;
    if (message.type == YJ_MessageTypeOther) {// 别人发的
        textX = padding*2;
    } else {// 自己的发的
        textX = 320 - padding*2 - textBtnSize.width;
    }
    //    _textF = CGRectMake(textX, textY, textSize.width + 40, textSize.height + 40);
    _textF = (CGRect){{textX, textY}, textBtnSize};
    
    // 4.cell的高度
    CGFloat textMaxY = CGRectGetMaxY(_textF);
    CGFloat iconMaxY = CGRectGetMaxY(_iconF);
    _cellHeight = MAX(textMaxY, iconMaxY) + padding;
}
@end
