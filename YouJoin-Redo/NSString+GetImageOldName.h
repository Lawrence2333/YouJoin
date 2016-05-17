//
//  NSString+GetImageOldName.h
//  YouJoin
//
//  Created by Lawrence on 15/12/19.
//  Copyright © 2015年 MacBookPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GetImageOldName)
//图片名获取
+ (NSString*)imageNameWithImageURL:(NSURL *)url;
@end
