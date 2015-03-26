//
//  MyDetailsViewController.m
//  ChannelPace
//
//  Created by Eagle on 12/1/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "MyDetailsViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"



@implementation MyDetailsViewController

@synthesize normalView, accountImage;
@synthesize firstName, surName, jobTitle, jobFunction, department, companyName, companyPhone, country, mobilePhone, directPhone, fax, email, reallyLongCompanyName, responsibility, level, address, industry;

- (void) viewDidLoad
{
    
    [super viewDidLoad];
    
    [APPDELEGATE getUserAPIKEY];
    //[APPDELEGATE getLoginInfo];
   
    [self selectDataPosition];
    
    [self customSetup];
    
}

- (void) labelFormat: (AccountInfo*) info
{
    NSString *trimmedString = info.strJobTitle;
    NSString *str_temp = [trimmedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jobTitle.text = [str_temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    CGSize size = [jobTitle.text sizeWithFont:jobTitle.font constrainedToSize:CGSizeMake(jobTitle.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
    CGRect rect = jobTitle.frame;
    rect.size.height = size.height;
    jobTitle.frame = rect;
    
    CGRect rectTemp1 = jobTitle.frame;
    
    if ([info.strDepartment isEqualToString:@""] || [info.strDepartment isEqualToString:@"0"]) {
        department.hidden = YES;
        
    } else {
        
        NSString *trimmedDepa = info.strDepartment;
        NSString *str_temp1 = [trimmedDepa stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        department.text = [str_temp1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        size = [department.text sizeWithFont:department.font constrainedToSize:CGSizeMake(department.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
        rect = department.frame;
        rect.size.height = size.height;
        department.frame = rect;
        rectTemp1 = department.frame;
        rectTemp1.origin.y = jobTitle.frame.origin.y + jobTitle.frame.size.height + 10;
        department.frame = rectTemp1;

    }
    
    
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

    
    trimmedString = info.strIndustry;
    str_temp = [trimmedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    industry.text = [str_temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    size = [industry.text sizeWithFont:industry.font constrainedToSize:CGSizeMake(industry.frame.size.width,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    rect = industry.frame;
    rect.size.height = size.height;
    industry.frame = rect;
    
    CGRect rect00 = industry.frame;
    if ([info.strUserAbout isEqual:@""] || [info.strUserAbout isEqual:@"<null>"]) {
        _resposiblityLabel.hidden = YES;
        responsibility.hidden = YES;
    } else {
        rectTemp1 = _resposiblityLabel.frame;
        rectTemp1.origin.y = rect.origin.y + rect.size.height + 10;
        _resposiblityLabel.frame = rectTemp1;
        
        NSString *trimmed = info.strUserAbout;
        NSString *stemp = [trimmed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        responsibility.text = [stemp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        size = [responsibility.text sizeWithFont:responsibility.font constrainedToSize:CGSizeMake(responsibility.frame.size.width,MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        rect00 = responsibility.frame;
        rect00.size.height = size.height;
        responsibility.frame = rect00;
    }
    
    
    
    CGRect rect1 = _jobFunctionLabel.frame;
    rect1.origin.y = rect00.origin.y + rect00.size.height + 10;
    _jobFunctionLabel.frame = rect1;
    
    rect = jobFunction.frame;
    rect.origin.y = rect1.origin.y + rect1.size.height + 7;
    jobFunction.frame = rect;

}

- (void) selectDataPosition
{
    [APPDELEGATE getAccountInfo];
    [self displayData:APPDELEGATE.accountInfoObj];

}

- (void) displayData: (AccountInfo *)info
{
    firstName.text             = info.strFirstName;
    surName.text               = info.strSurName;
    //jobTitle.text              = info.strJobTitle;
    //department.text            = info.strDepartment;
    //companyName.text           = info.strReallyCompanyName;
    mobilePhone.text           = info.strMobile;
    directPhone.text           = info.strDirect;
    companyPhone.text          = info.location_phone;
    fax.text                   = info.strFax;
    email.text                 = info.strEmail;
    reallyLongCompanyName.text = info.strReallyCompanyName;
    country.text               = info.strCountry;
    industry.text              = info.strIndustry;
    
    if ([info.strUserAbout isEqual:@""]) {
        _resposiblityLabel.hidden = YES;
    } else {
        responsibility.text        = info.strUserAbout;
    }
    
    jobFunction.text           = info.strJobFunction;
    
    level.text                 = info.strLevel;
    _street.text               = info.strStreet;
    address.text               = [NSString stringWithFormat:@"%@, %@ %@", info.strCity,info.strState, info.strPostal];
    
    self.accountImage.image = [UIImage imageNamed:@"no_photo_loggedin.png"];
    [accountImage setImageURL:[NSURL URLWithString:info.strPhotoURL]];
    
    [self labelFormat: info];

}


- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [toggleBtn addTarget:revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [revealViewController panGestureRecognizer];
        [revealViewController tapGestureRecognizer];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
