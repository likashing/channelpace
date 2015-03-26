//
//  AccountInfo.h
//  MySportalent
//
//  Created by Mountain on 6/7/13.
//  Copyright (c) 2013 Mountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountInfo : NSObject

@property                   NSInteger           userID;
@property                   NSInteger           mail_id;
@property                   NSInteger           index;
@property (nonatomic, strong) NSString*         strFullName;
@property (nonatomic, strong) NSString*         strFirstName;
@property (nonatomic, strong) NSString*         strSurName;
@property (nonatomic, strong) NSString*         strJobTitle;
@property (nonatomic, strong) NSString*         strDepartment;
@property (nonatomic, strong) NSString*         strCompanyName;
@property (nonatomic, strong) NSString*         strMobile;
@property (nonatomic, strong) NSString*         strDirect;
@property (nonatomic, strong) NSString*         strCompany;
@property (nonatomic, strong) NSString*         strFax;
@property (nonatomic, strong) NSString*         strEmail;
@property (nonatomic, strong) NSString*         strReallyCompanyName;
@property (nonatomic, strong) NSString*         location_phone;

@property (nonatomic, strong) NSString*         strLevel;
@property (nonatomic, strong) NSString*         strStreet;
@property (nonatomic, strong) NSString*         strCity;
@property (nonatomic, strong) NSString*         strPostal;
@property (nonatomic, strong) NSString*         strState;
@property (nonatomic, strong) NSString*         strAddress;
@property (nonatomic, strong) NSString*         strCountry;
@property (nonatomic, strong) NSString*         strPhotoURL;
@property (nonatomic, strong) NSString*         strIndustry;
@property (nonatomic, strong) NSString*         strUserAbout;
@property (nonatomic, strong) NSString*         strJobFunction;
@property (nonatomic, strong) NSString*         strCompWebsite;
@property                     NSInteger         user_status;

@property (nonatomic, strong) NSString*         user_call_phone;
@property (nonatomic, strong) NSString*         cdn_logo;


@property                     NSInteger         prod_id;
@property                     NSInteger         user_channel_group;
@property                     NSInteger         user_comp_admin;
@property                     NSInteger         user_cpadmin;
@property                     NSInteger         user_job_satisfaction;
@property                     NSInteger         user_last_active;
@property                     NSInteger         user_last_bill;
@property                     NSInteger         user_last_interaction;
@property                     NSInteger         user_last_login;
@property                     NSInteger         user_online;
@property                     NSInteger         user_phone_ext;
@property                     NSInteger         user_recruitment;
@property                     NSInteger         user_sub_type;

@property (nonatomic, strong) NSString*         comp_dept;
@property (nonatomic, strong) NSString*         user_country;
@property (nonatomic, strong) NSString*         user_expiry_comp;
@property (nonatomic, strong) NSString*         user_expiry_date;
@property (nonatomic, strong) NSString*         user_joined;
@property (nonatomic, strong) NSString*         user_lang;
@property (nonatomic, strong) NSString*         user_mgr_email;
@property (nonatomic, strong) NSString*         user_personal_email;
@property (nonatomic, strong) NSString*         user_personal_facebook;
@property (nonatomic, strong) NSString*         user_personal_linkedin;
@property (nonatomic, strong) NSString*         user_personal_twitter;
@property (nonatomic, strong) NSString*         user_about;

@property                     NSInteger         comp_billing_id;
@property                     NSInteger         comp_billing_type;
@property                     NSInteger         comp_id;
@property                     NSInteger         comp_industry_channel;
@property                     NSInteger         comp_status;
@property                     NSInteger         comp_email_autoadd;

@property (nonatomic, strong) NSString*         channel_description;
@property (nonatomic, strong) NSString*         comp_about;
@property (nonatomic, strong) NSString*         comp_country;
@property (nonatomic, strong) NSString*         comp_channel_role;
@property (nonatomic, strong) NSString*         comp_facebook;
@property (nonatomic, strong) NSString*         comp_joined;
@property (nonatomic, strong) NSString*         comp_timezone;

@property                     BOOL              bInvite;
@property (nonatomic, strong) NSString*         bAssociated;


@property (nonatomic, strong) NSDictionary*     dictApplicantsInfo;
@property (nonatomic, strong) NSDictionary*     dictFollowing;

@end
