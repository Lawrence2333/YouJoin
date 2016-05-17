//
//  YJ_HomePageTextField.m
//  YouJoin
//
//  Created by MacBookPro on 15/11/17.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "YJ_HomePageTextField.h"

@implementation YJ_HomePageTextField

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
    UIImage *bg = [[UIImage imageNamed:@"homepage_editField"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 5, 15, 5)];
    [bg drawInRect:[self bounds]];
}
@end
