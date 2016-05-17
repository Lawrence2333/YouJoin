//
//  YJ_View.m
//  YouJoin
//
//  Created by MacBookPro on 15/11/8.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "YJ_View.h"

@implementation YJ_View

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *result = [super hitTest:point withEvent:event];
    [self endEditing:YES];
    return result;
}

@end
