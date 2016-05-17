//
//  NSString+Json.h
//  YouJoin
//
//  Created by MacBookPro on 15/12/17.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_json)

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString *) jsonStringWithArray:(NSArray *)array;

+(NSString *) jsonStringWithString:(NSString *) string;

+(NSString *) jsonStringWithObject:(id) object;

@end
