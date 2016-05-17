//
//  YJ_homepageLeftListCellView.m
//  YouJoin
//
//  Created by MacBookPro on 15/12/14.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "YJ_homepageLeftListCellView.h"
@implementation YJ_homepageLeftListCellView

+(instancetype)initWithTitle:(NSString*)title andY:(int)y andTextfieldText:(NSString *)text{
    
    YJ_homepageLeftListCellView *cellView = [[YJ_homepageLeftListCellView alloc]init];
    int padding = 5;
    
    //locationLabel setting
    YJ_homepageLabel *locationLabel = [[YJ_homepageLabel alloc]init];
    locationLabel.text = title;
    locationLabel.font = YJ_TextFont;
    locationLabel.textColor = [UIColor blackColor];
    locationLabel.textAlignment = NSTextAlignmentLeft;
    CGFloat ltlX = 20;
    CGFloat ltlY = 0;
    CGFloat ltlH = 25;
//    CGFloat ltlW = 100;
    CGFloat ltlW = 80;
    locationLabel.frame = CGRectMake(ltlX, ltlY, ltlW, ltlH);
    cellView.myLabel = locationLabel;
    [cellView addSubview:locationLabel];
    
    //locationField setting
    //用户location
    YJ_homepageLeftListTextField *locationField = [[YJ_homepageLeftListTextField alloc]init];
//    CGFloat lfX = 0;
//    CGFloat lfY = CGRectGetMaxY(locationLabel.frame);
//    CGFloat lfW = 320;
//    CGFloat lfH = 40;//设置输入框高度
    CGFloat lfX = ltlX + ltlW +padding*2;
    CGFloat lfY = ltlY;
    CGFloat lfW = 320 - ltlW - padding*2 - ltlX*2;
    CGFloat lfH = ltlH;
    
    locationField.frame = CGRectMake(lfX, lfY, lfW, lfH);
    locationField.text = text;
    locationField.textColor = [UIColor blackColor];
    locationField.font = YJ_TextFont;
    cellView.myTextfield = locationField;
    [cellView addSubview:locationField];
    
    cellView.frame = CGRectMake(0, y, 320, locationLabel.frame.size.height + padding + locationField.frame.size.height);
    
    return cellView;
}
-(void)setTextFieldText:(NSString *)text{
    self.myTextfield.text = text;
}
@end
