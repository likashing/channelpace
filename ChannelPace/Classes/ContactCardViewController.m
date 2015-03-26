//
//  ContactCardViewController.m
//  ChannelPace
//
//  Created by Eagle on 11/27/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "ContactCardViewController.h"
#import "AccountInfo.h"
#import "AppDelegate.h"
#import "ServerCall.h"
#import "OfflineViewController.h"
#import "FindCompanyViewController.h"
#import "MBProgressHUD.h"
#import "MyContactsViewController.h"



@interface ContactCardViewController ()

@end

@implementation ContactCardViewController


@synthesize firstName, surName, jobTitle, jobFunction, department, companyName, companyPhone, country, mobilePhone, directPhone, fax, email, reallyLongCompanyName, responsibility, level, address, industry;
@synthesize user_id;




- (void)viewDidLoad {
    
    [super viewDidLoad];
    _refreshHeaderView.delegate = self;
    
    dt = 8;
    
    // Do any additional setup after loading the view.
    [APPDELEGATE getUserAPIKEY];
    
    _inviteBtn.hidden = YES;
    _associateBtn.hidden = YES;
    _shareBtn.hidden = YES;
    
    [self getAccountInfo];
    
    [self checkPhoneStatus];
    [self initPullRefresh];
    
    //[contactTable reloadData];
}


- (void) checkUserStatus:(AccountInfo *)info
{
    
    if (USER_STATUS_CARD == _user_status) {
        _inviteBtn.hidden = NO;
    }
    if (userlastlogin != 0 && [info.bAssociated isEqual:@"0"]) {
        _associateBtn.hidden = NO;
    }
    if (USER_STATUS_CARD == _user_status || USER_STATUS_VALIDATED == _user_status || USER_STATUS_INACTIVE == _user_status) {
        _shareBtn.hidden = NO;
    }

}

- (void) checkPhoneStatus
{
    if ([mobilePhone.text isEqualToString:@""]) {
        _smsBtn.hidden = YES;
        _mobilephoneBtn.hidden = YES;
        _mobileLabel.hidden = YES;
    
    }
    if ([directPhone.text isEqualToString:@""]) {
        _directphoneBtn.hidden = YES;
        _directLabel.hidden = YES;
    }
    if ([companyPhone.text isEqualToString:@""]) {
        _companyphoneBtn.hidden = YES;
        _companyLabel.hidden = YES;
    }
    if ([fax.text isEqualToString:@""]) {
        _faxBtn.hidden = YES;
        _faxLabel.hidden = YES;
    }
    if ([email.text isEqualToString:@""]) {
        _emailBtn.hidden = YES;
    }

}

- (void) initPullRefresh
{
    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -10.0f - contactTable.bounds.size.height, self.view.frame.size.width, contactTable.bounds.size.height)];
        view.delegate = self;
        [contactTable addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    
}

- (void) labelSizeFormat: (AccountInfo *) info
{
    NSString *trimmedString = info.strJobTitle;
    NSString *str_temp = [trimmedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jobTitle.text = [str_temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    CGSize size = [jobTitle.text sizeWithFont:jobTitle.font constrainedToSize:CGSizeMake(jobTitle.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
    CGRect rect = jobTitle.frame;
    rect.size.height = size.height;
    jobTitle.frame = rect;
    
    
    NSString *trimmedDepa = info.strDepartment;
    NSString *str_temp1 = [trimmedDepa stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    department.text = [str_temp1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    size = [department.text sizeWithFont:department.font constrainedToSize:CGSizeMake(department.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
    rect = department.frame;
    rect.size.height = size.height;
    department.frame = rect;
    CGRect rectTemp1 = department.frame;
    rectTemp1.origin.y = jobTitle.frame.origin.y + jobTitle.frame.size.height + 10;
    department.frame = rectTemp1;
    
    
    trimmedString = info.strReallyCompanyName;
    str_temp = [trimmedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    companyName.text = [str_temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    size = [companyName.text sizeWithFont:companyName.font constrainedToSize:CGSizeMake(companyName.frame.size.width,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    rect = companyName.frame;
    rect.size.height = size.height;
    companyName.frame = rect;
    CGRect rectTemp2 = companyName.frame;
    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height + 10;
    companyName.frame = rectTemp2;
    
    //// MobilePhone Label Coordinate Proc
    if ([info.strMobile isEqual:@""]) {
        if ([info.strDirect isEqual:@""]) {
            if ([info.strCompany isEqual:@""]) {
                if ([info.strFax isEqual:@""]) {
                    rectTemp1 = email.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + 30;
                    email.frame = rectTemp1;
                    rectTemp1 = _emailLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + 30;
                    _emailLabel.frame = rectTemp1;
                    rectTemp1 = _emailBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + 30;
                    _emailBtn.frame = rectTemp1;
                } else {
                    rectTemp1 = _faxLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + 30;
                    _faxLabel.frame = rectTemp2;
                    rectTemp1 = fax.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + 30;
                    fax.frame = rectTemp2;
                    rectTemp1 = _faxBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + 30;
                    _faxBtn.frame = rectTemp1;
                    
                    rectTemp2 = email.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    email.frame = rectTemp2;
                    rectTemp2 = _emailLabel.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailLabel.frame = rectTemp2;
                    rectTemp2 = _emailBtn.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailBtn.frame = rectTemp2;
                }
            } else {
                rectTemp1 = _companyLabel.frame;
                rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + 30;
                _companyLabel.frame = rectTemp1;
                rectTemp1 = companyPhone.frame;
                rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + 30;
                companyPhone.frame = rectTemp1;
                rectTemp1 = _companyphoneBtn.frame;
                rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + 30;
                _companyphoneBtn.frame = rectTemp1;
                rectTemp2 = companyPhone.frame;
                
                if ([info.strFax isEqual:@""]) {
                    rectTemp1 = email.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    email.frame = rectTemp1;
                    rectTemp1 = _emailLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailLabel.frame = rectTemp1;
                    rectTemp1 = _emailBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailBtn.frame = rectTemp1;
                } else {
                    rectTemp1 = _faxLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxLabel.frame = rectTemp2;
                    rectTemp1 = fax.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    fax.frame = rectTemp2;
                    rectTemp1 = _faxBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxBtn.frame = rectTemp1;
                    
                    rectTemp2 = email.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    email.frame = rectTemp2;
                    rectTemp2 = _emailLabel.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailLabel.frame = rectTemp2;
                    rectTemp2 = _emailBtn.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailBtn.frame = rectTemp2;
                }

            
            }
        } else {
            rectTemp1 = _directLabel.frame;
            rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +30;
            _directLabel.frame = rectTemp1;
            rectTemp1 = directPhone.frame;
            rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +30;
            directPhone.frame = rectTemp1;
            rectTemp1 = _directphoneBtn.frame;
            rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +30;
            _directphoneBtn.frame = rectTemp1;
            rectTemp2 = directPhone.frame;
            
            if ([info.strCompany isEqual:@""]) {
                if ([info.strFax isEqual:@""]) {
                    rectTemp1 = email.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    email.frame = rectTemp1;
                    rectTemp1 = _emailLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailLabel.frame = rectTemp1;
                    rectTemp1 = _emailBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailBtn.frame = rectTemp1;
                } else {
                    rectTemp1 = _faxLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxLabel.frame = rectTemp2;
                    rectTemp1 = fax.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    fax.frame = rectTemp2;
                    rectTemp1 = _faxBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxBtn.frame = rectTemp1;
                    
                    rectTemp2 = email.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    email.frame = rectTemp2;
                    rectTemp2 = _emailLabel.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailLabel.frame = rectTemp2;
                    rectTemp2 = _emailBtn.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailBtn.frame = rectTemp2;
                }
            } else {
                rectTemp1 = _companyLabel.frame;
                rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                _companyLabel.frame = rectTemp1;
                rectTemp1 = companyPhone.frame;
                rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                companyPhone.frame = rectTemp1;
                rectTemp1 = _companyphoneBtn.frame;
                rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                _companyphoneBtn.frame = rectTemp1;
                rectTemp2 = companyPhone.frame;
                
                if ([info.strFax isEqual:@""]) {
                    rectTemp1 = email.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    email.frame = rectTemp1;
                    rectTemp1 = _emailLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailLabel.frame = rectTemp1;
                    rectTemp1 = _emailBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailBtn.frame = rectTemp1;
                } else {
                    rectTemp1 = _faxLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxLabel.frame = rectTemp2;
                    rectTemp1 = fax.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    fax.frame = rectTemp2;
                    rectTemp1 = _faxBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxBtn.frame = rectTemp1;
                    
                    rectTemp2 = email.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    email.frame = rectTemp2;
                    rectTemp2 = _emailLabel.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailLabel.frame = rectTemp2;
                    rectTemp2 = _emailBtn.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailBtn.frame = rectTemp2;
                }
                
                
            }

            
        }
    } else {
        rectTemp1 = _mobileLabel.frame;
        rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +30;
        _mobileLabel.frame = rectTemp1;
        rectTemp1 = mobilePhone.frame;
        rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +30;
        mobilePhone.frame = rectTemp1;
        rectTemp1 = _mobilephoneBtn.frame;
        rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +30;
        _mobilephoneBtn.frame = rectTemp1;
        rectTemp1 = _smsBtn.frame;
        rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +30;
        _smsBtn.frame = rectTemp1;
        
        rectTemp2 = mobilePhone.frame;
        
        if ([info.strDirect isEqual:@""]) {
            if ([info.strCompany isEqual:@""]) {
                if ([info.strFax isEqual:@""]) {
                    rectTemp1 = email.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    email.frame = rectTemp1;
                    rectTemp1 = _emailLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailLabel.frame = rectTemp1;
                    rectTemp1 = _emailBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailBtn.frame = rectTemp1;
                } else {
                    rectTemp1 = _faxLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxLabel.frame = rectTemp1;
                    rectTemp1 = fax.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    fax.frame = rectTemp1;
                    rectTemp1 = _faxBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxBtn.frame = rectTemp1;
                    
                    rectTemp2 = email.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    email.frame = rectTemp2;
                    rectTemp2 = _emailLabel.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailLabel.frame = rectTemp2;
                    rectTemp2 = _emailBtn.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailBtn.frame = rectTemp2;
                }
            } else {
                rectTemp1 = _companyLabel.frame;
                rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                _companyLabel.frame = rectTemp1;
                rectTemp1 = companyPhone.frame;
                rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                companyPhone.frame = rectTemp1;
                rectTemp1 = _companyphoneBtn.frame;
                rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                _companyphoneBtn.frame = rectTemp1;
                rectTemp2 = companyPhone.frame;
                
                if ([info.strFax isEqual:@""]) {
                    rectTemp1 = email.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    email.frame = rectTemp1;
                    rectTemp1 = _emailLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailLabel.frame = rectTemp1;
                    rectTemp1 = _emailBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailBtn.frame = rectTemp1;
                } else {
                    rectTemp1 = _faxLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxLabel.frame = rectTemp1;
                    rectTemp1 = fax.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    fax.frame = rectTemp1;
                    rectTemp1 = _faxBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxBtn.frame = rectTemp1;
                    
                    rectTemp2 = email.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    email.frame = rectTemp2;
                    rectTemp2 = _emailLabel.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailLabel.frame = rectTemp2;
                    rectTemp2 = _emailBtn.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailBtn.frame = rectTemp2;
                }
                
                
            }
        } else {
            rectTemp1 = _directLabel.frame;
            rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + dt;
            _directLabel.frame = rectTemp1;
            rectTemp1 = directPhone.frame;
            rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + dt;
            directPhone.frame = rectTemp1;
            rectTemp1 = _directphoneBtn.frame;
            rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + dt;
            _directphoneBtn.frame = rectTemp1;
            rectTemp2 = directPhone.frame;
            
            if ([info.strCompany isEqual:@""]) {
                if ([info.strFax isEqual:@""]) {
                    rectTemp1 = email.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    email.frame = rectTemp1;
                    rectTemp1 = _emailLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailLabel.frame = rectTemp1;
                    rectTemp1 = _emailBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailBtn.frame = rectTemp1;
                } else {
                    rectTemp1 = _faxLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxLabel.frame = rectTemp1;
                    rectTemp1 = fax.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    fax.frame = rectTemp1;
                    rectTemp1 = _faxBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxBtn.frame = rectTemp1;
                    
                    rectTemp2 = email.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    email.frame = rectTemp2;
                    rectTemp2 = _emailLabel.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailLabel.frame = rectTemp2;
                    rectTemp2 = _emailBtn.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailBtn.frame = rectTemp2;
                }
            } else {
                rectTemp1 = _companyLabel.frame;
                rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                _companyLabel.frame = rectTemp1;
                rectTemp1 = companyPhone.frame;
                rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                companyPhone.frame = rectTemp1;
                rectTemp1 = _companyphoneBtn.frame;
                rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                _companyphoneBtn.frame = rectTemp1;
                rectTemp2 = companyPhone.frame;
                
                if ([info.strFax isEqual:@""]) {
                    rectTemp1 = email.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    email.frame = rectTemp1;
                    rectTemp1 = _emailLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailLabel.frame = rectTemp1;
                    rectTemp1 = _emailBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _emailBtn.frame = rectTemp1;
                } else {
                    rectTemp1 = _faxLabel.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxLabel.frame = rectTemp1;
                    rectTemp1 = fax.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    fax.frame = rectTemp1;
                    rectTemp1 = _faxBtn.frame;
                    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height +dt;
                    _faxBtn.frame = rectTemp1;
                    
                    rectTemp2 = email.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    email.frame = rectTemp2;
                    rectTemp2 = _emailLabel.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailLabel.frame = rectTemp2;
                    rectTemp2 = _emailBtn.frame;
                    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height +dt;
                    _emailBtn.frame = rectTemp2;
                }
                
                
            }
            
            
        }

    }
    
    
    
    //// Button position proc
    CGRect rectEmail = email.frame;
    CGRect btnTemp = _inviteBtn.frame;
    btnTemp.origin.y = rectEmail.origin.y + rectEmail.size.height + 40;
    _inviteBtn.frame = btnTemp;
    btnTemp = _associateBtn.frame;
    btnTemp.origin.y = rectEmail.origin.y + rectEmail.size.height + 40;
    _associateBtn.frame = btnTemp;
    btnTemp = _shareBtn.frame;
    btnTemp.origin.y = rectEmail.origin.y + rectEmail.size.height + 40;
    _shareBtn.frame = btnTemp;
    
    
    rectTemp1 = reallyLongCompanyName.frame;
    rectTemp1.origin.y = btnTemp.origin.y + btnTemp.size.height + 30;
    reallyLongCompanyName.frame = rectTemp1;
    
    rectTemp2 = level.frame;
    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height + dt;
    level.frame = rectTemp2;
    
    rectTemp1 = _street.frame;
    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + dt;
    _street.frame = rectTemp1;
    
    rectTemp2 = address.frame;
    rectTemp2.origin.y = rectTemp1.origin.y + rectTemp1.size.height + dt;
    address.frame = rectTemp2;
    
    rectTemp1 = country.frame;
    rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height + dt;
    country.frame = rectTemp1;
    
    btnTemp = _websiteBtn.frame;
    btnTemp.origin.y = rectTemp1.origin.y + rectTemp1.size.height + 40;
    _websiteBtn.frame = btnTemp;
    btnTemp = _mapBtn.frame;
    btnTemp.origin.y = rectTemp1.origin.y + rectTemp1.size.height + 40;
    _mapBtn.frame = btnTemp;
    
    CGRect rectA, rectB;
    if ([info.strIndustry isEqual:@""]) {
        
        
        if ([info.strUserAbout isEqual:@""] || [info.strUserAbout isEqual:@"<null>"]) {
            
            
            if (![info.strJobFunction isEqual:@""]) {
                rectA = _jobFunctionLabel.frame;
                rectA.origin.y = btnTemp.origin.y + btnTemp.size.height + 30;
                _jobFunctionLabel.frame = rectA;
                rectB = jobFunction.frame;
                rectB.origin.y = rectA.origin.y + rectA.size.height + dt;
                jobFunction.frame = rectB;

            }
        } else {
            rectA = _responsibilityLabel.frame;
            rectA.origin.y = btnTemp.origin.y + btnTemp.size.height + 30;
            _responsibilityLabel.frame = rectA;
            
            trimmedString = info.strUserAbout;
            str_temp = [trimmedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            responsibility.text = [str_temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            size = [responsibility.text sizeWithFont:responsibility.font constrainedToSize:CGSizeMake(responsibility.frame.size.width,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            rect = responsibility.frame;
            rect.size.height = size.height;
            responsibility.frame = rect;
            rectTemp1 = responsibility.frame;
            rectTemp1.origin.y = rect.origin.y + rect.size.height;
            responsibility.frame = rectTemp1;

            rectB = responsibility.frame;
            rectB.origin.y = rectA.origin.y + rectA.size.height + dt;
            responsibility.frame = rectB;

        }
        
    } else {
        rectA = _industryLabel.frame;
        rectA.origin.y = btnTemp.origin.y + btnTemp.size.height + 30;
        _industryLabel.frame = rectA;
        
        trimmedString = info.strIndustry;
        str_temp = [trimmedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        industry.text = [str_temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        size = [industry.text sizeWithFont:industry.font constrainedToSize:CGSizeMake(industry.frame.size.width,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        rect = industry.frame;
        rect.size.height = size.height;
        industry.frame = rect;
        rectB = industry.frame;
        rectB.origin.y = rectA.origin.y + rectA.size.height + dt;
        industry.frame = rectB;
        
        if ([info.strUserAbout isEqual:@""] || [info.strUserAbout isEqual:@"<null>"]) {
           
            
            if (![info.strJobFunction isEqual:@""]) {
                rectB = industry.frame;
                
                rect = _jobFunctionLabel.frame;
                rect.origin.y = rectB.origin.y + rectB.size.height + 2*dt;
                _jobFunctionLabel.frame = rect;
                rectTemp1 = jobFunction.frame;
                rectTemp1.origin.y = rect.origin.y + rect.size.height;
                jobFunction.frame = rectTemp1;

            } else {
                
            }
            
        } else {
            
            rectTemp2 = _responsibilityLabel.frame;
            rectTemp2.origin.y = rectB.origin.y + rectB.size.height + 2*dt;
            _responsibilityLabel.frame = rectTemp2;
            
            trimmedString = info.strUserAbout;
            str_temp = [trimmedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            responsibility.text = [str_temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            size = [responsibility.text sizeWithFont:responsibility.font constrainedToSize:CGSizeMake(responsibility.frame.size.width,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            rect = responsibility.frame;
            rect.size.height = size.height;
            responsibility.frame = rect;
            rectTemp1 = responsibility.frame;
            rectTemp1.origin.y = rectTemp2.origin.y + rectTemp2.size.height;
            responsibility.frame = rectTemp1;
            
            rectA = _jobFunctionLabel.frame;
            rectA.origin.y = rectTemp1.origin.y + rectTemp1.size.height + 2*dt;
            _jobFunctionLabel.frame = rectA;
            rectB = jobFunction.frame;
            rectB.origin.y = rectA.origin.y + rectA.size.height;
            jobFunction.frame = rectB;
            
        }
    }
    
}

- (void) getAccountInfo
{
    AccountInfo *info = [[AccountInfo alloc] init];
    info = [APPDELEGATE.accountInfoArray objectAtIndex:APPDELEGATE.selectCellIndex];
    
    [self labelSizeFormat: info];
    self.firstName.text     = info.strFirstName;
    self.surName.text       = info.strSurName;
    self.jobTitle.text      = info.strJobTitle;
    
    if ([info.strDepartment isEqualToString:@"0"] || [info.strDepartment isEqualToString:@""]) {
        self.department.hidden = YES;
    } else {
        self.department.text    = info.strDepartment;
    }
    
    self.companyName.text   = info.strReallyCompanyName;
    self.mobilePhone.text   = info.strMobile;
    self.directPhone.text   = info.strDirect;
    self.companyPhone.text  = info.location_phone;
    self.fax.text           = info.strFax;
    self.email.text         = info.strEmail;
   
    
    if ([info.strIndustry isEqual:@""]) {
        self.industryLabel.hidden = YES;
    } else {
        self.industry.text      = info.strIndustry;
    }
    
    if ([info.strUserAbout isEqualToString:@""] || [info.strUserAbout isEqualToString:@"<null>"]) {
        self.responsibility.hidden = YES;
        self.responsibilityLabel.hidden = YES;
    } else {
        self.responsibility.text= info.strUserAbout;
    }
    
    if ([info.strJobFunction isEqual:@""]) {
        self.jobFunctionLabel.hidden = YES;
    } else {
        self.jobFunction.text   = info.strJobFunction;
    }
    
    
    self.reallyLongCompanyName.text = info.strReallyCompanyName;
    APPDELEGATE.companyName = info.strReallyCompanyName;
    
    self.level.text         = info.strLevel;
    self.street.text        = info.strStreet;
    
    if ([info.strCity isEqual:@""] && [info.strState isEqual:@""]) {
        self.address.text   = @"";
    } else {
        self.address.text       = [NSString stringWithFormat:@"%@ %@ %@",info.strCity, info.strState, info.strPostal];
    }
    self.country.text       = info.strCountry;
    
    userlastlogin           = info.user_last_login;
    
    APPDELEGATE.companyStreet = info.strStreet;
    APPDELEGATE.companyAddress = address.text;
    NSLog(@"company address : %@", APPDELEGATE.companyAddress);
    
    user_id = info.userID;
    _user_status = info.user_status;
    
    if (info.user_online == 1) {
        _accountImage.image = [UIImage imageNamed:@"no_photo_loggedin.png"];
    } else {
        _accountImage.image = [UIImage imageNamed:@"no_photo_neverloggedin.png"];
    }

    
    [_accountImage setImageURL:[NSURL URLWithString:info.strPhotoURL]];
    
    [self checkUserStatus: info];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Button Click Proc

- (IBAction)onInvite:(id)sender
{
    
    APPDELEGATE.serverCall = [[ServerCall alloc] init];
    
    _strMethod = [NSString stringWithFormat:@"invite"];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0", @"jsonrpc", APPDELEGATE.user_API_key, @"auth", _strMethod, @"method", [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld", (long)APPDELEGATE.sourceAccount.userID], nil], @"params", @"1", @"id", nil];
    
    APPDELEGATE.serverCall.delegate = self;
    [APPDELEGATE.serverCall requestServer:dict url:APPDELEGATE.url];
    
    APPDELEGATE.accountInfoObj.bInvite = true;
}

- (IBAction)onAssociate:(id)sender
{
    APPDELEGATE.serverCall = [[ServerCall alloc] init];
    
    _strMethod = [NSString stringWithFormat:@"reqassoc"];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"2.0", @"jsonrpc", APPDELEGATE.user_API_key, @"auth", _strMethod, @"method", [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@", APPDELEGATE.user_id], nil], @"params", @"1", @"id", nil];
    
    APPDELEGATE.serverCall.delegate = self;
    [APPDELEGATE.serverCall requestServer:dict url:APPDELEGATE.url];
    
    APPDELEGATE.accountInfoObj.bAssociated = @"1";
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123) {
        if (buttonIndex == 0) {
            _inviteBtn.hidden = YES;
            //APPDELEGATE.accountInfoObj.bInvite = false;
        }
    } else if (alertView.tag == 234) {
        if (buttonIndex == 0) {
            _associateBtn.hidden = YES;
            //APPDELEGATE.accountInfoObj.bAssociate = false;
        }
    } else if (alertView.tag == 111) {
        if (buttonIndex == 0) {
            
        } else if (buttonIndex == 1) {
        
        
        }
            
    }


}


- (IBAction)onShare:(id)sender
{
    
    
}

- (IBAction)onCompanyWebsite:(id)sender
{
    AccountInfo *info = [[AccountInfo alloc] init];
    info = [APPDELEGATE.accountInfoArray objectAtIndex:APPDELEGATE.selectCellIndex];
    
    NSURL *url = [ [ NSURL alloc ] initWithString: [NSString stringWithFormat:@"%@", info.strCompWebsite]];
    NSLog(@"%@", url);
    [[UIApplication sharedApplication] openURL:url];

}


- (IBAction)onMap:(id)sender
{
        FindCompanyViewController *go = [self.storyboard instantiateViewControllerWithIdentifier:@"FindCompany"];
        [self.navigationController pushViewController:go animated:YES];
    
}


-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
    
}


- (IBAction)onBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}


- (IBAction)onSMSClick:(id)sender
{
    
    [self sendSMS:@"" recipientList:[NSArray arrayWithObjects:mobilePhone.text, nil]];
    
}


- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
                
}

- (IBAction)onMobileBtn:(id)sender
{
    [self phoneCallFunc: mobilePhone.text];
    
}

- (IBAction)onDirectBtn:(id)sender
{

    [self phoneCallFunc:directPhone.text];
}

- (IBAction)onCompanyBtn:(id)sender
{
  
    [self phoneCallFunc:companyPhone.text];

}

- (IBAction)onFaxBtn:(id)sender
{
    [self phoneCallFunc:fax.text];
}

- (void) phoneCallFunc: (NSString *)tel
{
    
    NSString *deviceModel = [[UIDevice currentDevice] model];
    
    if ([deviceModel isEqualToString:@"iPhone"] || [deviceModel isEqualToString:@"iPhone 3G"] || [deviceModel isEqualToString:@"iPhone 3G S"] || [deviceModel isEqualToString:@"iPhone 4G"]) {
        
        NSString *nospaceTel = [tel stringByReplacingOccurrencesOfString:@" " withString:@""];
        tel = [@"tel://" stringByAppendingPathComponent:nospaceTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    }
}


- (IBAction)onEmailBtn:(id)sender
{
    NSString *emailTitle = @"";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:[NSString stringWithFormat: @"%@", email.text]];
    
    MFMailComposeViewController *mailcomposer = [[MFMailComposeViewController alloc] init];
    mailcomposer.mailComposeDelegate = self;
    [mailcomposer setSubject:emailTitle];
    [mailcomposer setMessageBody:messageBody isHTML:YES];
    [mailcomposer setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mailcomposer animated:YES completion:NULL];

    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark TableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}




#pragma mark ServerCall Recieve Proc

- (void) OnReceived:(NSDictionary *)dictData
{
    if (APPDELEGATE.accountInfoObj.bInvite) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invitation Sent." message:@"Your invitation has been sent." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 123;
        [alert show];
    }
    if ([APPDELEGATE.accountInfoObj.bAssociated isEqual:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request Sent." message:@"Your association request has been sent." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 234;
        [alert show];
        

    }
    APPDELEGATE.accountInfoObj.bInvite = false;
    APPDELEGATE.accountInfoObj.bAssociated = @"0";
}

- (void) OnConnectFail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Server connnection error." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    alert.tag = 345;
    [alert show];
    
    bInvite = false;
    bAssociate = false;
    
}

- (void) OnOffline
{
    OfflineViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflineViewController"];
    [self.navigationController pushViewController:view animated:YES];
    
}


- (IBAction)processTapAction:(id)sender {
    
    [textSearch resignFirstResponder];
}


#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
    
    [[MyContactsViewController SharedData] OnRequestMyContactsInfo];         // PGC
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    
}



#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    
    reloading = YES;
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    reloading = NO;
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:contactTable];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidUnload {

    _refreshHeaderView=nil;
    
}

- (void)dealloc {
    
    _refreshHeaderView = nil;
    [super dealloc];
}



@end
