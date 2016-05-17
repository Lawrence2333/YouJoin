//
//  YJ_homepageLeftListCellView.h
//  YouJoin
//
//  Created by MacBookPro on 15/12/14.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJ_homepageLeftListTextField.h"
#import "YJ_homepageLabel.h"
@interface YJ_homepageLeftListCellView : UIView
@property (nonatomic,weak) YJ_homepageLabel *myLabel;
@property (nonatomic,weak) YJ_homepageLeftListTextField *myTextfield;

-(void)setTextFieldText:(NSString *)text;
+(instancetype)initWithTitle:(NSString*)title andY:(int)y andTextfieldText:(NSString *)text;
@end
