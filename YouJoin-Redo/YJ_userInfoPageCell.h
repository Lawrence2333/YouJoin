//
//  YJ_userInfoPageCell.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/5.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJ_userInfoPageCell : UITableViewCell

-(instancetype)initWithKey:(NSString *)key andValue:(NSString *)value andBlock:(void(^)())block;

@end
