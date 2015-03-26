//
//  Macro.h
//  MySportalent
//
//  Created by Mountain on 5/11/13.
//  Copyright (c) 2013 Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SCRN_WIDTH		[[UIScreen mainScreen] bounds].size.width
#define SCRN_HEIGHT		[[UIScreen mainScreen] bounds].size.height
#define IS_PHONE5 SCRN_HEIGHT > 480 ? TRUE:FALSE
#define APPDELEGATE [AppDelegate sharedAppDelegate]
    

//#define SERVER_URL  @"https://api.channelpace.com/m2/"



// Local Notification
//#define kNotiDismissCam     @"DismissCam"
//#define kNotiCloseCamGate   @"CloseCamGate"
//#define kNotiOpenCamGate    @"OpenCamGate"


#define kAdmobUnitId  @"/6253334/dfp_example_ad"

@interface Macro : NSObject

@end
