//
//  AccountTableViewCell.h
//  ChannelPace
//
//  Created by Eagle on 11/27/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "DBImageView.h"


@interface AccountTableViewCell : UITableViewCell
{

}

@property (strong, nonatomic) IBOutlet DBImageView *accountImage;
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelJobTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelDepartment;
@property (strong, nonatomic) IBOutlet UILabel *firstName;
@property (strong, nonatomic) IBOutlet UILabel *lastName;


@end
