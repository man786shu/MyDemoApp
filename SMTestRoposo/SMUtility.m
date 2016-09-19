//
//  SMUtility.m
//  SMTestRoposo
//
//  Created by Shubham Mandal on 18/09/16.
//  Copyright © 2016 Shubham Mandal. All rights reserved.
//

#import "SMUtility.h"

@implementation SMUtility

+ (SMUtility *)sharedManager
{
    static SMUtility *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[super allocWithZone:nil] init];
    });
    return _sharedManager;
}

#pragma mark - Size of string

+ (CGSize)sizeForAttributedString:(NSAttributedString *)attrString width:(float)width
{
    CGSize size = [attrString boundingRectWithSize:(CGSize) {width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

+ (CGSize)sizeForAttributedString:(NSAttributedString *)attrString width:(float)width height:(float)height
{
    CGSize size = [attrString boundingRectWithSize:(CGSize) {width, height} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}
+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font
{
    if (!font || !string) {
        return CGSizeZero;
    }
    
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName : font}];
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font width:(float)width
{
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName : font}];
    return [self sizeForAttributedString:attrString width:width];
}

+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), NO, 0);
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
