//
//  SettingTableView.h
//  ChannelPace
//
//  Created by eagle on 24/12/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ServerCall.h"
#import "DBHandler.h"



@interface SettingTableView : UITableViewController < ServerCallDelegate, ABPersonViewControllerDelegate, ABPeoplePickerNavigationControllerDelegate>



@property (nonatomic, strong) DBHandler *dbhandler;
@property (strong, nonatomic) IBOutlet UIButton *toggleBtn;
//@property (strong, nonatomic) IBOutlet UISwitch *syncSwitch;
@property (strong, nonatomic) IBOutlet UILabel *loggedin;


@property (strong, nonatomic) NSTimer *daily;
@property (strong, nonatomic) NSTimer *hourly;
@property (strong, nonatomic) NSTimer *manually;


- (IBAction)onSyncSwitch:(id)sender;
- (IBAction)onUnpairBtn:(id)sender;

@end
