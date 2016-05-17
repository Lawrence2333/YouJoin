//
//  YJ_LoginViewTextField.m
//  YouJoin
//
//  Created by MacBookPro on 15/11/4.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "YJ_LoginViewTextField.h"

@implementation YJ_LoginViewTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 5, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 5, 0);
}

- (void)drawRect:(CGRect)rect{
//    [super drawRect:rect];
     UIImage *bg = [[UIImage imageNamed:@"login_textField"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 5, 15, 5)];
     [bg drawInRect:[self bounds]];
    [self setValue:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] forKeyPath:@"_placeholderLabel.textColor"];
    self.clearButtonMode = UITextFieldViewModeAlways;
 }
@end
