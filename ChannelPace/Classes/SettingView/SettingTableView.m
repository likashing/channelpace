//
//  SettingTableView.m
//  ChannelPace
//
//  Created by eagle on 24/12/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "SettingTableView.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "EmailwithLogin.h"
#import "MBProgressHUD.h"
#import "DBImageView.h"


@interface SettingTableView ()

@end

@implementation SettingTableView


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [APPDELEGATE getAccountInfo];
    NSString *fName = APPDELEGATE.accountInfoObj.strFirstName;
    NSString *lName = APPDELEGATE.accountInfoObj.strSurName;
    NSString *cName = APPDELEGATE.accountInfoObj.strReallyCompanyName;
    _loggedin.text = [NSString stringWithFormat:@"Logged in as %@ %@ %@ \n Changing phones or job?", fName, lName, cName];
    
    APPDELEGATE.contactCount = 0;
    
//    BOOL OnOff;
//    
//    OnOff = APPDELEGATE.userSettingObj.bSyncAddress;
//    if (OnOff == YES) {
//        _syncSwitch.on = YES;
//    }
    
    [self customSetup];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    return 1;
}


#pragma mark Button Click Proc

/*- (IBAction)onSyncSwitch:(id)sender {
    
    if([sender isOn])
    {
        [MBProgressHUD showHUDAddedTo:self.view text:@"Please wait..." animated:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                       {
                           NSLog(@"Switch is ON");
                           NSMutableArray *infoArray = [[NSMutableArray alloc] init];
                           _dbhandler = [[DBHandler alloc] init];
                           [_dbhandler getMyContactsList:infoArray orderby:APPDELEGATE.userSettingObj.sortName];
                           
                           
                           for (AccountInfo *info in infoArray) {
                               ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
                               
                               if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
                                   ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                                       if (granted) {
                                           // First time access has been granted, add the contact
                                           [self checkExistContactInfo:info];
                                       } else {
                                           // User denied access
                                           // Display an alert telling user the contact could not be added
                                       }
                                   });
                               }
                               else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
                                   // The user has previously given access, add the contact
                                   [self checkExistContactInfo:info];
                               }
                               else {
                                   // The user has previously denied access
                                   // Send an alert telling user to change privacy setting in settings app
                               }
                               
                           }
                           APPDELEGATE.userSettingObj.bSyncAddress = YES;
                           [APPDELEGATE saveUserSetting];
                           [self hidenHUD];
                       });
    } else{
        
        NSLog(@"Switch is OFF");
        _syncSwitch.on = NO;
        APPDELEGATE.userSettingObj.bSyncAddress = NO;
        [APPDELEGATE saveUserSetting];
    }
    
}*/

- (IBAction)onUnpairBtn:(id)sender
{
   // [self OnRequest];
    
}


- (void) customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [_toggleBtn addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [revealViewController panGestureRecognizer];
        [revealViewController tapGestureRecognizer];
    }
}


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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail!" message:@"Server connection error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
    
}

//////////////////////////


#pragma mark Time Control Process
- (void) myContactRefreshTime: (NSString *)method
{
    if ([method isEqualToString:@"Daily"]) {
        _daily = [NSTimer scheduledTimerWithTimeInterval:86400 target:self selector:@selector(gotoRefreshViewController) userInfo:nil repeats:YES];
    } else if ([method isEqualToString:@"Throughout"]) {
        _hourly = [NSTimer scheduledTimerWithTimeInterval:14400 target:self selector:@selector(gotoRefreshViewController) userInfo:nil repeats:YES];
    } else if ([method isEqualToString:@"Manually"]) {
        _manually = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(gotoRefreshViewController) userInfo:nil repeats:NO];
    }
    
}

- (void) gotoRefreshViewController
{
    RefreshingViewController *view = [self.storyboard instantiateViewControllerWithIdentifier: @"RefreshingViewController"];
    [self.navigationController pushViewController:view animated:NO];
}

- (void) hidenHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}


#pragma mark Address Book Sync Part

- (void) importContactInfo: (AccountInfo *) info
{
    
    ABRecordRef person = ABPersonCreate(); // create a person
    
    CFErrorRef  anError = NULL;
    if (![info.strPhotoURL isEqualToString:@""]) {
        NSData *dataPhoto = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:info.strPhotoURL]];
        ABPersonSetImageData(person, (CFDataRef)dataPhoto, nil);

    }
    
    ABRecordSetValue(person, kABPersonFirstNameProperty, info.strFirstName , nil); // first name of the new person
    ABRecordSetValue(person, kABPersonLastNameProperty, info.strSurName, nil); // his last name
    
    ABRecordSetValue(person, kABPersonJobTitleProperty, info.strJobTitle, nil);
    ABRecordSetValue(person, kABPersonOrganizationProperty, info.strReallyCompanyName, nil);
    
    
    //---------------Add Emails here------------------//
        
    ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABPersonEmailProperty);
    ABMultiValueAddValueAndLabel(emailMultiValue, info.strEmail, kABHomeLabel, nil);
    //ABMultiValueAddValueAndLabel(emailMultiValue, [values objectAtIndex:10], kABWorkLabel, nil);
    ABRecordSetValue(person, kABPersonEmailProperty, emailMultiValue, nil);

    
    //---------------Add Notes here-------------------//
    NSString *strNote = [NSString stringWithFormat:@"From Channelpace App - %@", [APPDELEGATE getNowTime]];
    ABRecordSetValue(person, kABPersonNoteProperty, strNote, nil);
    
    
    //---------------Add Phonenumber here-------------//
    //Phone number is a list of phone number, so create a multivalue
    ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    if (![info.strMobile isEqualToString:@""]) {
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue, info.strMobile, kABPersonPhoneMobileLabel, NULL);
    }
    if (![info.strDirect isEqualToString:@""]) {
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue , info.strDirect,kABPersonPhoneWorkFAXLabel, NULL);
    }
    if (![info.strCompany isEqualToString:@""]) {
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue, info.strCompany, kABPersonPhoneMainLabel, NULL);
    }
    
    //ABMultiValueAddValueAndLabel(phoneNumberMultiValue, info.strEmail, kABOtherLabel, NULL);
    
    ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
    
    
    //-------Add URL(website) here-------------
    ABMutableMultiValueRef URLMultiValue = ABMultiValueCreateMutable(kABPersonURLProperty);
    ABMultiValueAddValueAndLabel(URLMultiValue, info.strCompWebsite, kABPersonHomePageLabel, nil);
    ABRecordSetValue(person, kABPersonURLProperty, URLMultiValue, nil);
    
    
    //-------Add Addresses here--------
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjects: [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@  %@, %@ %@ %@", info.strLevel, info.strStreet, info.strCity,info.strState, info.strPostal], nil]
                                                             forKeys: [NSArray arrayWithObjects:
                                                                       (NSString *)kABPersonAddressStreetKey, nil]];
    
    ABMultiValueRef addressMultiValue = ABMultiValueCreateMutable(kABDictionaryPropertyType);
    ABMultiValueAddValueAndLabel(addressMultiValue, (CFDictionaryRef *)dictionary, kABHomeLabel, nil);
    ABRecordSetValue(person, kABPersonAddressProperty, addressMultiValue, nil); ABRecordCopyValue(person, kABPersonAddressProperty);
    
    ABAddressBookRef addressBook = ABAddressBookCreate(); // create address book record
    
    ABAddressBookAddRecord(addressBook, person, &anError); //add the new person to the record
    NSLog(@"ABAddressBookAddRecord %@", anError);
    ABAddressBookSave(addressBook, &anError); //save the record
    NSLog(@"ABAddressBookAddRecord %@", anError);
    
    CFRelease(addressBook);
    CFRelease(person);
    CFRelease(addressMultiValue);
    CFRelease(phoneNumberMultiValue);
    
    
    [dictionary release];
    
    //[self ShowContact];
}

-(void)ShowContact
{
    ABPeoplePickerNavigationController *picker=[[ABPeoplePickerNavigationController alloc]init];
    picker.navigationBar.tintColor=[UIColor colorWithRed:.0 green:.3 blue:.5 alpha:.8];
    picker.peoplePickerDelegate=self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}


- (void) checkExistContactInfo: (AccountInfo *) info
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef all = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex n = ABAddressBookGetPersonCount(addressBook);
    int nRecordIndex = -1;
    ABRecordID recordID = 0;
    BOOL isPhoneNumberExist;
    isPhoneNumberExist = NO;
    for (int i = 0; i < n; i++) {
        ABRecordRef ref = CFArrayGetValueAtIndex(all, i);
        NSString *firstName = (NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        NSString *lastName = (NSString *) ABRecordCopyValue(ref, kABPersonLastNameProperty);
        
        if ([firstName isEqualToString: info.strFirstName] && [lastName isEqualToString:info.strSurName]) {
            recordID = ABRecordGetRecordID(ref);
            nRecordIndex = i;
        }
        
        ABMultiValueRef phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        for (CFIndex j = 0; j < ABMultiValueGetCount(phones); j++) {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
            CFStringRef locLabelRef = ABMultiValueCopyLabelAtIndex(phones, j);
            NSString *phoneLabelRef = (NSString *)ABAddressBookCopyLocalizedLabel(locLabelRef);
            
            NSString *phoneNumber = (NSString *)phoneNumberRef;
            if ([phoneNumber isEqualToString: info.strMobile]) {
                isPhoneNumberExist = YES;
            }
            CFRelease(phoneNumberRef);
            CFRelease(locLabelRef);
            NSLog(@" - %@ (%@)", phoneNumber, phoneLabelRef);
            [phoneNumber release];
        }
    }
    
    if (nRecordIndex != -1) {
        //		if (isPhoneNumberExist == NO) {
        ABRecordRef person = ABAddressBookGetPersonWithRecordID(addressBook, recordID);
        //Phone number is a list of phone number, so create a multivalue
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABPersonPhoneProperty);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue , info.strMobile,kABPersonPhoneMobileLabel, NULL);
      
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
        ABAddressBookSave(addressBook, nil); //save the record
        CFRelease(phoneNumberMultiValue);
        
        //[self ShowContact];
        
    }
    else {
        
        APPDELEGATE.contactCount ++;
        [self importContactInfo:info];
    
    }
    
    CFRelease(addressBook);
    
    
}


@end
