//
//  AssociationTableViewCell.h
//  ChannelPace
//
//  Created by Eagle on 11/27/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCall.h"



@interface AssociationTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *labelJobTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelCompanyName;
@property (strong, nonatomic) IBOutlet UILabel *firstName;
@property (strong, nonatomic) IBOutlet UILabel *lastName;

@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIButton *approveBtn;


@property  int assoc_action;



@end
