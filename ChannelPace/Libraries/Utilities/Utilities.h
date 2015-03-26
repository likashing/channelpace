//
//  Utilities.h
//  MySportalent
//
//  Created by Mountain on 5/11/13.
//  Copyright (c) 2013 Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Utilities : NSObject

+ (void) cosmeticView: (UIView*)viewNavi;

+ (void)drawSideAndBottomDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;
+ (void)drawSideAndTopDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;
+ (void)drawSideDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context;
+ (void)addBottomDropShadowToNavigationBarForNavigationController:(UINavigationController *)navigationController;
+ (void) cosmeticImageView:(UIImageView*)imgView;
+ (void) cosmeticButton: (UIButton*)btn;
+ (BOOL) isValidString:(NSString*) str;
+ (BOOL) validateEmailWithString:(NSString*)email;
+ (void) showMsg:(NSString*)strMsg;
+ (UIImage *)makeRoundedImage:(UIImage *) image radius: (float) radius;
+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
+ (void) showAvatar:(UIImageView*) imgView ImgName:(NSString*)strImgName;



@end
