//
//  ContactCardViewController.h
//  ChannelPace
//
//  Created by Eagle on 11/27/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"
#import "DBImageView.h"
#import "AsyncImageView.h"
#import "EGORefreshTableHeaderView.h"


enum  {
    
    USER_STATUS_CARD = 1,
    USER_STATUS_VALIDATED,
    USER_STATUS_BLACKLISTED,
    USER_STATUS_LEFT,
    USER_STATUS_INACTIVE
    
} USER_STATUS;


@interface ContactCardViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, ServerCallDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, EGORefreshTableHeaderDelegate>
{
    BOOL        bInvite;
    BOOL        bAssociate;    
    BOOL        reloading;
    IBOutlet UITableView *contactTable;
    
    UITextView *textSearch;
    int         userlastlogin;
    int         dt;
}

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;

@property (strong, nonatomic) IBOutlet UIView *normalView;
@property (strong, nonatomic) IBOutlet AsyncImageView *accountImage;
@property (strong, nonatomic) IBOutlet UILabel *firstName;
@property (strong, nonatomic) IBOutlet UILabel *surName;
@property (strong, nonatomic) IBOutlet UILabel *jobTitle;
@property (strong, nonatomic) IBOutlet UILabel *department;
@property (strong, nonatomic) IBOutlet UILabel *companyName;
@property (strong, nonatomic) IBOutlet UILabel *mobilePhone;
@property (strong, nonatomic) IBOutlet UILabel *directPhone;
@property (strong, nonatomic) IBOutlet UILabel *companyPhone;
@property (strong, nonatomic) IBOutlet UILabel *fax;
@property (strong, nonatomic) IBOutlet UILabel *email;
@property (strong, nonatomic) IBOutlet UILabel *reallyLongCompanyName;
@property (strong, nonatomic) IBOutlet UILabel *level;
@property (strong, nonatomic) IBOutlet UILabel *street;
@property (strong, nonatomic) IBOutlet UILabel *address;

@property (strong, nonatomic) IBOutlet UILabel *country;
@property (strong, nonatomic) IBOutlet UILabel *industryLabel;
@property (strong, nonatomic) IBOutlet UILabel *industry;
@property (strong, nonatomic) IBOutlet UILabel *responsibilityLabel;
@property (strong, nonatomic) IBOutlet UILabel *responsibility;
@property (strong, nonatomic) IBOutlet UILabel *jobFunctionLabel;
@property (strong, nonatomic) IBOutlet UILabel *jobFunction;
@property (strong, nonatomic) IBOutlet UILabel *industryChannel;


@property (strong, nonatomic) NSString *strAuth;
@property (strong, nonatomic) NSString *strMethod;
@property                     NSInteger user_id;
@property                     NSInteger user_status;


@property (strong, nonatomic) IBOutlet UIButton *inviteBtn;
@property (strong, nonatomic) IBOutlet UIButton *associateBtn;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UIButton *websiteBtn;
@property (strong, nonatomic) IBOutlet UIButton *mapBtn;


@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;
@property (strong, nonatomic) IBOutlet UILabel *directLabel;
@property (strong, nonatomic) IBOutlet UILabel *companyLabel;
@property (strong, nonatomic) IBOutlet UILabel *faxLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;

@property (strong, nonatomic) IBOutlet UIButton *smsBtn;
@property (strong, nonatomic) IBOutlet UIButton *mobilephoneBtn;
@property (strong, nonatomic) IBOutlet UIButton *directphoneBtn;
@property (strong, nonatomic) IBOutlet UIButton *companyphoneBtn;
@property (strong, nonatomic) IBOutlet UIButton *faxBtn;
@property (strong, nonatomic) IBOutlet UIButton *emailBtn;


- (IBAction)processTapAction:(id)sender;

- (IBAction)onBackBtn:(id)sender;
- (IBAction)onInvite:(id)sender;
- (IBAction)onAssociate:(id)sender;
- (IBAction)onShare:(id)sender;
- (IBAction)onCompanyWebsite:(id)sender;
- (IBAction)onMap:(id)sender;

- (IBAction)onSMSClick:(id)sender;
- (IBAction)onMobileBtn:(id)sender;
- (IBAction)onDirectBtn:(id)sender;
- (IBAction)onCompanyBtn:(id)sender;
- (IBAction)onFaxBtn:(id)sender;
- (IBAction)onEmailBtn:(id)sender;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void) checkUserStatus:(AccountInfo *)info;


@end
