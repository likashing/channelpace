//
//  UnpairingView.m
//  ChannelPace
//
//  Created by eagle on 26/12/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "UnpairingView.h"
#import "AppDelegate.h"
#import "EmailwithLogin.h"



@interface UnpairingView ()

@end

@implementation UnpairingView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Button Proc

- (IBAction)onCancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)onUnpairDevice:(id)sender {
    [self OnRequest];
    
}



//////////////////////////====================///////////////////////
#pragma mark ServerCallDelegate

- (void) OnRequest
{
    APPDELEGATE.serverCall = [[ServerCall alloc] init];
    [APPDELEGATE getUserAPIKEY];
    
    NSString *strMethod = [NSString stringWithFormat:@"unpair"];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0", @"jsonrpc", APPDELEGATE.user_API_key, @"auth", strMethod, @"method", @"1", @"id", nil];
    
    APPDELEGATE.serverCall.delegate = self;
    [APPDELEGATE.serverCall requestServer:dict url:APPDELEGATE.url];
    
}

- (void) OnReceived: (NSDictionary*) dictData
{
    
    NSLog(@"%@", dictData);    
    
    APPDELEGATE.isLoggedIn = NO;
    APPDELEGATE.isUnpaired = YES;
    [APPDELEGATE saveLoginInfo];
    
    DBHandler *dbhandler = [[DBHandler alloc] init];
    [dbhandler deleteAllMyContactsList];
    
    [self navigate];
}

- (void) navigate
{
    EmailwithLogin *go = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailwithLogin"];
    [self.navigationController pushViewController:go animated:NO];
}

- (void) OnConnectFail
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail!" message:@"Server connnection error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    
}






@end
