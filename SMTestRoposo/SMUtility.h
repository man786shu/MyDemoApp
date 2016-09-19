//
//  SMUtility.h
//  SMTestRoposo
//
//  Created by Shubham Mandal on 18/09/16.
//  Copyright © 2016 Shubham Mandal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define SMCenteredOrigin(x, y) floor((x - y)/2.0)

@interface SMUtility : NSObject

+ (SMUtility *)sharedManager;

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font;
+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font width:(float)width;
+ (CGSize)sizeForAttributedString:(NSAttributedString *)attrString width:(float)width;
+ (CGSize)sizeForAttributedString:(NSAttributedString *)attrString width:(float)width height:(float)height;
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)i_width;

@end
