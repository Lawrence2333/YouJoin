//
//  YJ_JSONSerialization.m
//  YouJoin
//
//  Created by MacBookPro on 15/12/2.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import "YJ_JSONSerialization.h"
#import "NSString+json.h"

@implementation YJ_JSONSerialization

+(id)JSONObjectWithDataUsingFix:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError * _Nullable __autoreleasing *)error{
    NSMutableString *mustring = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableString *string = [[NSMutableString alloc]init];
    int i = 0;
    for (; i<mustring.length; i++) {
        if ([mustring characterAtIndex:i]=='{') {
            break;
        }
    }
    for (; i<mustring.length&&[mustring characterAtIndex:i]!='}'; i++) {
        [string appendFormat:@"%c",[mustring characterAtIndex:i]];
    }
    [string appendString:@"}"];
    
    //json转字典
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:1 error:NULL];
    //
    //NSLog(@"%@",mustring);
    //NSLog(@"%@",loginDict);
    return dict;
}
+(NSDictionary*)dictWithDataWithArray:(NSData *)data{
    NSMutableString *mustring = [[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableArray *muarray = [[NSMutableArray alloc]init];
    NSMutableDictionary *finalDict = [[NSMutableDictionary alloc]init];
    NSMutableString *arrayName = [[NSMutableString alloc]init];
    BOOL readArray = NO;
    for (int i = 0; i<mustring.length; i++) {
        if ([mustring characterAtIndex:i] == '{'&& !readArray) {
            NSMutableString *string = [[NSMutableString alloc]init];
            while ([mustring characterAtIndex:i] != ',') {
                [string appendString:[NSString stringWithFormat:@"%c",[mustring characterAtIndex:i]]];
                i++;
            }
            [string appendString:[NSString stringWithFormat:@"%c",'}']];
            [finalDict setDictionary:[self JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil]];
        }
        else if([mustring characterAtIndex:i] == '\"'){
            i++;
            while ([mustring characterAtIndex:i] != '\"') {
                [arrayName appendString:[NSString stringWithFormat:@"%c",[mustring characterAtIndex:i]]];
                i++;
            }
        }
        else if ([mustring characterAtIndex:i] == '[') {
            readArray = YES;
        }
        else if ([mustring characterAtIndex:i] == '{'&& readArray){
            NSMutableString *string = [[NSMutableString alloc]init];
            while ([mustring characterAtIndex:i] != '}') {
                [string appendString:[NSString stringWithFormat:@"%c",[mustring characterAtIndex:i]]];
                i++;
            }
            [string appendString:[NSString stringWithFormat:@"%c",[mustring characterAtIndex:i]]];
            NSLog(@"%@",string);
            NSDictionary *dict = [self JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            [muarray addObject:dict];
            
            [finalDict setObject:muarray forKey:arrayName];
        }
    }
    return finalDict;
}
@end
