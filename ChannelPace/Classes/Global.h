//
//  Global.h
//  ChannelPace
//
//  Created by Eagle on 11/26/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"


#define iPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define itemCellSize (iPhone ? 29: 40)
#define itemCellHeight (iPhone ? 29: 40)
#define itemCellWidth (iPhone ? 45: 70)


////https://api.channelpace.com
#define SERVER_URL              @"https://api.channelpace.com/m2/"
#define CONTROL_API_KEY         @"xz7z2s7K62MC9u0006GHT3M45P28yV38"





@interface Global : NSObject

+(Global*) Instance;

+(AppDelegate *)getAppDelegate;

+ (BOOL) isIPhone5;

@end
