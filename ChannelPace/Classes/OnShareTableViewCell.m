//
//  OnShareTableViewCell.m
//  ChannelPace
//
//  Created by Eagle on 12/15/14.
//  Copyright (c) 2014 Damian. All rights reserved.
//

#import "OnShareTableViewCell.h"

@implementation OnShareTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _accountImage = [[DBImageView alloc] initWithFrame:CGRectMake(17, 0, 75, 80)];
    //[accountImage setPlaceHolder:[UIImage imageNamed:@"no_photo_loggedin.png"]];
    
    [self addSubview:_accountImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
