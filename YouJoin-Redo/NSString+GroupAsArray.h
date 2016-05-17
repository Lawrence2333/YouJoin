//
//  NSString+GroupAsArray.h
//  YouJoin
//
//  Created by Lawrence on 16/2/20.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GroupAsArray)
/**
 *  将以";"分割的字符串变成数组传出
 *
 */
+(NSArray *)arrayFromString:(NSString *)string;
@end
