//
//  AppDelegate.m
//  ChannelPace
//
//  Created by Eagle on 11/23/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "AppDelegate.h"
#import "AWVersionAgent.h"
#import <GoogleMaps/GoogleMaps.h>



@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize serverCall;
@synthesize userSettingObj;
@synthesize accountInfoObj;
@synthesize navController;
@synthesize isLoggedIn;
@synthesize isUnpaired;
@synthesize accountInfoArray;
@synthesize selectCellIndex;



+ (AppDelegate*) sharedAppDelegate {
    
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        UIStoryboard *storyBoard;
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        CGFloat scale = [UIScreen mainScreen].scale;
        result = CGSizeMake(result.width * scale, result.height * scale);
        
        if(result.height == 960){
            storyBoard = [UIStoryboard storyboardWithName:@"Main_iphone4" bundle:nil];
            UIViewController *initViewController = [storyBoard instantiateInitialViewController];
            [self.window setRootViewController:initViewController];
        }
    }

    
    
    self.serverCall = [[ServerCall alloc] init];
    self.userSettingObj = [[UserSetting alloc] init];
    self.accountInfoObj = [[AccountInfo alloc] init];
    self.sourceAccount = [[AccountInfo alloc] init];
    self.targetAccount = [[AccountInfo alloc] init];
    
    self.accountInfoArray = [[NSMutableArray alloc] init];
    
    self.timezone = [NSTimeZone timeZoneWithName:@"Australia/Sydney"];
    self.url = @"service";
    [GMSServices provideAPIKey:@"AIzaSyAHU43Qv5tzMqBK1CvW7KStLfay_YV-12M"];
    
    self.mytokeninfo = @"3c775c6f947d198b7a6b4201860ce00677d288ba4f181ad7849c2a1c7988d7cf";
    
    [self getLoginInfo];
    [self getUserSetting];
    
    if (!isLoggedIn || userSettingObj.sortName == NULL) {
        [self initSettingViewValue];
        [self saveUserSetting];
    }
        
    self.user_id = userSettingObj.user_id;
    
    // Override point for customization after application launch.
    [[AWVersionAgent sharedAgent] setDebug:YES];
    [[AWVersionAgent sharedAgent] checkNewVersionForApp:@"453718989"];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
        
    return YES;
}

- (void) initSettingViewValue
{
    
    userSettingObj.sortName = @"FirstName";
    userSettingObj.orderName = @"FirstName LastName";
    userSettingObj.refreshTime = @"Daily";
    userSettingObj.mapping = @"Google";
    userSettingObj.bSyncAddress = NO;
}

- (void) saveAccountInfo
{
    
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.accountInfoObj.strFirstName       forKey:@"firstName"];
    [userDefaults setObject:self.accountInfoObj.strSurName       forKey:@"surName"];
    [userDefaults setObject:self.accountInfoObj.strJobTitle        forKey:@"jobTitle"];
    [userDefaults setObject:self.accountInfoObj.strDepartment           forKey:@"department"];
    [userDefaults setObject:self.accountInfoObj.strCompanyName         forKey:@"companyName"];
    [userDefaults setObject:self.accountInfoObj.strMobile          forKey:@"mobile"];
    [userDefaults setObject:self.accountInfoObj.strDirect        forKey:@"direct"];
    [userDefaults setObject:self.accountInfoObj.strCompany     forKey:@"companyPhoneNumber"];
    [userDefaults setObject:self.accountInfoObj.strFax          forKey:@"fax"];
    [userDefaults setObject:self.accountInfoObj.strEmail        forKey:@"email"];
    [userDefaults setObject:self.accountInfoObj.strReallyCompanyName forKey:@"reallyCompanyName"];    
    [userDefaults setObject:self.accountInfoObj.strIndustry forKey:@"industry"];
    [userDefaults setObject:self.accountInfoObj.strUserAbout forKey:@"userabout"];
    [userDefaults setObject:self.accountInfoObj.strJobFunction forKey:@"jobfunction"];
    [userDefaults setObject:self.accountInfoObj.strPhotoURL forKey:@"photoURL"];
    [userDefaults setObject:self.accountInfoObj.strAddress forKey:@"address"];
    [userDefaults setObject:self.accountInfoObj.strCountry forKey:@"country"];
    [userDefaults setObject:self.accountInfoObj.location_phone forKey:@"location_phone"];
    
    [userDefaults setObject:self.accountInfoObj.strStreet forKey:@"street"];
    [userDefaults setObject:self.accountInfoObj.strCity forKey:@"city"];
    [userDefaults setObject:self.accountInfoObj.strState forKey:@"state"];
    [userDefaults setObject:self.accountInfoObj.strPostal forKey:@"postal"];
    
    
    [userDefaults synchronize];

}

- (void) getAccountInfo
{
    
    NSUserDefaults  *userDefaults               = [NSUserDefaults standardUserDefaults];
    self.accountInfoObj.strFirstName            =   [userDefaults objectForKey:@"firstName"];
    self.accountInfoObj.strSurName              =   [userDefaults objectForKey:@"surName"];
    self.accountInfoObj.strJobTitle             =   [userDefaults objectForKey:@"jobTitle"];
    self.accountInfoObj.strDepartment           =   [userDefaults objectForKey:@"department"];
    self.accountInfoObj.strCompanyName          =   [userDefaults objectForKey:@"companyName"];
    self.accountInfoObj.strMobile               =   [userDefaults objectForKey:@"mobile"];
    self.accountInfoObj.strDirect               =   [userDefaults objectForKey:@"direct"];
    self.accountInfoObj.strCompany              =   [userDefaults objectForKey:@"companyPhoneNumber"];
    self.accountInfoObj.strFax                  =   [userDefaults objectForKey:@"fax"];
    self.accountInfoObj.strEmail                =   [userDefaults objectForKey:@"email"];
    self.accountInfoObj.strReallyCompanyName    = [userDefaults objectForKey:@"reallyCompanyName"];
    self.accountInfoObj.strIndustry             =   [userDefaults objectForKey:@"industry"];
    self.accountInfoObj.strUserAbout            = [userDefaults objectForKey:@"userabout"];
    self.accountInfoObj.strJobFunction          = [userDefaults objectForKey:@"jobfunction"];
    self.accountInfoObj.strPhotoURL             = [userDefaults objectForKey:@"photoURL"];
    self.accountInfoObj.strAddress              =    [userDefaults objectForKey:@"address"];
    self.accountInfoObj.strCountry              =    [userDefaults objectForKey:@"country"];

    self.accountInfoObj.location_phone                =    [userDefaults objectForKey:@"location_phone"];
    
    self.accountInfoObj.strStreet               =    [userDefaults objectForKey:@"street"];
    self.accountInfoObj.strCity                 =    [userDefaults objectForKey:@"city"];
    self.accountInfoObj.strState                =    [userDefaults objectForKey:@"state"];
    self.accountInfoObj.strPostal               =    [userDefaults objectForKey:@"postal"];
    
}


- (void) saveUserSetting
{
    
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:self.userSettingObj.user_id forKey:@"userID"];
    [userDefaults setObject:self.userSettingObj.sortName forKey:@"SortName"];
    [userDefaults setObject:self.userSettingObj.orderName forKey:@"OrderName"];
    [userDefaults setObject:self.userSettingObj.refreshTime forKey:@"RefreshTime"];
    [userDefaults setObject:self.userSettingObj.mapping forKey:@"Mapping"];
    [userDefaults setObject:[NSNumber numberWithBool:self.userSettingObj.bSyncAddress] forKey:@"SyncAddress"];
    [userDefaults setObject:[NSNumber numberWithBool:self.userSettingObj.bAssociate] forKey:@"Associate"];
    
    [userDefaults synchronize];
}

- (void) getUserSetting
{
    
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.userSettingObj.user_id         = [userDefaults objectForKey:@"userID"];
    self.userSettingObj.sortName        = [userDefaults objectForKey:@"SortName"];
    self.userSettingObj.orderName       = [userDefaults objectForKey:@"OrderName"];
    self.userSettingObj.refreshTime     = [userDefaults objectForKey:@"RefreshTime"];
    self.userSettingObj.mapping         = [userDefaults objectForKey:@"Mapping"];
    
    self.userSettingObj.bSyncAddress    = [[userDefaults objectForKey:@"SyncAddress"] boolValue];
    self.userSettingObj.bAssociate      = [[userDefaults objectForKey:@"Associate"] boolValue];

}


- (void) saveLoginInfo
{
    NSLog(@"UserAPI: %@", [NSString stringWithFormat:@"%@", _user_API_key]);
    
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithBool:isLoggedIn] forKey:@"IsLoggedIn"];
    [userDefaults setObject:[NSNumber numberWithBool:isUnpaired] forKey:@"Unpaired"];
    
    [userDefaults synchronize];
}

- (void) getLoginInfo
{
    
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    self.isLoggedIn = [[userDefaults objectForKey:@"IsLoggedIn"] boolValue];
    self.isUnpaired = [[userDefaults objectForKey:@"Unpaired"] boolValue];
}

- (void) saveUserAPIKEY
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.user_API_key forKey:@"user_API_key"];
    [userDefaults synchronize];
}

- (void) getUserAPIKEY
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.user_API_key = [userDefaults objectForKey:@"user_API_key"];

}



- (NSString *) getNowTime
{
    long hour;
    long minute;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    
    NSDate *now = [[NSDate alloc]init];
    
    NSString *dateString = [format stringFromDate:now];
    
    _setTime.dateFormat = @"hh:mm:ss";
    [_setTime setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"The Currevnttime is %@", [_setTime stringFromDate:now]);
    
    
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Australia/Sydney"];
    
    [cal setTimeZone:tz];
    NSDateComponents *comp = [cal components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:now];
    hour = [comp hour];
    minute = [comp minute];
    NSLog(@"Current Time : %ld", hour);
    
    return dateString;
}





- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"get token");
    _mytokeninfo = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",_mytokeninfo);
    
    
//    [[NSUserDefaults standardUserDefaults]setValue:tokenString forKey:@"DeviceToken"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"Error %@",err);    
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[AWVersionAgent sharedAgent] upgradeAppWithNotification:notification];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
