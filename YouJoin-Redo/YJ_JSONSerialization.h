//
//  YJ_JSONSerialization.h
//  YouJoin
//
//  Created by MacBookPro on 15/12/2.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJ_JSONSerialization : NSJSONSerialization
+(id)JSONObjectWithDataUsingFix:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError **)error;
+(NSDictionary *)dictWithDataWithArray:(NSData *)data;
@end
