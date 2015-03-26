//
//  OnShareTableViewCell.h
//  ChannelPace
//
//  Created by Eagle on 12/15/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBImageView.h"


@interface OnShareTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet DBImageView *accountImage;
@property (strong, nonatomic) IBOutlet UILabel *fName;
@property (strong, nonatomic) IBOutlet UILabel *lName;
@property (strong, nonatomic) IBOutlet UILabel *jobTitle;
@property (strong, nonatomic) IBOutlet UILabel *company;



@end
