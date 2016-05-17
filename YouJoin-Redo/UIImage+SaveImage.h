//
//  UIImage+SaveImage.h
//  YouJoin-Redo
//
//  Created by Lawrence on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SaveImage)
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
@end
