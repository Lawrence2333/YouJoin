//
//  YJ_userInfoPageCell.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/5.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "YJ_userInfoPageCell.h"

@interface YJ_userInfoPageCell()

@property (nonatomic ,strong) void (^myblock)();

@end

@implementation YJ_userInfoPageCell

-(instancetype)initWithKey:(NSString *)key andValue:(NSString *)value andBlock:(void (^)())myblock{
    
    if (self = [super init]) {
        
        self.backgroundColor = YJ_HOMEPAGE_GRAY_COLOR;
        
        CGFloat keyX = 10;
        CGFloat keyH = 30;
        CGFloat keyW = self.frame.size.width/2-keyX-5;
        CGFloat keyY = (self.frame.size.height-keyH)/2;
        
        UILabel *keyLabel = [[UILabel alloc]initWithFrame:CGRectMake(keyX, keyY, keyW, keyH)];
        keyLabel.text = key;
        keyLabel.font = YJ_TextFont;
        
        [self addSubview:keyLabel];
        
        CGFloat valueX = self.frame.size.width-keyW-keyX;
        CGFloat valueH = 30;
        CGFloat valueW = self.frame.size.width/2-keyX-5;
        CGFloat valueY = (self.frame.size.height-valueH)/2;
        
        UILabel *valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(valueX, valueY, valueW, valueH)];
        valueLabel.text = [self replaceUnicode:value];
        valueLabel.font = YJ_TextFont;
        
        [self addSubview:valueLabel];
        
        self.myblock = myblock;
    }
    return self;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    // NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"%u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:nil error:nil];
    
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
}

@end
