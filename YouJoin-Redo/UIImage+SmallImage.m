//
//  UIImage+SmallImage.m
//  YouJoin-Redo
//
//  Created by Lawrence on 16/1/28.
//  Copyright © 2016年 MacBookPro. All rights reserved.
//

#import "UIImage+SmallImage.h"

@implementation UIImage(SmallImage)

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
