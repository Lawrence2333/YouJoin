//
//  NSString+CutLastChar.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/5/12.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "NSString+CutLastChar.h"

@implementation NSString (CutLastChar)

+(NSString *)fixStringByCutLastChar:(NSString *)oldString{
    
    NSMutableString *muStr = [NSMutableString stringWithString:oldString];
    
    [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];
    
    return [NSString stringWithString:muStr];
}

@end
