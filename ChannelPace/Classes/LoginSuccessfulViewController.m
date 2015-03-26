//
//  LoginSuccessfulViewController.m
//  ChannelPace
//
//  Created by Eagle on 11/24/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "LoginSuccessfulViewController.h"
#import "SVProgressHUD.h"

#import "EmailwithLogin.h"
#import "OfflineViewController.h"
#import "AppDelegate.h"
#import "NSString+md5.h"


@interface LoginSuccessfulViewController ()

@end

@implementation LoginSuccessfulViewController

@synthesize dbHandler, arrayAccountData;

static LoginSuccessfulViewController *sharedData = nil;

+ (LoginSuccessfulViewController *) SharedData
{
    if (!sharedData) {
        sharedData = [[LoginSuccessfulViewController alloc] init];
    }
    return sharedData;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    bSaveDatabase = false;
    
    [self OnRequestMyContactsInfo];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) navigate
{
    
    [self performSegueWithIdentifier:@"goContacts" sender:self];
    
}

- (void) OnRequestMyContactsInfo
{
    APPDELEGATE.serverCall = [[ServerCall alloc] init];
    
    APPDELEGATE.user_API_key = [NSString stringWithFormat:@"%@|%@", APPDELEGATE.user_id, [[NSString stringWithFormat:@"%@%@", [APPDELEGATE.strEmail md5],[APPDELEGATE.mytokeninfo md5]] md5]];
    [APPDELEGATE saveUserAPIKEY];
    
    NSString *strMethod = @"contacts";
    NSString *strID = @"1";
    
    NSLog(@"user_apiKey : %@", APPDELEGATE.user_API_key);
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0",
                          @"jsonrpc", APPDELEGATE.user_API_key, @"auth", strMethod, @"method",
                          strID, @"id", nil];

   
        
    
    APPDELEGATE.serverCall.delegate = self;
    [APPDELEGATE.serverCall requestServer:dict url:APPDELEGATE.url];
    
}

- (void) OnReceived: (NSDictionary*) dictData {
    
    NSLog(@"%@", dictData);
    
    if (!bSaveDatabase) {
        [self getAccountInfo:dictData];
        
        dbHandler = [[DBHandler alloc] init];
        [dbHandler insertMyContactsList: APPDELEGATE.accountInfoArray];
        [self OnRequestMyInfo];
        
    } else {
        
        [self getMydetailInfo:dictData];
        
        [self navigate];
    }
    
}

- (void) OnConnectFail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Server connnection error." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.tag = 123;
    [alert show];

}

- (void) OnOffline
{
    OfflineViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineViewController"];
    [self.navigationController pushViewController:view animated:YES];

}

- (void) OnRequestMyInfo
{
    APPDELEGATE.serverCall = [[ServerCall alloc] init];
    
    NSString *strMethod = @"self";
    NSString *strID = @"1";
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0",
                          @"jsonrpc", APPDELEGATE.user_API_key, @"auth", strMethod, @"method",
                          strID, @"id", nil];
    NSLog(@"MyDetail Data : %@", dict);
    
    APPDELEGATE.serverCall.delegate = self;
    [APPDELEGATE.serverCall requestServer:dict url:APPDELEGATE.url];
    
    bSaveDatabase = true;
    
}


- (void) getMydetailInfo:(NSDictionary *)dictData
{
    
    NSDictionary *dictItem = [dictData valueForKey:@"result"];
    
    AccountInfo *info = [[AccountInfo alloc] init];
    
    info.strPhotoURL                = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"cdn_photo"]]];
    info.strFirstName               = [dictItem objectForKey:@"user_name_f"];
    info.strSurName                 = [dictItem objectForKey:@"user_name_l"];
    info.strJobTitle                = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_job_position"]]];
    info.strDepartment              = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"comp_dept"]]];
    info.strMobile                  = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_phone_mobile"]]];
    info.strDirect                  = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_phone_office"]]];
    info.strCompany                 = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"location_phone"]]];
    info.strFax                     = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_fax"]]];
    info.strEmail                   = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_email"]]];
    info.strUserAbout               = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_about"]]];
    info.strJobFunction             = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"job_function"]]];
    info.user_last_login            = [[dictItem objectForKey:@"user_last_login"] integerValue];
    info.user_mgr_email             = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_mgr_email"]]];

    info.strCompanyName             = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"comp_name_shot"]]];
    info.strReallyCompanyName       = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"comp_name"]]];
    info.strIndustry                = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"industry_channel"]]];
    info.strCountry                 = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"country"]]];
    
    info.location_phone             = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"location_phone"]]];//
    
    NSDictionary *dictAddress = [dictItem valueForKey:@"location_address"];
    
    info.strLevel                   = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictAddress objectForKey:@"level"]]];
    info.strStreet                  = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictAddress objectForKey:@"street"]]];
    info.strCity                    = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictAddress objectForKey:@"city"]]];
    info.strState                   = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictAddress objectForKey:@"state"]]];
    info.strPostal                  = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictAddress objectForKey:@"postal"]]];
    info.strAddress                 = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictAddress objectForKey:@"address"]]]; //

    

    APPDELEGATE.accountInfoObj = info;
    [APPDELEGATE saveAccountInfo];
    
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123) {
        if (buttonIndex == 0) { // means share button pressed
            // write your code here to do whatever you want to do once the share button is pressed
            EmailwithLogin *go = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailwithLogin"];
            [self.navigationController pushViewController: go animated:YES];
        }
    }
    
    
}

- (void) getAccountInfo:(NSDictionary *)dictData
{
    
    NSArray *dict = [dictData objectForKey:@"result"];
    for (int i = 0; i < dict.count; i++)
    {
        NSDictionary *dictItem = [dict objectAtIndex:i];
        if (![dictItem objectForKey:@"full_name"]) {
            continue;
        }
        AccountInfo *info   = [[AccountInfo alloc] init];
        info.userID         = [[dictItem objectForKey:@"user_id"] integerValue];
        info.strPhotoURL    = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"cdn_photo"]]];
        info.strFullName    = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"full_name"]]];
        info.strFirstName   = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_name_f"]]];
        info.strSurName     = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_name_l"]]];
        info.strJobTitle    = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_job_position"]]];
        info.strMobile      = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_phone_mobile"]]];
        info.strDirect      = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_phone_office"]]];
        info.strCompany     = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"location_phone"]]];
        info.strFax         = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_fax"]]];
        info.strEmail       = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_email"]]];
        info.strJobFunction = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"job_function"]]];
        info.index          = (NSInteger)i;
        info.user_status    = [[self getNotNullValue:[dictItem objectForKey:@"user_status"]] integerValue];
        
        //////////////
        
        info.prod_id                = [[self getNotNullValue:[dictItem objectForKey:@"prod_id"]] integerValue];
        info.user_channel_group     = [[self getNotNullValue:[dictItem objectForKey:@"user_channel_group"]] integerValue];
        info.user_comp_admin        = [[self getNotNullValue:[dictItem objectForKey:@"user_comp_admin"]] integerValue];
        info.user_cpadmin           = [[self getNotNullValue:[dictItem objectForKey:@"user_cpadmin"]] integerValue];
        info.user_job_satisfaction  = [[self getNotNullValue:[dictItem objectForKey:@"user_job_satisfaction"] ]integerValue];
        info.user_last_active       = [[self getNotNullValue:[dictItem objectForKey:@"user_last_active"]] integerValue];
        info.user_last_bill         = [[self getNotNullValue:[dictItem objectForKey:@"user_last_bill"]] integerValue];
        info.user_last_interaction  = [[self getNotNullValue:[dictItem objectForKey:@"user_last_interaction"] ]integerValue];
        info.user_last_login        = [[self getNotNullValue:[dictItem objectForKey:@"user_last_login"]] integerValue];
        info.user_online            = [[self getNotNullValue:[dictItem objectForKey:@"user_online"]] integerValue];
        info.user_phone_ext         = [[self getNotNullValue:[dictItem objectForKey:@"user_phone_ext"]] integerValue];
        info.user_recruitment       = [[self getNotNullValue:[dictItem objectForKey:@"user_recruitment"]] integerValue];
        info.user_sub_type          = [[self getNotNullValue:[dictItem objectForKey:@"user_sub_type"]] integerValue];
        info.comp_dept           = [self getNotNullValue: [NSString stringWithFormat:@"%@", [dictItem objectForKey:@"comp_dept"]]];
        info.user_country           = [self getNotNullValue: [NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_country"]]];
        info.user_expiry_comp       = [self getNotNullValue: [NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_expiry_comp"]]];
        info.user_expiry_date       = [self getNotNullValue: [NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_expiry_date"]]];
        info.user_joined            = [self getNotNullValue: [NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_joined"]]];
        info.user_lang              = [self getNotNullValue: [NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_lang"]]];
        info.user_mgr_email         = [self getNotNullValue: [NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_mgr_email"]]];
        info.user_personal_email    = [self getNotNullValue: [NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_personal_email"]]];
        info.user_personal_facebook = [self getNotNullValue: [NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_personal_facebook"]]];
        info.user_personal_linkedin = [self getNotNullValue: [NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_personal_linkedin"]]];
        info.user_personal_twitter  = [self getNotNullValue: [NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_personal_twitter"]]];
        info.strUserAbout           = [self getNotNullValue: [NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_about"]]];
        
        info.strDepartment          = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"comp_dept"]]];
        info.strCompanyName         = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"comp_name_short"]]];
        info.strCompWebsite         = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"comp_website"]]];//
        info.strCountry             = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"country"]]];//
        info.strIndustry            = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"industry_channel"]]];//
        info.strReallyCompanyName   = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"comp_name"]]];//
        info.comp_about             = [self getNotNullValue:[dictItem objectForKey:@"comp_about"]];//
        
        /////////////////////////////////////Address
        info.location_phone               = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"location_phone"]]];//
        info.comp_joined              = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"comp_joined"]]];//
        info.comp_country                = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"comp_country"]]]; //
        info.user_call_phone               = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"user_call_phone"]]]; //
        info.cdn_logo              = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"cdn_logo"]]]; //
        
        info.bAssociated = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"associated"]]];
        
        
        info.strAddress             = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictItem objectForKey:@"address"]]]; //
            
        NSDictionary *dictAddress = [dictItem valueForKey:@"location_address"];
        
        info.strLevel                   = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictAddress objectForKey:@"level"]]];
        info.strStreet                  = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictAddress objectForKey:@"street"]]];
        info.strCity                    = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictAddress objectForKey:@"city"]]];
        info.strState                   = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictAddress objectForKey:@"state"]]];
        info.strPostal                  = [self getNotNullValue:[NSString stringWithFormat:@"%@", [dictAddress objectForKey:@"postal"]]];
        info.strAddress                 = [self getNotNullValue:[dictAddress objectForKey:@"address"]]; //
        
        
        
        APPDELEGATE.accountInfoObj = info;
        [APPDELEGATE.accountInfoArray addObject:info];
        
    }
    
}

- (NSString *) getNotNullValue:(NSObject *) param
{
    if (param == [NSNull null])
    {
        return @"";
    }
    
    return (NSString *)param;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
