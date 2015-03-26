//
//  EmailwithLogin.m
//  ChannelPace
//
//  Created by Eagle on 11/24/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "EmailwithLogin.h"
#import "AppDelegate.h"
#import "PINEnterController.h"
#import "Global.h"
#import "OfflineViewController.h"



@interface EmailwithLogin () <ServerCallDelegate, UITextFieldDelegate>
{

    IBOutlet UIButton *goBtn;
    
}


@end

@implementation EmailwithLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    [_txtEmail becomeFirstResponder];
    
    [self checkUnpaired];
    
    [_txtEmail setDelegate:self];
    
    
    [_txtEmail setReturnKeyType:UIReturnKeyDone];
    //_txtEmail.text = @"damian@channelpace.com";
}

- (void) checkUnpaired {
    
    if (APPDELEGATE.isUnpaired || APPDELEGATE.isLoggedIn) {
        _txtEmail.text = APPDELEGATE.strEmail;
        APPDELEGATE.isUnpaired = NO;
        [APPDELEGATE saveLoginInfo];
    }
}

- (void)dismissKeyboard {
    
    [_txtEmail resignFirstResponder];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self OnRequest];
    [self dismissKeyboard];
    return YES;
}

- (IBAction) onClickGo:(id)sender
{
    NSString *str = _txtEmail.text;
    if ([str isEqualToString:@""] || [str isEqualToString:@" "]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Please enter a your Email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
        
    } else {
        [self dismissKeyboard];
        [self OnRequest];
    }
    
    
}

- (IBAction)tapGesture:(id)sender {
    [self dismissKeyboard];
}

- (void) OnRequest
{
     APPDELEGATE.serverCall = [[ServerCall alloc] init];
     
     NSString *strMethod = @"email";
     APPDELEGATE.strEmail = [NSString stringWithFormat:@"%@", _txtEmail.text];
     NSString *strID = @"1";
     
    
     NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0",
     @"jsonrpc",CONTROL_API_KEY, @"auth", strMethod, @"method", [NSArray arrayWithObjects:APPDELEGATE.strEmail, nil], @"params",
     strID, @"id", nil];
     NSLog(@"%@", dict);
     
     APPDELEGATE.serverCall.delegate = self;
     [APPDELEGATE.serverCall requestServer:dict url:@"control"];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ServerCallDelegate

- (void) OnReceived: (NSDictionary*) dictData {
    
    NSLog(@"%@", dictData);

    //[Utilities showMsg:@"Successfully logged in!"];
    
    NSDictionary *dict = [dictData objectForKey:@"result"];
    APPDELEGATE.PIN = [NSString stringWithFormat:@"%@",dict];
    
    PINEnterController *go = [self.storyboard instantiateViewControllerWithIdentifier:@"PINEnterController"];
    [self.navigationController pushViewController:go animated:NO];
    
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

@end


