//
//  NSString+GetImageOldName.m
//  YouJoin
//
//  Created by Lawrence on 15/12/19.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "NSString+GetImageOldName.h"

@implementation NSString (GetImageOldName)
//图片名获取
+ (NSString*)imageNameWithImageURL:(NSURL *)url{
    NSString *string = [url absoluteString];
    int begin=0,end = 0;
    for (int i = 0; i<string.length; i++) {
        if ([string characterAtIndex:i] == '=') {
            if (begin == 0) begin = i+1;
        }
        if ([string characterAtIndex:i] == '&') {
            end = i;
        }
    }
//    muString =[string substringFromIndex:i];
    NSString *part1 = [string substringWithRange:NSMakeRange(begin, end-begin)];
    return [NSString stringWithFormat:@"%@",part1];
}
@end
