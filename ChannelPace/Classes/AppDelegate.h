//
//  AppDelegate.h
//  ChannelPace
//
//  Created by Eagle on 11/23/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import "Utilities.h"
#import "ServerCall.h"
#import "AccountInfo.h"
#import "UserSetting.h"



@class RefreshingViewController;
@class MyContactsViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>


@property (strong, nonatomic) UIWindow                          *window;
@property (strong, nonatomic) UINavigationController            *navController;
@property (strong, nonatomic) RefreshingViewController          *viewController;

@property (nonatomic, strong)       ServerCall                  *serverCall;

@property (nonatomic, strong)       AccountInfo                 *accountInfoObj;
@property (nonatomic, strong)       UserSetting                 *userSettingObj;
@property (nonatomic, strong)       AccountInfo                 *sourceAccount;
@property (nonatomic, strong)       AccountInfo                 *targetAccount;

@property (nonatomic, readwrite)    BOOL                        isLoggedIn;
@property (nonatomic, readwrite)    BOOL                        isUnpaired;

@property (nonatomic, strong) NSMutableArray                    *accountInfoArray;

@property (nonatomic, strong) NSString          *user_id;
@property (nonatomic, strong) NSString          *user_API_key;
@property (nonatomic, strong) NSString          *strEmail;
@property (nonatomic, strong) NSString          *mytokeninfo;
@property (nonatomic, strong) NSString          *PIN;

@property (nonatomic, strong) NSString          *url;
@property (nonatomic, strong) NSString          *companyStreet;
@property (nonatomic, strong) NSString          *companyAddress;
@property (nonatomic, strong) NSString          *companyName;

@property                          int          contactCount;


@property (nonatomic, strong) NSDateFormatter   *setTime;
@property (nonatomic, strong) NSTimeZone        *timezone;



@property NSInteger                             selectCellIndex;

@property int                                   screenNum;


+ (AppDelegate*) sharedAppDelegate;


- (void) saveAccountInfo;
- (void) getAccountInfo;
- (void) saveUserSetting;
- (void) getUserSetting;
- (void) getLoginInfo;
- (void) saveLoginInfo;
- (void) saveUserAPIKEY;
- (void) getUserAPIKEY;
- (NSString *) getNowTime;


@end

