//
//  LoginSuccessfulViewController.h
//  ChannelPace
//
//  Created by Eagle on 11/24/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCall.h"
#import "DBHandler.h"



@interface LoginSuccessfulViewController : UIViewController<ServerCallDelegate, UIAlertViewDelegate>
{
    
    BOOL bSaveDatabase;

}

@property (nonatomic, strong) DBHandler *dbHandler;
@property (nonatomic, strong) NSMutableArray *arrayAccountData;


+ (LoginSuccessfulViewController *) SharedData;

- (void) navigate;
- (void) OnRequestMyContactsInfo;
- (void) OnReceived: (NSDictionary*) dictData;
- (void) getAccountInfo:(NSDictionary *)dictData;
- (NSString *) getNotNullValue:(NSObject *) param;

@end
