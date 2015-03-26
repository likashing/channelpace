//
//  Global.m
//  ChannelPace
//
//  Created by Eagle on 11/26/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "Global.h"

static Global* instance = nil;




@interface Global ()

@end

@implementation Global



+(Global*) Instance
{
    if (instance == nil) {
        instance = [[Global alloc] init];
    }
    
    return instance;
}

+(AppDelegate *)getAppDelegate{
    AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate;
}


+ (BOOL) isIPhone5
{
    if ((![UIApplication sharedApplication].statusBarHidden && (int)[[UIScreen mainScreen] applicationFrame].size.height == 548 )|| ([UIApplication sharedApplication].statusBarHidden && (int)[[UIScreen mainScreen] applicationFrame].size.height == 568))
        return YES;
    
    return NO;
}

+(NSString *)adoptImgName:(NSString *)ImgName
{
    NSString *newName = ImgName;
    if(iPhone){
        if ((![UIApplication sharedApplication].statusBarHidden && (int)[[UIScreen mainScreen] applicationFrame].size.height == 548 )|| ([UIApplication sharedApplication].statusBarHidden && (int)[[UIScreen mainScreen] applicationFrame].size.height == 568)){
            newName = (NSString *)[newName stringByAppendingString:@"_iPhone5.png"];
        }else{
            newName = (NSString *)[newName stringByAppendingString:@"_iPhone5.png"];
        }
    }
    return newName;
}


@end
