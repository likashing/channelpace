//
//  MyDetailsViewController.h
//  ChannelPace
//
//  Created by Eagle on 12/1/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCall.h"
#import "AsyncImageView.h"
#import "DBImageView.h"


@interface MyDetailsViewController : UIViewController
{

    IBOutlet UIButton *toggleBtn;
}


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


@property (strong, nonatomic) IBOutlet UILabel *industry;
@property (strong, nonatomic) IBOutlet UILabel *resposiblityLabel;
@property (strong, nonatomic) IBOutlet UILabel *responsibility;
@property (strong, nonatomic) IBOutlet UILabel *jobFunctionLabel;
@property (strong, nonatomic) IBOutlet UILabel *jobFunction;


@end
