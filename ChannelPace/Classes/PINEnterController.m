//
//  PINEnterController.m
//  ChannelPace
//
//  Created by Eagle on 11/24/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "PINEnterController.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "LoginSuccessfulViewController.h"
#import "EmailwithLogin.h"
#import "Global.h"
#import "OfflineViewController.h"



@interface PINEnterController ()

@end

@implementation PINEnterController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _titleLabel.text = [NSString stringWithFormat:@"Enter the PIN we have sent to %@", APPDELEGATE.strEmail];
    // Do any additional setup after loading the view.
    [_txtPIN becomeFirstResponder];
    _txtPIN.delegate = self;
    
    if ([APPDELEGATE.PIN isEqualToString:@"<null>"]) {
        _txtPIN.text = @"";
    } else {
        _txtPIN.text = APPDELEGATE.PIN;
    }
}



- (IBAction) onClickGo:(id)sender
{
    NSString *str = _txtPIN.text;
    if ([str isEqualToString:@""] || [str isEqualToString:@" "]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Please enter a your PIN." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    
    } else {
        [_txtPIN resignFirstResponder];
        [self OnRequest];
    }
    
    
}

- (IBAction)tapGesture:(id)sender {
    [_txtPIN resignFirstResponder];
}

- (void) OnRequest
{

    APPDELEGATE.serverCall = [[ServerCall alloc] init];
    
   // NSString *strAuth = @"Gg13IBmWkElwyE4KXN463V10BqJPz3jW|5";
    NSString *strMethod = @"PIN";
    NSString *strParam = [NSString stringWithFormat:@"%@", _txtPIN.text];
    NSString *strID = @"1";
    
    
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0",
                          @"jsonrpc",CONTROL_API_KEY, @"auth", strMethod, @"method", [NSArray arrayWithObjects:APPDELEGATE.strEmail, strParam, APPDELEGATE.mytokeninfo, @"1", nil], @"params",
                          strID, @"id", nil];
    
    NSLog(@"cosntrol api key test : %@", dict);
    
    APPDELEGATE.serverCall.delegate = self;
    [APPDELEGATE.serverCall requestServer:dict url:@"control"];

}


#pragma ServerCallDelegate

- (void) OnReceived: (NSDictionary*) dictData {
    
    NSLog(@"%@", dictData);
    
    //[Utilities showMsg:@"Login Success!"];
 
    
    APPDELEGATE.userSettingObj.user_id = (NSString*)[dictData objectForKey:@"result"];
    [APPDELEGATE saveUserSetting];
    
    APPDELEGATE.user_id = APPDELEGATE.userSettingObj.user_id;

    
    NSLog(@"user_id : %@", APPDELEGATE.user_id);
    
    LoginSuccessfulViewController *go = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginSuccessfulViewController"];
    [self.navigationController pushViewController:go animated:YES];
}

- (void) OnConnectFail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail!" message:@"Connection fail, Retry!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}

- (void) OnOffline
{
    OfflineViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineViewController"];
    [self.navigationController pushViewController:view animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
