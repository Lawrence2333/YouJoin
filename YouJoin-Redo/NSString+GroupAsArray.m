//
//  NSString+GroupAsArray.m
//  YouJoin
//
//  Created by Lawrence on 16/2/20.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "NSString+GroupAsArray.h"

@implementation NSString (GroupAsArray)

+(NSArray *)arrayFromString:(NSString *)string{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    NSMutableString *muString = [[NSMutableString alloc]init];
    
    for (int i = 0; i<string.length; i++) {
        
        if ([string characterAtIndex:i] == ';') {
            
            [array addObject:muString];
            muString = [NSMutableString new];
            
        }
        else [muString appendFormat:@"%c",[string characterAtIndex:i]];
    }
    [array addObject:muString];
    
    return array;
}

@end
