//
//  RequestPostUploadHelper.h
//  testingforjson
//
//  Created by MacBookPro on 15/12/16.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RequestPostUploadHelper : NSObject

/**
 *POST 提交 并可以上传图片-单张
 */
+ (NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSDictionary *)postParems // IN 提交参数据集合
                     picFilePath: (NSString *)picFilePath  // IN 上传图片路径
                     picFileName: (NSString *)picFileName;  // IN 上传图片名称
/**
 *POST 提交 并可以上传图片-多张
 */
+ (NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSDictionary *)postParems // IN
                     picFilePath: (NSArray *)picFilePaths  // IN
                picFileNameArray: (NSArray *)picFileNames;  // IN
/**
 * 生成GUID
 */
+ (NSString *)generateUuidString;
@end